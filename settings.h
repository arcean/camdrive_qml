#ifndef SETTINGS_H
#define SETTINGS_H

#include <QDeclarativeItem>
#include <QSettings>

#define CD_STORE_LAST_0 1
#define CD_STORE_LAST_1 3
#define CD_STORE_LAST_2 5
#define CD_STORE_LAST_3 10
#define CD_STORE_LAST_4 15
#define CD_STORE_LAST_5 30

class Settings : public QDeclarativeItem
{
    Q_OBJECT
public:
    Settings();
    ~Settings();

public slots:
    void setEnableContinousRecording(bool enable);
    bool getEnableContinousRecording();
    void setStoreLast(int selectedIndex);
    int getStoreLast();
    QString getStoreLastToText();
    void setVideoResolution(int resolution);
    int getVideoResolution();
    void setVideoQuality(int quality);
    int getVideoQuality();
    void setEnableAudio(bool enable);
    bool getEnableAudio();
    void setAudioQuality(int quality);
    int getAudioQuality();

};

#endif // SETTINGS_H
