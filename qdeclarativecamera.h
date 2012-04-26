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
#include "accelerometer.h"
#include "gps.h"

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
    void createVideoDetailsTable(const QString &name);
    void gpsUpdated();
    void alarm(int alarmLevel);

public slots:
    void viewfinderSizeChanged(const QSizeF& size);
    void setGps(Gps *gps);
    void setAccelerometer(Accelerometer *accelerometer);
    void setDatabase(Database *db);

    void toggleCamera();
    void changeUsedFile();

    void startRecording(bool ignoreCurrentVideoCounter);
    void stopRecording();
    void pauseRecording();
    void start();
    void stop();
    void unload();

    bool enableNightMode(bool enable);
    bool enableInfinityFocus(bool enable);

protected slots:
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    void durationChangedFunc(qint64 duration);

private slots:
    void storeData();
    void gpsUpdatedSlot();
    void connectAccelerometerSlot(int alarmLevel);

private:
    void getCurrentVideoName(QString& videoName);
    void getDateTime(QString &dateTime);
    void storeNewVideo(const QString& videoName, int videoParts);

    QCamera* camera_;
    QCameraImageCapture* imageprocessing_;
    QGraphicsVideoItem* viewfinder_;
    Qt::AspectRatioMode aspectRatio_;
    QMediaRecorder* mediaRecorder_;
    QRectF geometry;
    bool firstCamera;
    File *file;
    QTimer *timer;
    QTimer *storeDataTimer;
    Settings *settingsObject;
    bool isRecording;
    bool isRecordingInParts;
    int videoPartNumber;

    Database *Db;
    Accelerometer *accelerometer;
    Gps *gps;
};

#endif // QDeclarativeCamera_H
