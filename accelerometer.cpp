#include "accelerometer.h"
#include <QDebug>

Accelerometer::Accelerometer(QObject *parent) :
    QObject(parent)
{
    accelerometer = new QAccelerometer();
    min_treshold = MID_TRESHOLD;
    connect(accelerometer, SIGNAL(readingChanged()), this, SLOT(readingChanged()));
}

void Accelerometer::changeTresholdTo(int treshold_level)
{
    switch (treshold_level) {
    case 0:
        min_treshold = MIN_TRESHOLD;
        break;
    case 1:
        min_treshold = MID_TRESHOLD;
        break;
    case 2:
        min_treshold = MAX_TRESHOLD;
        break;
    default:
        min_treshold = MID_TRESHOLD;
    }
}

void Accelerometer::readingChanged()
{
    /* Check if there's an alarm condition. */
    parseReading();

    emit newReading();
}

void Accelerometer::parseReading()
{
    // Check, if there's one value > G + min_treshold -> ALARM
    int result_phase1G = phase1_checkG(true);
    int result_phase2G = phase1_checkG(false);
    int result_phase2MinTreshold = phase1_checkMinTreshold();
    int result_phase22G = phase1_check22G();

    if (result_phase1G > 0) {
        //TODO: Alarm
        qDebug() << "result_phase1G triggered:" << "ALARM";
        setCollisionSide();
        //! It's PROBABLY ALARM, let's add 10 to alarmFlag
        if (alarmFlag < 10)
            alarmFlag += 10;
        qDebug() << "ALARMflag:" << alarmFlag;

        emit alarm(0, alarmFlag);
    }
    // Check if there's one G, and the other > min_treshold -> ALARM
    else if (result_phase2G > 0 && result_phase2MinTreshold > 1 && result_phase22G == 0) {
        //TODO: Alarm
        qDebug() << "result_phase2G and result_phase2MinTreshold triggered:" << "ALARM";
        setCollisionSide();
        //! It's PROBABLY ALARM, let's add 10 to alarmFlag
        if (alarmFlag < 10)
            alarmFlag += 10;
        qDebug() << "ALARMflag:" << alarmFlag;

        emit alarm(0, alarmFlag);
    }
    // If there's one > 22G (max hw value) -> EMERGENCY_ALARM
    else if (result_phase22G > 0){
        //TODO: Alarm, Emergency alarm
        qDebug() << "Emergency 22G ALARM";
        setCollisionSide();
        qDebug() << "ALARMflag:" << alarmFlag;

        emit alarm(1, alarmFlag);
    }
    else {
        //Do nothing
       // qDebug() << "nothing";
    }

}

void Accelerometer::setCollisionSide()
{
    qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();

    if (abs(y) > abs(z)) {
        //! Side collision

        //! Left side
        if (y > 0)
            alarmFlag = COLL_LEFT;
        //! Right side
        else if (y < 0)
            alarmFlag = COLL_RIGHT;
    }
    else if (abs(y) < abs(z)) {

        //! Front
        if (y > 0)
            alarmFlag = COLL_FRONT;
        //! Rear
        else if (y < 0)
            alarmFlag = COLL_REAR;
    }
}

int Accelerometer::phase1_check22G()
{
    qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();

    int counter = 0;

    if (check22G(y))
        counter++;
    if (check22G(z))
        counter++;

    return counter;
}

int Accelerometer::phase1_checkMinTreshold()
{
    qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();

    int counter = 0;

    if (checkMinTreshold(y))
        counter++;
    if (checkMinTreshold(z))
        counter++;

    return counter;
}

int Accelerometer::phase1_checkG(bool checkMinTreshold)
{
    qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();
    int counter = 0;

    if (checkMinTreshold) {
        if (y >= 0)
            y -= min_treshold;
        else
            y += min_treshold;

        if (z >= 0)
            z -= min_treshold;
        else
            z += min_treshold;
    }

    if (isGTreshold(y))
        counter++;
    if (isGTreshold(z))
        counter++;

    return counter;
}

/*
  * Check 22G
  * return FALSE if it's lower than 22G
  * return TRUE if it's equal or higer than 22G
  */
bool Accelerometer::check22G(qreal value)
{
    if (value >= 0) {
        if (value < 22)
            return false;
        else
            return true;
    }
    else {
        if (value > -22)
            return false;
        else
            return true;
    }
}

/*
  * Check min_treshold
  * return FALSE if it's lower than treshold
  * return TRUE if it's equal or higer than treshold
  */
bool Accelerometer::checkMinTreshold(qreal value)
{
    if (value >= 0) {
        if (value < min_treshold)
            return false;
        else
            return true;
    }
    else {
        if (value > -min_treshold)
            return false;
        else
            return true;
    }
}

/*
  * Check if it's G acceleration
  * return TRUE if it's the G acceleration.
  * return FALSE otherwise.
  */
bool Accelerometer::isGTreshold(qreal value)
{
    if (value >= 0) {
        if (value >= MIN_G_TRESHOLD && value <= MAX_G_TRESHOLD)
            return true;
        else
            return false;
    }
    else {
        if (value <= -MIN_G_TRESHOLD && value >= -MAX_G_TRESHOLD)
            return true;
        else
            return false;
    }
}

float Accelerometer::getX()
{
    return accelerometer->reading()->x();
}

float Accelerometer::getY()
{
    return accelerometer->reading()->y();
}

float Accelerometer::getZ()
{
    return accelerometer->reading()->z();
}

void Accelerometer::start()
{
    alarmFlag = 0;
    accelerometer->start();
}

void Accelerometer::stop()
{
    accelerometer->stop();
}

void Accelerometer::setTreshold(int tresholdLevel)
{
    min_treshold = tresholdLevel;
}
