#include "databasehelper.h"

DatabaseHelper::DatabaseHelper(QObject *parent) :
    QObject(parent) {
}

void DatabaseHelper::setDatabase(Database *db)
{
    this->Db = db;
}

int DatabaseHelper::getVideoStoredEachQML(const QString &videoName)
{
    QString data = removePostfixAndMore(videoName);
    data = removePrefix(data);
    qDebug() << "PRINT: " << data;
    return Db->getVideoStoredEach(data);
}

int DatabaseHelper::getVideoInfoSpeedQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoSpeed(data, videoId);
}

float DatabaseHelper::getVideoInfoLatitudeQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoLatitude(data, videoId);
}

float DatabaseHelper::getVideoInfoLongitudeQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoLongitude(data, videoId);
}

QString DatabaseHelper::removePostfix(const QString &videoName)
{
    QString data = videoName;
    if(data.endsWith(".mp4", Qt::CaseInsensitive)) {
        data.chop(4);
        return data;
    }

    return videoName;
}

QString DatabaseHelper::removePostfixAndMore(const QString &videoName)
{
    QString data = videoName;
    if(data.endsWith(".mp4", Qt::CaseInsensitive)) {
        data.chop(11);
        return data;
    }

    return videoName;
}

QString DatabaseHelper::removePrefix(const QString &url)
{
    QString data = url;

    if(data.contains("file:///home/user/MyDocs/camdrive/", Qt::CaseInsensitive))
        data = data.split("file:///home/user/MyDocs/camdrive/").at(1);

    return data;
}

