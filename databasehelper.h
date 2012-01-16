#ifndef DATABASEHELPER_H
#define DATABASEHELPER_H

#include "database.h"

#include <QObject>

class DatabaseHelper : public QObject {
    Q_OBJECT

public:
    explicit DatabaseHelper(QObject *parent = 0);

public slots:
    void setDatabase(Database *db);
    int getVideoStoredEachQML(const QString &videoName);
    int getVideoInfoSpeedQML(const QString &videoName, int videoId);
    float getVideoInfoLatitudeQML(const QString &videoName, int videoId);
    float getVideoInfoLongitudeQML(const QString &videoName, int videoId);

private:
    QString removePrefix(const QString &url);
    QString removePostfix(const QString &videoName);
    QString removePostfixAndMore(const QString &videoName);

    Database *Db;
};

#endif // DATABASEHELPER_H
