#ifndef ACCELEROMETER_H
#define ACCELEROMETER_H

#include <QObject>
#include <QtSensors/QAccelerometer>
#include <QtSensors/QAccelerometerReading>
#include "settings.h"

#define MIN_TRESHOLD 6
#define MID_TRESHOLD 8
#define MAX_TRESHOLD 10

#define MIN_G_TRESHOLD 9.6
#define MAX_G_TRESHOLD 10.5

//! Collision name, alarmLevel
#define COLL_FRONT 1
#define COLL_LEFT 2
#define COLL_RIGHT 3
#define COLL_REAR 4

QTM_USE_NAMESPACE

class Accelerometer : public QObject
{
    Q_OBJECT
public:
    explicit Accelerometer(QObject *parent = 0);

    void setSettings(Settings *settings);
    void setSpeed(int speed);

signals:
    void newReading();
    void alarm(int alarmLevel, int collisionSide);

public slots:
    void start();
    void stop();

    void changeTresholdTo(int treshold_level);
    void updateIgnoreTreshold();

    float getX();
    float getY();
    float getZ();

private slots:
    void readingChanged();

private:
    void parseReading();
    bool checkMinTreshold(qreal value);
    bool isGTreshold(qreal value);
    int phase1_checkMinTreshold();
    int phase1_checkG(bool checkMinTreshold);
    bool check22G(qreal value);
    int phase1_check22G();
    void setCollisionSide();
    bool isSpeedProper();

    QAccelerometer *accelerometer;
    float min_treshold;
    float backup_treshold;
    int alarmFlag;

    float maxX;
    float maxY;
    float maxZ;

    int lastSpeed;

    //! Settings object
    Settings *settings;

};

#endif // ACCELEROMETER_H
