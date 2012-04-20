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
    void setEnableContinousRecording(bool enable);
    bool getEnableContinousRecording();
    void setStoreLast(int selectedIndex);
    int getStoreLast();
    QString getStoreLastToText();
    int getStoreLastInMinutes();
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
    void setCurrentVideoFiles(int number);
    int getCurrentVideoFiles();
    void addCurrentVideoFiles(int value);
    void setMaxAllowedSpeed(int speed);
    int getMaxAllowedSpeed();

};

#endif // SETTINGS_H
