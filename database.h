#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlDatabase>
#include <QDir>

#include "settings.h"

#define MAX_PARTS 6

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = 0);

signals:

public slots:
    bool removeVideo(const QString &videoName);
    void openDatabase();
    void closeDatabase();
    void setSettings(Settings *settings);
    void createTables();
    int countsIds();
    void addNewVideo(const QString &videoName, int numberOfVideoParts, const QString &dateTime);
    void addNewVideoInfo(const QString &videoName, float latitude, float longitude, int speed);
    void createVideoDetailsTable(const QString &videoName);
    float getVideoInfoLatitude(const QString &videoName, int videoId);
    float getVideoInfoLongitude(const QString &videoName, int videoId);
    int getVideoInfoSpeed(const QString &videoName, int videoId);
    int getVideoStoredEach(const QString &videoName);
    bool removeVideoFromMain(const QString &videoName);

private:
    void createAppCatalog();
    void createMainTable();
    int getNumberOfVideoParts(const QString &videoName);

    QSqlDatabase *db;
    Settings *settings;
};

#endif // DATABASE_H
