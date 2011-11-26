#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlDatabase>
#include <QDir>

#include "settings.h"

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = 0);
    void openDatabase();
    void closeDatabase();
    void setSettings(Settings *settings);
    void createTables();
    int countsIds();
    void addNewVideo(QString videoName);
    void addNewVideoInfo(QString videoName, float latitude, float longitude, int speed);

signals:

public slots:
    bool removeVideo(QString videoName);

private:
    void createMainTable();
    void createVideoDetailsTable(QString videoName);

    QSqlDatabase *db;
    Settings *settings;

};

#endif // DATABASE_H
