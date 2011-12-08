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
#include "database.h"

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

    void addNewVideoInfoQML(float latitude, float longitude, int speed);
    float getVideoInfoLatitude(const QString &videoName, int videoId);
    float getVideoInfoLongitude(const QString &videoName, int videoId);
    int getVideoInfoSpeed(const QString &videoName, int videoId);

    void startRecording();
    void stopRecording();
    void pauseRecording();
    void start();
    void stop();
    void unload();

    Database* getDatabase();

protected slots:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    void durationChangedFunc(qint64 duration);

private:
    void addNewVideo(const QString& videoName, int videoParts);
    void addNewVideoInfo(const QString& videoName, float latitude, float longitude, int speed);
    void removeVideo(const QString& videoName);
    void addNewVideoPart(const QString& videoName);
    void getCurrentVideoName(QString& videoName);

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

    Database *Db;
};

#endif // QDeclarativeCamera_H
