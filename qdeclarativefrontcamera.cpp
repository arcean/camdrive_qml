#include "qdeclarativefrontcamera.h"
#include <QGraphicsVideoItem>


QDeclarativeFrontCamera::QDeclarativeFrontCamera(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    camera_(0),
    viewfinder_(0)
{
    firstCamera = true;
    toggleCamera();
    connect(viewfinder_, SIGNAL(nativeSizeChanged(QSizeF)), this, SLOT(viewfinderSizeChanged(QSizeF)));
}

QDeclarativeFrontCamera::~QDeclarativeFrontCamera()
{
    camera_->unload();
    delete viewfinder_;
    delete camera_;
    delete mediaRecorder_;
}

void QDeclarativeFrontCamera::toggleCamera()
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

void QDeclarativeFrontCamera::viewfinderSizeChanged(const QSizeF& size)
{
    setImplicitWidth(size.width());
    setImplicitHeight(size.height());
}

void QDeclarativeFrontCamera::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    geometry = newGeometry;
    viewfinder_->setSize(geometry.size());
    QDeclarativeItem::geometryChanged(newGeometry, oldGeometry);
}

void QDeclarativeFrontCamera::setAspectRatio(const Qt::AspectRatioMode &aspectRatio)
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

Qt::AspectRatioMode QDeclarativeFrontCamera::aspectRatio() const
{
    return aspectRatio_;
}

void QDeclarativeFrontCamera::start()
{
    camera_->start();
}

void QDeclarativeFrontCamera::stop()
{
    camera_->stop();
}

void QDeclarativeFrontCamera::unload()
{
    camera_->unload();
}
