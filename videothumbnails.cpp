#include <QDir>
#include <QCryptographicHash>
#include "videothumbnails.h"

VideoThumbnails::VideoThumbnails(QObject *parent) :
    QObject(parent)
{
}

bool VideoThumbnails::checkIfExists(const QString &path) {
    if (QFile::exists(path)) {
        return true;
    }
    else {
        return false;
    }
}

QUrl VideoThumbnails::parameterToUri(const QString &param) {
    QString tmp(param);
    if(tmp.startsWith("file://")) return QUrl(tmp);
    if(tmp.startsWith("/")) return QUrl(QString("file://") + tmp);
    return QUrl(QString("file://") + QDir::currentPath() + QDir::separator() + tmp);
}

void VideoThumbnails::addVideoFileToList(const QString &path) {
    /* Check if out thumbnail exists.
     * If exists, return.
    */
    if (checkIfExists(path))
        return;

    QUrl uri = parameterToUri(path);
    uris << uri;
    mimes << "video/mp4";
}

void VideoThumbnails::clearVideoFileList() {
    uris.clear();
    mimes.clear();
}

bool VideoThumbnails::checkIfThumbnailExists(const QString &path, bool remove) {
    QUrl uri = parameterToUri(path);
    QString hash = QCryptographicHash::hash((uri.toString().toLatin1()),QCryptographicHash::Md5).toHex().constData();
    QString file = "/home/user/.thumbnails/video-grid/" + hash + ".jpeg";

    if (QFile::exists(file)) {
        if (remove)
            QFile::remove(file);
        return true;
    }
    else {
        return false;
    }
}

void VideoThumbnails::loadAllVideoFilesToList() {
    QString path = "/home/user/MyDocs/camdrive";
    QDir dir(path);
    QStringList filters; filters << "*.mp4";
    dir.setNameFilters(filters);
    QStringList files = dir.entryList(QDir::Files | QDir::Readable);
    QString filePath;

    uris.clear();
    mimes.clear();

    foreach(QString file, files) {
        filePath = path + "/" + file;
        file = "file://" + filePath;

        if (!checkIfThumbnailExists(filePath, false)) {
            uris << QUrl(file);
            mimes << "video/mp4";
        }
    }
}

void VideoThumbnails::createNewThumbnail() {

    if (uris.isEmpty()) {
        emit finished();
        return;
    }

    Thumbnails::Thumbnailer *thumbler = new Thumbnails::Thumbnailer();

    connect(thumbler, SIGNAL(finished(int)), this, SLOT(completed(int)));

    thumbler->request(uris, mimes, false, QString("video-grid"));
}

void VideoThumbnails::completed(int left) {
    if (left == 0)
        emit finished();
}

