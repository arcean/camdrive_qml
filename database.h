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
    void addNewVideo(const QString &videoName, int numberOfVideoParts);
    void addNewVideoInfo(const QString &videoName, float latitude, float longitude, int speed);
    void createVideoDetailsTable(const QString &videoName);

signals:

public slots:
    bool removeVideo(const QString &videoName);

private:
    void createAppCatalog();
    void createMainTable();
    int getNumberOfVideoParts(const QString &videoName);

    QSqlDatabase *db;
    Settings *settings;

};

#endif // DATABASE_H
