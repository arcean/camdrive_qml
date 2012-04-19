#ifndef FILE_H
#define FILE_H

#include <QFile>
#include <QString>
#include <QDir>
#include <QDateTime>

#include "settings.h"

#define APP_NAME "camdrive"
#define APP_DIR "/home/user/MyDocs/"

class File
{
public:
    File(const QString &fileName, Settings *settingsObject);
    bool init();
    bool fileReady();
    void changeFile(int partNumber);
    int getActiveFileNumber();
    QString getActiveFile();
    QString getGeneratedFileName();
    bool isFileNameFree(const QString &fileName);
    void deleteTheOldestFiles();

private:
    void createAppCatalog();
    bool checkIfNotExists();
    void removeTempFiles();
    QString generateNewFileName(const QString &baseName);
    QString getTheOldestFileName();

    QString fileName;
    QString generatedFileName;
    int activeFileNumber;
    Settings *settingsObject;
};

#endif // FILE_H
