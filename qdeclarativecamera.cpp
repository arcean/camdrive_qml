#include <QGraphicsVideoItem>
#include <QDateTime>
#include <QCameraExposure>

#include "qdeclarativecamera.h"

QDeclarativeCamera::QDeclarativeCamera(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    camera_(0),
    viewfinder_(0)
{
    settingsObject = new Settings();
    firstCamera = true;
    Db = new Database();
    accelerometer = new Accelerometer();
    gps = new Gps();

    connect (gps, SIGNAL(updated()), this, SLOT(gpsUpdatedSlot()));
    connect (accelerometer, SIGNAL(alarm(int,int)), this, SLOT(connectAccelerometerSlot(int,int)));

    toggleCamera();
    gps->start();
}

QDeclarativeCamera::~QDeclarativeCamera()
{
    if(viewfinder_)
        delete viewfinder_;

    if(settingsObject)
        delete settingsObject;
/*
    if(camera_) {
        camera_->unload();
        //delete camera_;
    }
 */
}

void QDeclarativeCamera::connectAccelerometerSlot(int alarmLevel, int collisionSide)
{
    this->alarmFlag = collisionSide;
    emit alarm(alarmLevel, collisionSide);
}

void QDeclarativeCamera::gpsUpdatedSlot()
{
    emit gpsUpdated();
}

void QDeclarativeCamera::setGps(Gps *gps)
{
    this->gps = gps;
}

void QDeclarativeCamera::setAccelerometer(Accelerometer *accelerometer)
{
    this->accelerometer = accelerometer;
}

void QDeclarativeCamera::setDatabase(Database *db)
{
    this->Db = db;
}

void QDeclarativeCamera::durationChangedFunc(qint64 duration)
{
    emit durationChanged(duration);
}

void QDeclarativeCamera::initFile()
{
    timer = new QTimer(this);
    //Default time interval - 10m = 10 * 60 * 1000,
    //It should be configurable, and loaded on app startup
    int time = settingsObject->getStoreLast();
    time = (time * 60 * 1000);
    //int time = 1 * 60 * 1000;
    timer->setInterval(time);
    qDebug() << "TIMER: set to" << time;

    storeDataTimer = new QTimer(this);
    /* TODO: Make it configurable, currently 1 sec. */
    storeDataTimer->setInterval(1000);

    file = new File(CAM_DEFAULT_FILE_NAME, settingsObject, Db);
    videoPartNumber = 0;
    isRecordingInParts = false;

    connect(timer, SIGNAL(timeout()), this, SLOT(changeUsedFile()));
    connect(storeDataTimer, SIGNAL(timeout()), this, SLOT(storeData()));
    setOutputLocation();
}

void QDeclarativeCamera::changeUsedFile()
{
    videoPartNumber++;

    if (videoPartNumber > 1)
        videoPartNumber = 0;

    emit videoPartNumberChanged(videoPartNumber);
    qDebug() << "Changing used temp file for recording...";
    this->stopRecording();
    file->changeFile(videoPartNumber);
    setOutputLocation();

    /* Create a table for the new video part. */
    QString baseName = file->getGeneratedFileName();
    QString name = baseName + "_part_" + QString::number(videoPartNumber+1);
    Db->createVideoDetailsTable(name);

    this->startRecording(true);
    qDebug() << "Changing temp file: DONE";
}

/**
  Set Output Location
*/
void QDeclarativeCamera::setOutputLocation()
{
    QDir::toNativeSeparators(file->getActiveFile());
    mediaRecorder_->setOutputLocation(QDir::toNativeSeparators(file->getActiveFile()));
}

/**
  Start recording
*/
void QDeclarativeCamera::startRecording(bool ignoreCurrentVideoCounter)
{
    if(!isRecording)
        return;

    Db->openDatabase();
    Db->createTables();
    //! Reset collision side flag.
    alarmFlag = 0;
    accelerometer->start();

    /* Increase counter, used to replace old video files. */
    if (!ignoreCurrentVideoCounter) {
        file->deleteTheOldestFiles();
    }

    if(!isRecordingInParts) {
        /* Create entry in main table for our new video. */
        /* Since 0.0.2 there're only 2 parts of the video. */
        //int videoParts = settingsObject->getStoreLastInMinutes();
        int videoParts = 2;
        this->storeNewVideo(file->getGeneratedFileName(), videoParts);
        /* And now we want entries for the first part of the video. */
        QString baseName = file->getGeneratedFileName();
        QString name = baseName + "_part_" + QString::number(videoPartNumber+1);
        Db->createVideoDetailsTable(name);

        isRecordingInParts = true;
    }
    /* ============================================ */

    storeDataTimer->start();
    mediaRecorder_->record();
    if(settingsObject->getStoreLast() != 0)
        timer->start();
}

/**
  Pause recording process
*/
void QDeclarativeCamera::pauseRecording()
{
    storeDataTimer->stop();
    timer->stop();
    mediaRecorder_->pause();
}

void QDeclarativeCamera::stopRecording()
{
    storeDataTimer->stop();
    timer->stop();
    mediaRecorder_->stop();
    file->fileReady();
    accelerometer->stop();
   // Db->closeDatabase();
}

/*
 * Initialize camera and load settings.
 */
void QDeclarativeCamera::toggleCamera()
{
    if(mediaRecorder_) {
        mediaRecorder_->stop();
        delete mediaRecorder_;
    }
    if(camera_) {
        camera_->unload();
        delete camera_;
    }
    if(viewfinder_)
        delete viewfinder_;

    if(!firstCamera) {
        viewfinder_ = new QGraphicsVideoItem(this);
        camera_ = new QCamera("secondary");
        camera_->setViewfinder(viewfinder_);
        camera_->setCaptureMode(QCamera::CaptureVideo);
        mediaRecorder_ = new QMediaRecorder(camera_);
    }
    else {
        viewfinder_ = new QGraphicsVideoItem(this);
        camera_ = new QCamera("primary");
        camera_->setViewfinder(viewfinder_);
        camera_->setCaptureMode(QCamera::CaptureVideo);
        mediaRecorder_ = new QMediaRecorder(camera_);
    }
    connect(viewfinder_, SIGNAL(nativeSizeChanged(QSizeF)), this, SLOT(viewfinderSizeChanged(QSizeF)));
    connect(mediaRecorder_, SIGNAL(durationChanged(qint64)), this, SLOT(durationChangedFunc(qint64)));
    viewfinder_->setSize(geometry.size());

    QAudioEncoderSettings audioSettings;
    audioSettings.setCodec("audio/AAC");
    if(settingsObject->getAudioQuality() == 0)
        audioSettings.setQuality(QtMultimediaKit::LowQuality);
    else if(settingsObject->getAudioQuality() == 2)
        audioSettings.setQuality(QtMultimediaKit::HighQuality);
    else
        audioSettings.setQuality(QtMultimediaKit::NormalQuality);

    QVideoEncoderSettings encoderSettings;
    encoderSettings.setCodec("video/mpeg4");
    if(settingsObject->getVideoQuality() == 0)
        encoderSettings.setQuality(QtMultimediaKit::LowQuality);
    else if(settingsObject->getVideoQuality() == 2)
        encoderSettings.setQuality(QtMultimediaKit::HighQuality);
    else
        encoderSettings.setQuality(QtMultimediaKit::NormalQuality);

    if(settingsObject->getVideoResolution() == 0)
        encoderSettings.setResolution(640, 480);
    else if(settingsObject->getVideoResolution() == 2)
        encoderSettings.setResolution(1280, 720);
    else
        encoderSettings.setResolution(848, 480);

    mediaRecorder_->setEncodingSettings(audioSettings, encoderSettings);
    mediaRecorder_->setMuted(settingsObject->getEnableAudio());

    initFile();
}

void QDeclarativeCamera::viewfinderSizeChanged(const QSizeF& size)
{
    setImplicitWidth(size.width());
    setImplicitHeight(size.height());
}

void QDeclarativeCamera::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    geometry = newGeometry;
    viewfinder_->setSize(geometry.size());
    QDeclarativeItem::geometryChanged(newGeometry, oldGeometry);
}

