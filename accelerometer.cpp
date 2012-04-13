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
    qreal acc_x = accelerometer->reading()->x();
    qreal acc_y = accelerometer->reading()->y();
    qreal acc_z = accelerometer->reading()->z();

    qDebug() << "X:" << acc_x << " Y:" << acc_y << " Z:" << acc_z;

    parseReading();

    emit newReading();
}

void Accelerometer::parseReading()
{
    /*qreal x = accelerometer->reading()->x();
    qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();*/

    // Check, if there's one value > G + min_treshold -> ALARM
    int result_phase1G = phase1_checkG(true);
    int result_phase2G = phase1_checkG(false);
    int result_phase2MinTreshold = phase1_checkMinTreshold();
    int result_phase22G = phase1_check22G();

    if (result_phase1G > 0) {
        //TODO: Alarm
        qDebug() << "result_phase1G triggered:" << "ALARM";
    }
    // Check if there's one G, and the other > min_treshold -> ALARM
    else if (result_phase2G > 0 && result_phase2MinTreshold > 1 && result_phase22G == 0) {
        //TODO: Alarm
        qDebug() << "result_phase2G and result_phase2MinTreshold triggered:" << "ALARM";
    }
    // If there's one > 22G (max hw value) -> EMERGENCY_ALARM
    else if (result_phase22G > 0){
        //TODO: Alarm, Emergency alarm
        qDebug() << "Emergency 22G ALARM";
    }
    else {
        //Do nothing
        qDebug() << "nothing";
    }

}

int Accelerometer::phase1_check22G()
{
    qreal x = accelerometer->reading()->x();
    //qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();

    int counter = 0;

    if (check22G(x))
        counter++;
    //if (check22G(y))
    //    counter++;
    if (check22G(z))
        counter++;

    return counter;
}

int Accelerometer::phase1_checkMinTreshold()
{
    qreal x = accelerometer->reading()->x();
    //qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();

    int counter = 0;

    if (checkMinTreshold(x))
        counter++;
  //  if (checkMinTreshold(y))
   //     counter++;
    if (checkMinTreshold(z))
        counter++;

    return counter;
}

int Accelerometer::phase1_checkG(bool checkMinTreshold)
{
    qreal x = accelerometer->reading()->x();
    qreal y = accelerometer->reading()->y();
    qreal z = accelerometer->reading()->z();
    int counter = 0;

    if (checkMinTreshold) {
        if (x >= 0)
            x -= min_treshold;
        else
            x += min_treshold;

        if (y >= 0)
            y -= min_treshold;
        else
            y += min_treshold;

        if (z >= 0)
            z -= min_treshold;
        else
            z += min_treshold;
    }

    if (isGTreshold(x))
        counter++;
  //  if (isGTreshold(y))
  //      counter++;
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
    accelerometer->start();
}

void Accelerometer::stop()
{
    accelerometer->stop();
}
