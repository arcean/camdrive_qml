#include "settings.h"
#include <QDebug>

Settings::Settings()
{
}

Settings::~Settings()
{

}

void Settings::setEnableContinousRecording(bool enable)
{
    QSettings settings;

    settings.setValue("recording/continous", enable);
}

bool Settings::getEnableContinousRecording()
{
    QSettings settings;
    bool value =  settings.value("recording/continous", false).toBool();

    return value;
}

void Settings::setStoreLast(int selectedIndex)
{
    // Let's ignore -1 index
    if(selectedIndex < 0)
        return;

    QSettings settings;

    settings.setValue("recording/store_last", selectedIndex);
}

int Settings::getStoreLast()
{
    QSettings settings;
    int value =  settings.value("recording/store_last", 1).toInt();

    return value;
}

QString Settings::getStoreLastToText()
{
    QSettings settings;
    int value = settings.value("recording/store_last", 1).toInt();
    int valueToText;
    QString text;

    switch (value)
    {
    case 0:
        valueToText = CD_STORE_LAST_0;
        break;
    case 1:
        valueToText = CD_STORE_LAST_1;
        break;
    case 2:
        valueToText = CD_STORE_LAST_2;
        break;
    case 3:
        valueToText = CD_STORE_LAST_3;
        break;
    case 4:
        valueToText = CD_STORE_LAST_4;
        break;
    default:
        valueToText = CD_STORE_LAST_2;
        break;
    }

    /* Since 0.0.2 it's abandoned. */
    //if(valueToText == 1)
    //    text = QString::number(valueToText) + " minute";
    // else
    text = QString::number(valueToText) + " minutes";

    return text;
}

int Settings::getStoreLastInMinutes()
{
    QSettings settings;
    int value = settings.value("recording/store_last", 1).toInt();
    int valueToPass;

    switch (value)
    {
    case 0:
        valueToPass = CD_STORE_LAST_0;
        break;
    case 1:
        valueToPass = CD_STORE_LAST_1;
        break;
    case 2:
        valueToPass = CD_STORE_LAST_2;
        break;
    case 3:
        valueToPass = CD_STORE_LAST_3;
        break;
    case 4:
        valueToPass = CD_STORE_LAST_4;
        break;
    default:
        valueToPass = CD_STORE_LAST_2;
        break;
    }

    return valueToPass;
}

void Settings::setVideoResolution(int resolution)
{
    if(resolution > 2 || resolution < 0)
        resolution = 1;

    QSettings settings;
    settings.setValue("video/resolution", resolution);
}

int Settings::getVideoResolution()
{
    QSettings settings;
    int value =  settings.value("video/resolution", 1).toInt();

    return value;
}

void Settings::setVideoQuality(int quality)
{
    if(quality > 2 || quality < 0)
        quality = 1;

    QSettings settings;
    settings.setValue("video/quality", quality);
}

int Settings::getVideoQuality()
{
    QSettings settings;
    int value =  settings.value("video/quality", 1).toInt();

    return value;
}

void Settings::setEnableAudio(bool enable)
{
    QSettings settings;

    settings.setValue("audio/enabled", enable);
}

bool Settings::getEnableAudio()
{
    QSettings settings;
    bool value =  settings.value("audio/enabled", false).toBool();

    return value;
}

void Settings::setAudioQuality(int quality)
{
    if(quality < 0 || quality > 2)
        quality = 1;

    QSettings settings;
    settings.setValue("audio/quality", quality);
}

int Settings::getAudioQuality()
{
    QSettings settings;
    int value =  settings.value("audio/quality", 1).toInt();

    return value;
}

void Settings::setEnableStoringPositionInfo(bool enable)
{
    QSettings settings;

    settings.setValue("store/position", enable);
}

bool Settings::getEnableStoringPositionInfo()
{
    QSettings settings;
    bool value =  settings.value("store/position", true).toBool();

    return value;
}

void Settings::setEnableStoringSpeedInfo(bool enable)
{
    QSettings settings;

    settings.setValue("store/position", enable);
}

bool Settings::getEnableStoringSpeedInfo()
{
    QSettings settings;
    bool value =  settings.value("store/speed", true).toBool();

    return value;
}

void Settings::setEnableStoringAccelInfo(bool enable)
{
    QSettings settings;

    settings.setValue("store/accel", enable);
}

bool Settings::getEnableStoringAccelInfo()
{
    QSettings settings;
    bool value =  settings.value("store/accel", true).toBool();

    return value;
}

void Settings::setStoreDataEachXSeconds(int seconds)
{
    QSettings settings;

    settings.setValue("store/eachXSeconds", seconds);
}

int Settings::getStoreDataEachXSeconds()
{
    QSettings settings;
    int value =  settings.value("store/eachXSeconds", 1).toInt();

    return value;
}

void Settings::setMaxVideoFiles(int numberOfFiles)
{
    QSettings settings;

    settings.setValue("store/numberOfFiles", numberOfFiles);
}

int Settings::getMaxVideoFiles()
{
    QSettings settings;
    int value =  settings.value("store/numberOfFiles", -1).toInt();

    return value;
}

void Settings::addCurrentVideoFiles(int value)
{
    int currentNumber = getCurrentVideoFiles();
    int max = getMaxVideoFiles();

    if (max == -1)
        max = 100;

    if (currentNumber < max && value > 0)
        setCurrentVideoFiles(getCurrentVideoFiles() + value);
    else if (currentNumber > 0 && value <= 0)
        setCurrentVideoFiles(getCurrentVideoFiles() + value);

    qDebug() << "Actual current video:" << getCurrentVideoFiles();
    qDebug() << "Actual MAX video:" << getMaxVideoFiles();
}

void Settings::setCurrentVideoFiles(int number)
{
    QSettings settings;

    settings.setValue("store/currentNumber", number);
}

int Settings::getCurrentVideoFiles()
{
    QSettings settings;
    int value =  settings.value("store/currentNumber", 0).toInt();

    return value;
}

void Settings::setMaxAllowedSpeed(int speed)
{
    QSettings settings;

    settings.setValue("speed/maxAllowed", speed);
}

int Settings::getMaxAllowedSpeed()
{
    QSettings settings;
    int value =  settings.value("speed/maxAllowed", 999).toInt();

    return value;
}

/*
 * Set velocity unit.
 */
void Settings::setVelocityUnit(bool unit)
{
    QSettings settings;

    settings.setValue("speed/unit", unit);
}

/*
 * Get velocity unit.
 * return TRUE, if km/h
 * return FALSE, if mph
 */
bool Settings::getVelocityUnit()
{
    QSettings settings;
    bool value =  settings.value("speed/unit", true).toBool();

    return value;
}
