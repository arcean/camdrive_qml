#include "database.h"

Database::Database(QObject *parent) :
    QObject(parent)
{
}

void Database::setSettings(Settings *settings)
{
    this->settings = settings;
}

void Database::openDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    QString path(QDir::home().path());
    path.append(QDir::separator()).append(".camdrive");
    path.append(QDir::separator()).append("videos.db.sqlite");
    path = QDir::toNativeSeparators(path);
    db.setDatabaseName(path);
    db.open();
}

void Database::closeDatabase()
{
    if(db->isOpen())
        db->close();
}

void Database::createTables()
{
    createMainTable();
}

void Database::createMainTable()
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS main (id INTEGER PRIMARY KEY, "
                    "videoName VARCHAR(80), videoStoredEach INT)");
}

void Database::createVideoDetailsTable(QString videoName)
{
    QSqlQuery query;
    query.exec(QString("CREATE TABLE IF NOT EXISTS '%1' (videoId INTEGER PRIMARY KEY, "
                    "latitude FLOAT, longitude FLOAT, speed INT)")
                    .arg(videoName));
}

int Database::countsIds()
{
    QSqlQuery query;

    query.exec(QString("SELECT COUNT(id) FROM main"));
    query.next();
    int result = query.value(0).toInt();

    return result;
}

void Database::addNewVideo(QString videoName)
{
    QSqlQuery query;

    if(settings->getEnableStoringPositionInfo() || settings->getEnableStoringSpeedInfo()) {
        createVideoDetailsTable(videoName);
    }

    query.exec(QString("INSERT INTO main VALUES(NULL,'%1','%2')")
                .arg(videoName).arg(settings->getStoreDataEachXSeconds()));
}

void Database::addNewVideoInfo(QString videoName, float latitude, float longitude, int speed)
{
    QSqlQuery query;

    if(settings->getEnableStoringPositionInfo() && settings->getEnableStoringSpeedInfo())
        query.exec(QString("INSERT INTO '%1' VALUES(NULL,'%2','%3','%4')")
                    .arg(videoName).arg(latitude).arg(longitude).arg(speed));
    else if (!settings->getEnableStoringPositionInfo() && settings->getEnableStoringSpeedInfo())
        query.exec(QString("INSERT INTO '%1' VALUES(NULL,NULL,NULL,'%2')")
                    .arg(videoName).arg(speed));
    /* Else -> do nothing */
}

bool Database::removeVideo(QString videoName)
{
    QSqlQuery query;
    bool result;

    result = query.exec(QString("DROP TABLE IF EXISTS '%1'")
                         .arg(videoName));

    if(result)
        query.exec(QString("DELETE FROM main WHERE videoName = '%1'")
                    .arg(videoName));

    return result;
}
