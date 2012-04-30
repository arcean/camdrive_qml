#ifndef DATABASEHELPER_H
#define DATABASEHELPER_H

#include "database.h"

#include <QObject>

#define APP_NAME "camdrive"
#define APP_DIR "/home/user/MyDocs/"

class DatabaseHelper : public QObject {
    Q_OBJECT

public:
    explicit DatabaseHelper(QObject *parent = 0);

    //! Subtitles
    Q_INVOKABLE void createSubtitles(const QString &videoName, bool velocityUnit);

public slots:
    void setDatabase(Database *db);

    int getVideoStoredEachQML(const QString &videoName);
    int getVideoInfoSpeedQML(const QString &videoName, int videoId);
    int getVideoInfoSpecialCodeQML(const QString &videoName, int videoId);
    float getVideoInfoLatitudeQML(const QString &videoName, int videoId);
    float getVideoInfoLongitudeQML(const QString &videoName, int videoId);
    float getVideoInfoAccelXQML(const QString &videoName, int videoId);
    float getVideoInfoAccelYQML(const QString &videoName, int videoId);
    float getVideoInfoAccelZQML(const QString &videoName, int videoId);

    int getSpecialCodeSumQML(const QString &videoName);

    void removeVideoQML(const QString &videoName);
    void removeVideoFromMainQML(const QString &videoName);
    bool isFileNameFreeQML(const QString &fileName);

signals:
    void subtitlesCreated();

private:
    QString removePrefix(const QString &url);
    QString removePostfix(const QString &videoName);
    QString removePostfixAndMore(const QString &videoName);
    QString removePrefixPath(const QString &videoName);
    //! Subtitles
    QString getNumber00(int value);

    Database *Db;
};

#endif // DATABASEHELPER_H
