#ifndef QDECLARATIVEFRONTCAMERA_H
#define QDECLARATIVEFRONTCAMERA_H

#include <QDeclarativeItem>
#include <QCamera>
#include <QCameraViewfinder>
#include <QCameraImageCapture>
#include <QMediaRecorder>
#include <QDir>
#include <QTimer>

#include "file.h"

#define CAM_DEFAULT_FILE_NAME "camdrive_file"

class QGraphicsVideoItem;
class QDeclarativeFrontCamera : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(Qt::AspectRatioMode aspectRatio READ aspectRatio WRITE setAspectRatio)

public:
    explicit QDeclarativeFrontCamera(QDeclarativeItem *parent = 0);
    ~QDeclarativeFrontCamera();

    Qt::AspectRatioMode aspectRatio() const;
    void setAspectRatio(const Qt::AspectRatioMode& aspectRatio);
    void initFile();
    void setOutputLocation();

signals:


public slots:
    void viewfinderSizeChanged(const QSizeF& size);
    void toggleCamera();
    void changeUsedFile();

    void startRecording();
    void stopRecording();
    void pauseRecording();
    void start();
    void stop();
    void unload();

protected slots:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

private:
    QCamera* camera_;
    QCameraImageCapture* imageprocessing_;
    QGraphicsVideoItem* viewfinder_;
    Qt::AspectRatioMode aspectRatio_;
    QMediaRecorder* mediaRecorder_;
    QRectF geometry;
    bool firstCamera;
    File *file;
    QTimer *timer;
};

#endif // QDECLARATIVEFRONTCAMERA_H
