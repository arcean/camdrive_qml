#include <QFile>
#include "databasehelper.h"
#include "file.h"

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
    //qDebug() << "PRINT: " << data;
    return Db->getVideoStoredEach(data);
}

int DatabaseHelper::getVideoInfoSpeedQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoSpeed(data, videoId);
}

int DatabaseHelper::getVideoInfoSpecialCodeQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoSpecialCode(data, videoId);
}

float DatabaseHelper::getVideoInfoLatitudeQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoLatitude(data, videoId);
}

float DatabaseHelper::getVideoInfoLongitudeQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoLongitude(data, videoId);
}

float DatabaseHelper::getVideoInfoAccelXQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoAccelX(data, videoId);
}

float DatabaseHelper::getVideoInfoAccelYQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoAccelY(data, videoId);
}

float DatabaseHelper::getVideoInfoAccelZQML(const QString &videoName, int videoId)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "videoID" << videoId;
    return Db->getVideoInfoAccelZ(data, videoId);
}

int DatabaseHelper::getSpecialCodeSumQML(const QString &videoName)
{
    QString data = removePostfix(videoName);
    data = removePrefixPath(data);
    //qDebug() << "PRINT: " << data;
    return Db->getSpecialCodeSum(data);
}

int DatabaseHelper::countVideoInfo(const QString &videoName)
{
    QString data = removePostfix(videoName);
    data = removePrefix(data);
    //qDebug() << "PRINT: " << data << "countVideoInfo";
    return Db->countsVideoIds(data);
}

void DatabaseHelper::removeVideoQML(const QString &videoName)
{
    QString data = removePostfix(videoName);
    data = removePrefixPath(data);
    //qDebug() << "PRINT rm VIDEO: " << data << "videoName" << videoName;
    Db->removeVideo(data);
}

void DatabaseHelper::removeVideoFromMainQML(const QString &videoName)
{
    QString data = removePostfixAndMore(videoName);
    data = removePrefixPath(data);
    //qDebug() << "PRINT rm MAIN: " << data << "videoName" << videoName;
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
 * Check if basename fileName is free for all parts.
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

    //qDebug() << "DATA isFileNameFree" << data << "FN:" << fileName;

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

/*!
 * Convert x to 0x, where x >= 0 and x < 10.
 */
QString DatabaseHelper::getNumber00(int value)
{
    QString result = QString::number(value);

    if (value >= 0 && value < 10)
        result = "0" + result;

    return result;
}

/*!
 * Create subtitles for selected video.
 * (SRT format).
 */
void DatabaseHelper::createSubtitles(const QString &videoName, bool velocityUnit)
{
    QString pass = removePrefixPath(videoName);
    QString data = removePostfix(videoName);
    data = removePrefixPath(data);

    //! Number of subtitles to be created
    int numOfSub = Db->countsVideoIds(data);
    int storeVideoEach = getVideoStoredEachQML(pass);
    QFile file(QString(APP_DIR APP_NAME "/") + data + ".srt");
    int sec, min, hour;
    int speed, alarmFlag;
    float latitude, longitude;
    QString latitudeStr, longitudeStr;
    QString unit, flagText, alarmFlagtext;

    sec = min = hour = 0;

    if (velocityUnit)
        unit = "km/h";
    else
        unit = "mph";

    //qDebug() << "Number of subtitles to be created" << numOfSub;
    //qDebug() << "srt filename:" << APP_DIR APP_NAME + data + ".srt";
    //qDebug() << "videoo stored each" << storeVideoEach << "second(s)";

    if (numOfSub < 1)
        return;

    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);

    for (int i = 1; i <= numOfSub; i++) {
        //! Subtitle number
        out << QString::number(i) + "\n";

        //! Start time and end time
        out << getNumber00(hour) << ":" << getNumber00(min) << ":" << getNumber00(sec) << ",000 --> ";
        sec += storeVideoEach;
        if ((sec % 60 > 0) && (sec / 60 > 0)) {
            min++;
            sec = sec % 60;
        }
        if ((min % 60 > 0) && (min / 60 > 0)) {
            hour++;
            min = min % 60;
        }

        out << getNumber00(hour) << ":" << getNumber00(min) << ":" << getNumber00(sec) << ",000" << "\n";

        //! Speed
        speed = getVideoInfoSpeedQML(pass, i);
        if (velocityUnit) {
            speed = speed * 3.6;
        }
        else {
            speed = speed * 2.2369;
        }

        if (speed < 4)
            speed = 0;

        //! Collision
        alarmFlag = getVideoInfoSpecialCodeQML(pass, i);
        if (alarmFlag > 0 && alarmFlag < 10)
            alarmFlagtext = "Collision side: ";
        else if (alarmFlag > 10)
            alarmFlagtext = "Probable collision side: ";

        if (alarmFlag > 9)
            alarmFlag -= 10;

        if (alarmFlag == 1)
            flagText = "front";
        else if (alarmFlag == 2)
            flagText = "left";
        else if (alarmFlag == 3)
            flagText = "right";
        else if (alarmFlag == 4)
            flagText = "rear";
        else {
            flagText = "";
        }

        if (flagText.length() > 0) {
            alarmFlagtext = alarmFlagtext + flagText;
        }
        else
            alarmFlagtext = "";

        out << "Speed: " << speed << " " << unit << "  " << alarmFlagtext << "\n";

        latitude = getVideoInfoLatitudeQML(pass, i);
        longitude = getVideoInfoLongitudeQML(pass, i);

        if (latitude >= 0)
            latitudeStr = "N";
        else
            latitudeStr = "S";

        if (longitude >= 0)
            longitudeStr = "E";
        else
            longitudeStr = "W";

        out << latitude << " " << latitudeStr << "," << longitude << " " << longitudeStr << "\n";
        out << "\n";
    }
    file.close();
    emit subtitlesCreated();
}
