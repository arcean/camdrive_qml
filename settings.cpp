#include "settings.h"
#include <QDebug>

Settings::Settings()
{
}

Settings::~Settings()
{

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
    int value =  settings.value("recording/store_last", 3).toInt();

    return value;
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
    int value =  settings.value("store/numberOfFiles", 0).toInt();

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
    int value =  settings.value("speed/maxAllowed", 130).toInt();

    return value;
}

/*!
 * Set velocity unit.
 */
void Settings::setVelocityUnit(bool unit)
{
    QSettings settings;

    settings.setValue("speed/unit", unit);
}

/*!
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

//! Telephony

/*!
 * Set emergency contact name.
 */
void Settings::setEmergencyContactName(const QString &name)
{
    QSettings settings;

    settings.setValue("contacts/emergencyContact", name);
}

/*!
 * Get emergency contact name
 */
QString Settings::getEmergencyContactName()
{
    QSettings settings;
    QString value =  settings.value("contacts/emergencyContact", "").toString();

    return value;
}

/*!
 * Enable emergency contact name.
 */
void Settings::setEmergencyContactNameEnabled(bool enabled)
{
    QSettings settings;

    settings.setValue("contacts/emergencyContactEnabled", enabled);
}

/*!
 * Check if emergency contact name is enabled.
 */
bool Settings::getEmergencyContactNameEnabled()
{
    QSettings settings;
    bool value =  settings.value("contacts/emergencyContactEnabled", false).toBool();

    return value;
}

/*!
 * Set emergency contact number.
 */
void Settings::setEmergencyContactNumber(const QString &number)
{
    QSettings settings;

    settings.setValue("contacts/emergencyContactNumber", number);
}

/*!
 * Get emergency contact number
 */
QString Settings::getEmergencyContactNumber()
{
    QSettings settings;
    QString value =  settings.value("contacts/emergencyContactNumber", "").toString();

    return value;
}

/*!
 * Set emergency number.
 */
void Settings::setEmergencyNumber(const QString &number)
{
    QSettings settings;

    settings.setValue("contacts/emergencyNumber", number);
}

/*!
 * Get emergency number.
 */
QString Settings::getEmergencyNumber()
{
    QSettings settings;
    QString value =  settings.value("contacts/emergencyNumber", "112").toString();

    return value;
}

/*!
 * Set text message.
 */
void Settings::setContactTextMessage(const QString &message)
{
    QSettings settings;

    settings.setValue("contacts/contactTextMessage", message);
}

/*!
 * Get text message.
 */
QString Settings::getContactTextMessage()
{
    QSettings settings;
    QString value =  settings.value("contacts/contactTextMessage", "Hi! I had a car accident.\n#CITY, #STREET,\nMy coordinates:\n#LATITUDE #LONGITUDE").toString();

    return value;
}

/*!
 * Show camera night mode button on the viewfinder.
 */
void Settings::setShowNightModeButton(bool show)
{
    QSettings settings;

    settings.setValue("viewfinder/nightModeButton", show);
}

/*!
 * Check if we have to show camera night mode button on the viewfinder.
 */
bool Settings::getShowNightModeButton()
{
    QSettings settings;
    bool value =  settings.value("viewfinder/nightModeButton", false).toBool();

    return value;
}

bool Settings::getShowEmergencyButton()
{
    QSettings settings;
    bool value =  settings.value("viewfinder/emergencyButton", false).toBool();

    return value;
}

/*!
 * Always show emergency button on the viewfinder.
 */
void Settings::setShowEmergencyButton(bool enable)
{
    QSettings settings;

    settings.setValue("viewfinder/emergencyButton", enable);
}

/*!
 * Set accelerometer treshold level.
 */
void Settings::setAccelerometerTreshold(int tresholdLevel)
{
    QSettings settings;

    settings.setValue("accelerometer/tresholdLevel", tresholdLevel);
}

/*!
 * Get accelerometer treshold level.
 */
int Settings::getAccelerometerTreshold()
{
    QSettings settings;
    int value =  settings.value("accelerometer/tresholdLevel", 2).toInt();

    return value;
}

/*!
 * Increment accelerometer ignore level.
 */
void Settings::incAccelerometerIgnoreLevel()
{
    QSettings settings;
    float value = getAccelerometerIgnoreLevel();
    if (value < 2)
        value = value + 0.1;

    //qDebug() << "new Ignore Level" << value;

    settings.setValue("accelerometer/ignoreLevel", value);
}

/*!
 * Reset accelerometer ignore level.
 */
void Settings::resetAccelerometerIgnoreLevel()
{
    QSettings settings;

    settings.setValue("accelerometer/ignoreLevel", 0);
}

/*!
 * Get accelerometer ignore level.
 */
float Settings::getAccelerometerIgnoreLevel()
{
    QSettings settings;
    float value =  settings.value("accelerometer/ignoreLevel", 0).toFloat();

    return value;
}

/*!
 * Get recording in background.
 */
bool Settings::getRecordingInBackground()
{
    QSettings settings;
    bool value =  settings.value("recording/inBackground", false).toBool();

    return value;
}

/*!
 * Set recording in background.
 */
void Settings::setRecordingInBackground(bool enable)
{
    QSettings settings;

    settings.setValue("recording/inBackground", enable);
}

/*!
 * Get first run.
 */
bool Settings::isFirstRun()
{
    QSettings settings;
    bool value =  settings.value("other/firstRun", true).toBool();

    return value;
}

/*!
 * Set first run.
 */
void Settings::setFirstRun(bool firstRun)
{
    QSettings settings;

    settings.setValue("other/firstRun", firstRun);
}

/*!
 * Get offline mode.
 */
bool Settings::isOfflineMode()
{
    QSettings settings;
    bool value =  settings.value("other/offlineMode", false).toBool();

    return value;
}

/*!
 * Set offline mode.
 */
void Settings::setOfflineMode(bool offlineMode)
{
    QSettings settings;

    settings.setValue("other/offlineMode", offlineMode);
}
