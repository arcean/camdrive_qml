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
    lastLatitude = info.coordinate().latitude();
    lastLongitude = info.coordinate().longitude();

    //! Let's set the last speed value.
    if (source->supportedPositioningMethods() == QGeoPositionInfoSource::AllPositioningMethods
            || source->supportedPositioningMethods() == QGeoPositionInfoSource::SatellitePositioningMethods) {
        lastSpeed = info.attribute(QGeoPositionInfo::GroundSpeed);
        qDebug() << "Speed with a gps fix.";
    }
    else {
        lastSpeed = 0;
        qDebug() << "Speed without a gps fix.";
    }

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
