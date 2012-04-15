#ifndef GPS_H
#define GPS_H

#include <QObject>
#include <QGeoPositionInfoSource>
#include <QDebug>

QTM_USE_NAMESPACE

class Gps : public QObject
{
    Q_OBJECT
public:
    explicit Gps(QObject *parent = 0);
    
signals:
    void updated();
    
public slots:
    void start();
    void stop();

    qreal getLatitude();
    qreal getLongitude();
    qreal getSpeed();

private slots:
    void positionUpdated(const QGeoPositionInfo &info);

private:
    QGeoPositionInfoSource *source;
    qreal lastLatitude;
    qreal lastLongitude;
    qreal lastSpeed;
};

#endif // GPS_H
