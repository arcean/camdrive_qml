#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QFile>

class Utils : public QObject {
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);
    Q_INVOKABLE QString replaceIdsInTextMessage(QString message, QString city, QString street, double latitude, double longitude);
    Q_INVOKABLE void deleteVideo(const QString &path);
    Q_INVOKABLE QString convertLatitudeToGui(double latitude);
    Q_INVOKABLE QString convertLongitudeToGui(double longitude);

public slots:

signals:
    void information(const QString &message);
    void videoDeleted(const QString &path);

};

#endif // UTILS_H
