#ifndef QDeclarativeCamera_H
#define QDeclarativeCamera_H

#include <QDeclarativeItem>
#include <QCamera>
#include <QCameraViewfinder>
#include <QCameraImageCapture>
#include <QMediaRecorder>
#include <QDir>
#include <QTimer>

#include "file.h"
#include "settings.h"

#define CAM_DEFAULT_FILE_NAME "camdrive_file"

class QGraphicsVideoItem;
class QDeclarativeCamera : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(Qt::AspectRatioMode aspectRatio READ aspectRatio WRITE setAspectRatio)

public:
    explicit QDeclarativeCamera(QDeclarativeItem *parent = 0);
    ~QDeclarativeCamera();

    Qt::AspectRatioMode aspectRatio() const;
    void setAspectRatio(const Qt::AspectRatioMode& aspectRatio);
    void initFile();
    void setOutputLocation();

signals:
    void durationChanged(qint64 duration);
    void videoPartNumberChanged(int videoPartNumber);

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
    void durationChangedFunc(qint64 duration);

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
    Settings *settingsObject;
    bool isRecording;
    int videoPartNumber;
};

#endif // QDeclarativeCamera_H
