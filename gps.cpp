#include "gps.h"

Gps::Gps(QObject *parent) :
    QObject(parent)
{
    source = QGeoPositionInfoSource::createDefaultSource(this);
    source->setPreferredPositioningMethods(QGeoPositionInfoSource::SatellitePositioningMethods);

    if (source) {
        /* Update position each second. */
        source->setUpdateInterval(1000);

        connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
    }
}

void Gps::positionUpdated(const QGeoPositionInfo &info)
{
    lastLatitude = info.coordinate().latitude();
    lastLongitude = info.coordinate().longitude();
    lastSpeed = info.attribute(QGeoPositionInfo::GroundSpeed);

    emit updated();
}

void Gps::start()
{
    source->startUpdates();
}

void Gps::stop()
{
    source->stopUpdates();
}

qreal Gps::getLatitude()
{
    return lastLatitude;
}

qreal Gps::getLongitude()
{
    return lastLongitude;
}

qreal Gps::getSpeed()
{
    return lastSpeed;
}
