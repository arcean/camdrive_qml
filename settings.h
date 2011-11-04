#ifndef SETTINGS_H
#define SETTINGS_H

#include <QDeclarativeItem>
#include <QSettings>

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

};

#endif // SETTINGS_H
