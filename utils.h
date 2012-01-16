#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QFile>

class Utils : public QObject {
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);

public slots:
    void deleteVideo(const QString &path);

signals:
    void information(const QString &message);
    void videoDeleted(const QString &path);

};

#endif // UTILS_H
