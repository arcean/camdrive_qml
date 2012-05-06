#ifndef ACCELEROMETER_H
#define ACCELEROMETER_H

#include <QObject>
#include <QtSensors/QAccelerometer>
#include <QtSensors/QAccelerometerReading>

#define MIN_TRESHOLD 5
#define MID_TRESHOLD 6
#define MAX_TRESHOLD 7.5

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

signals:
    void newReading();
    void alarm(int alarmLevel, int collisionSide);

public slots:
    void start();
    void stop();
    void changeTresholdTo(int treshold_level);

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

    QAccelerometer *accelerometer;
    int min_treshold;
    int alarmFlag;

    float maxX;
    float maxY;
    float maxZ;

};

#endif // ACCELEROMETER_H
