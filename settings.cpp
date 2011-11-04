#include "settings.h"

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
    int value =  settings.value("recording/store_last", 2).toInt();

    return value;
}

QString Settings::getStoreLastToText()
{
    QSettings settings;
    int value = settings.value("recording/store_last", 2).toInt();
    int valueToText;
    QString text;

    switch (value)
    {
    case 0:
        valueToText = 1;
        break;
    case 1:
        valueToText = 3;
        break;
    case 2:
        valueToText = 5;
        break;
    case 3:
        valueToText = 10;
        break;
    case 4:
        valueToText = 15;
        break;
    case 5:
        valueToText = 30;
        break;
    default:
        valueToText = 5;
        break;
    }

    if(valueToText == 1)
        text = QString::number(valueToText) + " minute";
    else
        text = QString::number(valueToText) + " minutes";

    return text;
}
