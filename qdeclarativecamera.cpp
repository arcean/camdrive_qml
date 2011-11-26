#include "qdeclarativecamera.h"
#include <QGraphicsVideoItem>


QDeclarativeCamera::QDeclarativeCamera(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    camera_(0),
    viewfinder_(0)
{
    settingsObject = new Settings();
    firstCamera = true;
    toggleCamera();
}

QDeclarativeCamera::~QDeclarativeCamera()
{
    camera_->unload();
    delete viewfinder_;
    delete camera_;
    delete settingsObject;
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
    //int time = settingsObject->getStoreLast();
    //time = time * 60 * 1000;
    int time = 1 * 60 * 1000;
    timer->setInterval(time);

    file = new File(CAM_DEFAULT_FILE_NAME);
    videoPartNumber = 0;

    connect(timer, SIGNAL(timeout()), this, SLOT(changeUsedFile()));
    setOutputLocation();
}

void QDeclarativeCamera::changeUsedFile()
{
    videoPartNumber++;
    if(videoPartNumber >= settingsObject->getStoreLast())
        this->stopRecording();
    qDebug() << "Changing used temp file for recording...";
    this->stopRecording();
    file->changeFile();
    setOutputLocation();
    this->startRecording();
    qDebug() << "Changing temp file: DONE";
}

/**
  Set Output Location
*/
void QDeclarativeCamera::setOutputLocation()
{
    qDebug() << "setOutputLocation: " << QDir::toNativeSeparators(file->getActiveFile());
   qDebug() << "setOutputLocation succ: " << mediaRecorder_->setOutputLocation(QDir::toNativeSeparators(file->getActiveFile()));
}

/**
  Start recording
*/
void QDeclarativeCamera::startRecording()
{
    if(!isRecording)
        return;
    qDebug() << "setOutputLocation refd: " << QDir::toNativeSeparators(file->getActiveFile());
    mediaRecorder_->record();
     qDebug() << "HMM error: " << mediaRecorder_->errorString();
    if(!settingsObject->getEnableContinousRecording())
        timer->start();
}

/**
  Pause recording process
*/
void QDeclarativeCamera::pauseRecording()
{
    timer->stop();
    mediaRecorder_->pause();
}

void QDeclarativeCamera::stopRecording()
{
    timer->stop();
    mediaRecorder_->stop();
    file->fileReady();
}

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
        //viewfinder_->setAspectRatioMode(Qt::IgnoreAspectRatio);
        camera_ = new QCamera("secondary");
        camera_->setViewfinder(viewfinder_);
        camera_->setCaptureMode(QCamera::CaptureVideo);
        mediaRecorder_ = new QMediaRecorder(camera_);
        //firstCamera = true;
    }
    else {
        viewfinder_ = new QGraphicsVideoItem(this);
       // viewfinder_->setAspectRatioMode(Qt::IgnoreAspectRatio);
        camera_ = new QCamera("primary");
        camera_->setViewfinder(viewfinder_);
        camera_->setCaptureMode(QCamera::CaptureVideo);
        mediaRecorder_ = new QMediaRecorder(camera_);
        //firstCamera = false;
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
  //  start();
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
    else
    {
    }
}

Qt::AspectRatioMode QDeclarativeCamera::aspectRatio() const
{
    return aspectRatio_;
}

void QDeclarativeCamera::start()
{
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

    toggleCamera();
    camera_->unload();
}
