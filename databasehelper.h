#ifndef DATABASEHELPER_H
#define DATABASEHELPER_H

#include "database.h"

#include <QObject>

class DatabaseHelper : public QObject {
    Q_OBJECT

public:
    explicit DatabaseHelper(QObject *parent = 0);
    void setDatabase(Database *db);

public slots:
    int getVideoStoredEachQML(const QString &videoName);

private:
    QString removePrefix(const QString &url);
    QString removePostfix(const QString &videoName);
    QString removePostfixAndMore(const QString &videoName);


    Database *Db;
};

#endif // DATABASEHELPER_H
