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

void DatabaseHelper::removeVideoQML(const QString &videoName)
{
    QString data = removePostfix(videoName);
    data = removePrefixPath(data);
    qDebug() << "PRINT rm VIDEO: " << data << "videoName" << videoName;
    Db->removeVideo(data);
}

void DatabaseHelper::removeVideoFromMainQML(const QString &videoName)
{
    QString data = removePostfixAndMore(videoName);
    data = removePrefixPath(data);
    qDebug() << "PRINT rm MAIN: " << data << "videoName" << videoName;
    Db->removeVideoFromMain(data);
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

QString DatabaseHelper::removePrefixPath(const QString &videoName)
{
    QString data = videoName;

    if(data.contains("/home/user/MyDocs/camdrive/", Qt::CaseInsensitive))
        data = data.split("/home/user/MyDocs/camdrive/").at(1);

    return data;
}

/*
 * Checki if basename fileName is free for all parts.
 */
bool DatabaseHelper::isFileNameFreeQML(const QString &fileName)
{
    QString data = fileName;
    QFile file1;
    QFile file2;
    QFile file3;
    QFile file4;
    QFile file5;
    QFile file6;

    data = removePostfixAndMore(data);

    qDebug() << "DATA isFileNameFree" << data << "FN:" << fileName;

    file1.setFileName(data + "_part_1.mp4");
    file2.setFileName(data + "_part_2.mp4");
    file3.setFileName(data + "_part_3.mp4");
    file4.setFileName(data + "_part_4.mp4");
    file5.setFileName(data + "_part_5.mp4");
    file6.setFileName(data + "_part_6.mp4");

    if(!file1.exists() && !file2.exists() && !file3.exists()
             && !file4.exists() && !file5.exists() && !file6.exists()) {
        return true;
    }

    return false;
}
