#ifndef FILE_H
#define FILE_H

#include <QFile>
#include <QString>
#include <QDir>

#define APP_NAME "camdrive"
#define APP_DIR "/home/user/MyDocs/"

class File
{
public:
    File(const QString &fileName);
    bool init();
    bool fileReady();
    void changeFile(int partNumber);
    int getActiveFileNumber();
    QString getActiveFile();
    QString getGeneratedFileName();
    bool isFileNameFree(const QString &fileName);

private:
    void createAppCatalog();
    bool checkIfNotExists();
    void removeTempFiles();
    QString generateNewFileName(const QString &baseName);

    QString fileName;
    QString generatedFileName;
    int activeFileNumber;
};

#endif // FILE_H
