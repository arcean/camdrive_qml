#include "database.h"

Database::Database(QObject *parent) :
    QObject(parent)
{

}

void Database::setSettings(Settings *settings)
{
    this->settings = settings;
}

void Database::createAppCatalog()
{
    QString path(QDir::home().path());
    path.append(QDir::separator()).append(".camdrive");
    QDir dir(path);

    if(!dir.exists()) {
        dir.mkdir(path);
    }
}

void Database::openDatabase()
{
    createAppCatalog();
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
               "videoName VARCHAR(80), videoStoredEach INT, numberOfVideoParts INT, dateTime VARCHAR(80))");
}

void Database::createVideoDetailsTable(const QString &videoName)
{
    QSqlQuery query;
    query.exec(QString("CREATE TABLE IF NOT EXISTS '%1' (videoId INTEGER PRIMARY KEY, "
                    "latitude FLOAT, longitude FLOAT, speed INT, accelX FLOAT, accelY FLOAT, accelZ FLOAT, specialCode INT)")
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

int Database::countsVideoIds(const QString &videoName)
{
    QSqlQuery query;

    query.exec(QString("SELECT COUNT(videoId) FROM '%1'").arg(videoName));
    query.next();
    int result = query.value(0).toInt();

    return result;
}

int Database::getNumberOfVideoParts(const QString &videoName)
{
    QSqlQuery query;

    query.exec(QString("SELECT numberOfVideoParts FROM main WHERE videoName='%1").arg(videoName));
    query.next();
    int result = query.value(0).toInt();

    return result;
}

void Database::addNewVideo(const QString &videoName, int numberOfVideoParts, const QString &dateTime)
{
    QSqlQuery query;

   // if(settings->getEnableStoringPositionInfo() || settings->getEnableStoringSpeedInfo()) {
   //     createVideoDetailsTable(videoName);
   // }

    query.exec(QString("INSERT INTO main VALUES(NULL,'%1','%2', '%3', '%4')")
                .arg(videoName).arg(settings->getStoreDataEachXSeconds()).arg(numberOfVideoParts).arg(dateTime));
}

void Database::addNewVideoInfo(const QString &videoName, float latitude, float longitude, int speed, float accelX, float accelY, float accelZ, int specialCode)
{
    QSqlQuery query;
    QString accelx;
    QString accely;
    QString accelz;

    if (!settings->getEnableStoringAccelInfo()) {
        accelx = "NULL";
        accely = "NULL";
        accelz = "NULL";
    }
    else {
        accelx = QString::number(accelX);
        accely = QString::number(accelY);
        accelz = QString::number(accelZ);
    }

    if(settings->getEnableStoringPositionInfo() && settings->getEnableStoringSpeedInfo())
        query.exec(QString("INSERT INTO '%1' VALUES(NULL,'%2','%3','%4','%5','%6','%7', '%8')")
                    .arg(videoName).arg(latitude).arg(longitude).arg(speed).arg(accelx).arg(accely).arg(accelz).arg(specialCode));
    else if (!settings->getEnableStoringPositionInfo() && settings->getEnableStoringSpeedInfo())
        query.exec(QString("INSERT INTO '%1' VALUES(NULL,NULL,NULL,'%2','%3','%4','%5','%6')")
                    .arg(videoName).arg(speed).arg(accelx).arg(accely).arg(accelz).arg(specialCode));
    else if (settings->getEnableStoringPositionInfo() && !settings->getEnableStoringSpeedInfo())
        query.exec(QString("INSERT INTO '%1' VALUES(NULL,'%2','%3',NULL,'%4','%5','%6','%7')")
                    .arg(videoName).arg(latitude).arg(longitude).arg(accelx).arg(accely).arg(accelz).arg(specialCode));
    /* Else -> do nothing */
}

bool Database::removeVideo(const QString &videoName)
{
    QSqlQuery query;
    bool result;

    result = query.exec(QString("DROP TABLE IF EXISTS '%1'")
                        .arg(videoName));

    qDebug() << "DROPPING TABLE:" << videoName;

    return result;
}

bool Database::removeVideoFromMain(const QString &videoName)
{
    QSqlQuery query;
    bool result;

    result = query.exec(QString("DELETE FROM main WHERE videoName = '%1'")
                .arg(videoName));

    return result;
}

float Database::getVideoInfoLatitude(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT latitude FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    float result = query.value(0).toFloat();

    return result;
}

float Database::getVideoInfoLongitude(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT longitude FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    float result = query.value(0).toFloat();

    return result;
}

float Database::getVideoInfoAccelX(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT accelX FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    float result = query.value(0).toFloat();

    return result;
}

float Database::getVideoInfoAccelY(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT accelY FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    float result = query.value(0).toFloat();

    return result;
}

float Database::getVideoInfoAccelZ(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT accelZ FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    float result = query.value(0).toFloat();

    return result;
}

int Database::getVideoInfoSpecialCode(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT specialCode FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    int result = query.value(0).toInt();

    return result;
}

int Database::getVideoInfoSpeed(const QString &videoName, int videoId)
{
    QSqlQuery query;

    query.exec(QString("SELECT speed FROM '%1' WHERE videoId=%2").arg(videoName).arg(videoId));
    query.next();
    int result = query.value(0).toInt();

    return result;
}

int Database::getVideoStoredEach(const QString &videoName)
{
    QSqlQuery query;

    query.exec(QString("SELECT videoStoredEach FROM main WHERE videoName='%1'").arg(videoName));
    query.next();
    int result = query.value(0).toInt();

    return result;
}

/*!
 * Get the sum of the special code values.
 * If it's larger than 10, then it's a 'collision' video.select sum(specialCode) from camdrive_file_part_1
 */
int Database::getSpecialCodeSum(const QString &videoName)
{
    QSqlQuery query;

    query.exec(QString("SELECT sum(specialCode) FROM '%1'").arg(videoName));
    query.next();
    int result = query.value(0).toInt();

    return result;
}
