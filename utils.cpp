#include "utils.h"

Utils::Utils(QObject *parent) :
    QObject(parent) {
}

void Utils::deleteVideo(const QString &path)
{
    QString message;
    QString textFile = path;

    textFile.chop(4);
    textFile.append(".srt");

    if (QFile::remove(path)) {
        //! Remove subtitles
        QFile::remove(textFile);

        message = tr("Video deleted successfully");
        emit videoDeleted(path);
    }
    else {
        message = tr("Video could not be deleted");
    }
    emit information(message);
}

QString Utils::convertLatitudeToGui(double latitude)
{
    QString latitudeStr;

    if (latitude >= 0) {
        latitudeStr = QString::number(latitude);
        latitudeStr.append(" N");
    }
    else {
        latitudeStr = QString::number(latitude * -1);
        latitudeStr.append(" S");
    }

    return latitudeStr;
}

QString Utils::convertLongitudeToGui(double longitude)
{
    QString longitudeStr;

    if (longitude >= 0) {
        longitudeStr = QString::number(longitude);
        longitudeStr.append(" E");
    }
    else {
        longitudeStr = QString::number(longitude * -1);
        longitudeStr.append(" W");
    }

    return longitudeStr;
}

QString Utils::replaceIdsInTextMessage(QString message, QString city, QString street, double latitude, double longitude)
{
    QString finalMessage = message;

    if (city.compare("") == 0)
        city = "unknown city";
    if (street.compare("") == 0)
        street = "unknown street";

    QString latitudeStr = convertLatitudeToGui(latitude);
    QString longitudeStr = convertLongitudeToGui(longitude);

    finalMessage.replace("#city", city, Qt::CaseInsensitive);
    finalMessage.replace("#street", street, Qt::CaseInsensitive);
    finalMessage.replace("#latitude", latitudeStr, Qt::CaseInsensitive);
    finalMessage.replace("#longitude", longitudeStr, Qt::CaseInsensitive);

    return finalMessage;
}