void QDeclarativeCamera::setAspectRatio(const Qt::AspectRatioMode &aspectRatio)
{
    if(aspectRatio == Qt::IgnoreAspectRatio)
        viewfinder_->setAspectRatioMode(aspectRatio);
    else if(aspectRatio == Qt::KeepAspectRatio)
        viewfinder_->setAspectRatioMode(aspectRatio);
    else if(aspectRatio == Qt::KeepAspectRatioByExpanding)
        viewfinder_->setAspectRatioMode(aspectRatio);
    else {
        /* Nothing yet. */
    }
}

Qt::AspectRatioMode QDeclarativeCamera::aspectRatio() const
{
    return aspectRatio_;
}

bool QDeclarativeCamera::enableInfinityFocus(bool enable)
{
    if (camera_->focus()) {
        if(enable) {
            /* Force infinity focus. */
            camera_->focus()->setFocusMode(QCameraFocus::InfinityFocus);
        }
        else {
            /* Revert to auto focus. */
            camera_->focus()->setFocusMode(QCameraFocus::AutoFocus);
        }
        /* Return success. */
        return true;
    }

    return false;
}

bool QDeclarativeCamera::enableNightMode(bool enable)
{
    if (camera_->exposure()) {
        if(enable) {
            /* Force night mode exposure. */
            camera_->exposure()->setExposureMode(QCameraExposure::ExposureNight);
        }
        else {
            /* Revert to auto mode exposure. */
            camera_->exposure()->setExposureMode(QCameraExposure::ExposureAuto);
        }
        /* Return success. */
        return true;
    }

    return false;
}

void QDeclarativeCamera::start()
{
    toggleCamera();
    camera_->start();
    isRecording = true;
}

void QDeclarativeCamera::stop()
{
    isRecording = false;
    camera_->stop();
}

void QDeclarativeCamera::unload()
{
    isRecording = false;

    camera_->unload();
}

void QDeclarativeCamera::getDateTime(QString &dateTime)
{
    QDateTime dt = QDateTime::currentDateTime();
    dateTime = dt.toString("dd.MM.yyyy");
    dateTime += " ";
    dateTime += dt.toString("hh:mm:ss");
}

/* Store details about current video file. */
void QDeclarativeCamera::storeData()
{
    QString videoName = "";
    getCurrentVideoName(videoName);

    /* Take care of specialCode, currently alarmFlag. */
    Db->addNewVideoInfo(videoName, gps->getLatitude(), gps->getLongitude(), gps->getSpeed(),
                        accelerometer->getX(), accelerometer->getY(), accelerometer->getZ(), this->alarmFlag);
}

/* Create entry for new video file. */
void QDeclarativeCamera::storeNewVideo(const QString& videoName, int videoParts)
{
    QString dt;
    getDateTime(dt);

    Db->addNewVideo(videoName, videoParts, dt);
}

void QDeclarativeCamera::getCurrentVideoName(QString& videoName)
{
    videoName = file->getGeneratedFileName() + "_part_" + QString::number(videoPartNumber + 1);
}
