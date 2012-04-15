#include "gps.h"

Gps::Gps(QObject *parent) :
    QObject(parent)
{
    source = QGeoPositionInfoSource::createDefaultSource(this);

    if (source) {
        /* Update position each second. */
        source->setUpdateInterval(1000);

        connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
    }
}

void Gps::positionUpdated(const QGeoPositionInfo &info)
{
    qDebug() << "Position updated:" << info;

    lastLatitude = info.coordinate().latitude();
    lastLongitude = info.coordinate().longitude();
    lastSpeed = info.attribute(QGeoPositionInfo::GroundSpeed);
    emit updated();
}

void Gps::start()
{
    qDebug() << "starting gps";
    source->startUpdates();
}

void Gps::stop()
{
    qDebug() << "stopping gps";
    source->stopUpdates();
}

qreal Gps::getLatitude()
{
    qDebug() << "gps latitude";
    return lastLatitude;
}

qreal Gps::getLongitude()
{
    qDebug() << "gps longitude";
    return lastLongitude;
}

qreal Gps::getSpeed()
{
    qDebug() << "gps speed";

    qreal speed = lastSpeed * 3.6;

    qDebug() << "speed" << speed;

    if (speed < 4)
        return 0;

    return lastSpeed;
}
