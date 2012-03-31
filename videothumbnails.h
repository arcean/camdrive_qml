#ifndef THUMBNAILS_H
#define THUMBNAILS_H

#include <QObject>
#include <QFile>
#include <QUrl>
#include <thumbnailer/Thumbnailer>

class VideoThumbnails : public QObject
{
    Q_OBJECT
public:
    explicit VideoThumbnails(QObject *parent = 0);
    
signals:
    void finished();

public slots:
    void createNewThumbnail();
    void addVideoFileToList(const QString &path);
    void clearVideoFileList();
    void loadAllVideoFilesToList();

private slots:
    void completed(int left);

private:
    QUrl parameterToUri(const QString &param);
    bool checkIfExists(const QString &path);
    bool checkIfThumbnailExists(const QString &path);

    QList<QUrl> uris;
    QStringList mimes;
};

#endif // THUMBNAILS_H
