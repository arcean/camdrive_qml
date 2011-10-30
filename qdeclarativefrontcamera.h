#ifndef QDECLARATIVEFRONTCAMERA_H
#define QDECLARATIVEFRONTCAMERA_H

#include <QDeclarativeItem>
#include <QCamera>
#include <QCameraViewfinder>
#include <QCameraImageCapture>

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

signals:


public slots:
    void viewfinderSizeChanged(const QSizeF& size);
    void toggleCamera();

    void start();
    void stop();

protected slots:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

private:
    QCamera* camera_;
    QCameraImageCapture* imageprocessing_;
    QGraphicsVideoItem* viewfinder_;
    Qt::AspectRatioMode aspectRatio_;
    QRectF geometry;
    bool firstCamera;
};

#endif // QDECLARATIVEFRONTCAMERA_H
