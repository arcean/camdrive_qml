#include "utils.h"

Utils::Utils(QObject *parent) :
    QObject(parent) {
}

void Utils::deleteVideo(const QString &path) {
    QString message;
    if (QFile::remove(path)) {
        message = tr("Video deleted successfully");
        emit videoDeleted();
    }
    else {
        message = tr("Video could not be deleted");
    }
    emit information(message);
}
