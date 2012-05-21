#ifndef SETTINGS_H
#define SETTINGS_H

#include <QDeclarativeItem>
#include <QSettings>

#define CD_STORE_LAST_0 3
#define CD_STORE_LAST_1 5
#define CD_STORE_LAST_2 10
#define CD_STORE_LAST_3 20
#define CD_STORE_LAST_4 30

class Settings : public QDeclarativeItem
{
    Q_OBJECT
public:
    Settings();
    ~Settings();

    void setEnableStoringPositionInfo(bool enable);
    bool getEnableStoringPositionInfo();
    void setEnableStoringSpeedInfo(bool enable);
    bool getEnableStoringSpeedInfo();

public slots:
    void setStoreLast(int selectedIndex);
    int getStoreLast();
    void setVideoResolution(int resolution);
    int getVideoResolution();
    void setVideoQuality(int quality);
    int getVideoQuality();
    void setEnableAudio(bool enable);
    bool getEnableAudio();
    void setAudioQuality(int quality);
    int getAudioQuality();    
    void setStoreDataEachXSeconds(int seconds);
    int getStoreDataEachXSeconds();
    void setEnableStoringAccelInfo(bool enable);
    bool getEnableStoringAccelInfo();
    void setMaxVideoFiles(int numberOfFiles);
    int getMaxVideoFiles();
    void setMaxAllowedSpeed(int speed);
    int getMaxAllowedSpeed();
    void setVelocityUnit(bool unit);
    bool getVelocityUnit();
    //! Telephony
    void setEmergencyContactName(const QString &name);
    QString getEmergencyContactName();
    void setEmergencyContactNameEnabled(bool enabled);
    bool getEmergencyContactNameEnabled();
    void setEmergencyContactNumber(const QString &number);
    QString getEmergencyContactNumber();
    void setEmergencyNumber(const QString &number);
    QString getEmergencyNumber();
    void setContactTextMessage(const QString &message);
    QString getContactTextMessage();
    //! Viewfinder settings
    void setShowNightModeButton(bool show);
    bool getShowNightModeButton();
    bool getShowEmergencyButton();
    void setShowEmergencyButton(bool enable);
    //! Accelerometer
    void setAccelerometerTreshold(int tresholdLevel);
    int getAccelerometerTreshold();
    //! Accelerometer - ignore treshold level values
    void incAccelerometerIgnoreLevel();
    void resetAccelerometerIgnoreLevel();
    float getAccelerometerIgnoreLevel();
    //! Record in background
    bool getRecordingInBackground();
    void setRecordingInBackground(bool enable);

};

#endif // SETTINGS_H
