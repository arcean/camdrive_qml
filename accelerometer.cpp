#include "accelerometer.h"
#include <QDebug>

Accelerometer::Accelerometer(QObject *parent) :
    QObject(parent)
{
    accelerometer = new QAccelerometer();
    connect(accelerometer, SIGNAL(readingChanged()), this, SLOT(readingChanged()));
    qDebug() << "!!!!!!!!!!!!!!!!!!!!!!!!!!!!! OK";
    accelerometer->start();
}

void Accelerometer::readingChanged()
{
    qreal acc_x = accelerometer->reading()->x();
    qreal acc_y = accelerometer->reading()->y();
    qreal acc_z = accelerometer->reading()->z();

    qDebug() << "X:" << acc_x << " Y:" << acc_y << " Z:" << acc_z;
}