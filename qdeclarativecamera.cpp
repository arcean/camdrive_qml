#include "qdeclarativecamera.h"
#include <QGraphicsVideoItem>


QDeclarativeCamera::QDeclarativeCamera(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    camera_(0),
    viewfinder_(0)
{
    firstCamera = true;
    toggleCamera();
    connect(viewfinder_, SIGNAL(nativeSizeChanged(QSizeF)), this, SLOT(viewfinderSizeChanged(QSizeF)));
}

QDeclarativeCamera::~QDeclarativeCamera()
{
    camera_->unload();
    delete viewfinder_;
    delete camera_;
}

void QDeclarativeCamera::initFile()
{
    timer = new QTimer(this);
    //Default time interval - 10m = 10 * 60 * 1000,
    //It should be configurable, and loaded on app startup
    timer->setInterval(10 * 60 * 1000);

    file = new File(CAM_DEFAULT_FILE_NAME);

    connect(timer, SIGNAL(timeout()), this, SLOT(changeUsedFile()));
    setOutputLocation();
}

void QDeclarativeCamera::changeUsedFile()
{
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
    qDebug() << "setOutputLocation refd: " << QDir::toNativeSeparators(file->getActiveFile());
    mediaRecorder_->record();
     qDebug() << "HMM error: " << mediaRecorder_->errorString();
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
        firstCamera = true;
    }
    else {
        viewfinder_ = new QGraphicsVideoItem(this);
       // viewfinder_->setAspectRatioMode(Qt::IgnoreAspectRatio);
        camera_ = new QCamera("primary");
        camera_->setViewfinder(viewfinder_);
        camera_->setCaptureMode(QCamera::CaptureVideo);
        mediaRecorder_ = new QMediaRecorder(camera_);
        firstCamera = false;
    }
    connect(viewfinder_, SIGNAL(nativeSizeChanged(QSizeF)), this, SLOT(viewfinderSizeChanged(QSizeF)));
    viewfinder_->setSize(geometry.size());

    QAudioEncoderSettings audioSettings;
    audioSettings.setCodec("audio/AAC");
    QVideoEncoderSettings encoderSettings;
    encoderSettings.setCodec("video/mpeg4");
    encoderSettings.setQuality(QtMultimediaKit::HighQuality);
    mediaRecorder_->setEncodingSettings(audioSettings, encoderSettings);
    mediaRecorder_->setMuted(true);
    camera_->start();

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
}

void QDeclarativeCamera::stop()
{
    camera_->stop();
}

void QDeclarativeCamera::unload()
{
    camera_->unload();
}