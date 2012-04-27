#include "file.h"
#include <QDebug>

File::File(const QString &fileName, Settings *settingsObject, Database *Db)
{
    this->settingsObject = settingsObject;
    this->Db = Db;
    this->DbH = new DatabaseHelper();

    DbH->setDatabase(Db);

    int currentNumVideo = Db->countsIds();
    int maxVideo = settingsObject->getMaxVideoFiles();

    qDebug() << "max" << maxVideo;
    qDebug() << "curr" << currentNumVideo;

    init();

    if (currentNumVideo >= maxVideo && maxVideo != -1) {
        qDebug() << "currentNumVideo >= maxVideo";
        generatedFileName = getTheOldestFileName();
        qDebug() << "generatedFileName: " << generatedFileName;
    }
    else {
        qDebug() << "everything's ok";
        generatedFileName = generateNewFileName(fileName);
    }

    this->fileName = generatedFileName + "_part_" + QString::number(activeFileNumber) + ".mp4";
    qDebug() << "FNAME:" << this->fileName;
}

void File::deleteTheOldestFiles()
{
    QDir files(QString(APP_DIR APP_NAME "/"));
    int index;
    int currentNumVideo = Db->countsIds();
    int maxVideo = settingsObject->getMaxVideoFiles();

    if (!(currentNumVideo >= maxVideo && maxVideo != -1)) {
        return;
    }

    QFileInfoList fileList = files.entryInfoList(QDir::Files, QDir::Time);
    for (int i = 0; i < fileList.length(); i++) {
        qDebug() << "A1:" << fileList.at(i).absoluteFilePath() << fileList.at(i).lastModified().toString();
    }

    if (fileList.length() < 1)
        return;

    qDebug() << "The oldest file: " << fileList.at(fileList.length()-1).absoluteFilePath() << fileList.at(fileList.length()-1).lastModified().toString();

    /* Remove the oldest video files. */
    index = fileList.length() - 1;
    if (index > 0) {
        QFile::remove(fileList.at(fileList.length()-1).absoluteFilePath());
        QString textFile = fileList.at(fileList.length()-1).absoluteFilePath();
        textFile.chop(4);
        textFile.append(".srt");
        QFile::remove(textFile);
        DbH->removeVideoQML(fileList.at(fileList.length()-1).absoluteFilePath());
        if (DbH->isFileNameFreeQML(fileList.at(fileList.length()-1).absoluteFilePath())) {
            DbH->removeVideoFromMainQML(fileList.at(fileList.length()-1).absoluteFilePath());
        }
        //settingsObject->addCurrentVideoFiles(-1);
    }
    qDebug() << " RM OK2";
    index = fileList.length() - 2;
    if (index > 0) {
        if (fileList.at(fileList.length()-2).absoluteFilePath().contains("part_2.mp4")) {
            QFile::remove(fileList.at(fileList.length()-2).absoluteFilePath());
            QString textFile = fileList.at(fileList.length()-2).absoluteFilePath();
            textFile.chop(4);
            textFile.append(".srt");
            QFile::remove(textFile);
            DbH->removeVideoQML(fileList.at(fileList.length()-2).absoluteFilePath());
            if (DbH->isFileNameFreeQML(fileList.at(fileList.length()-2).absoluteFilePath())) {
                DbH->removeVideoFromMainQML(fileList.at(fileList.length()-2).absoluteFilePath());
            }
        }
        qDebug() << "RM OK3";
    }
}

QString File::getTheOldestFileName()
{
    QDir files(QString(APP_DIR APP_NAME "/"));
    QString fileName;
    int index;

    QFileInfoList fileList = files.entryInfoList(QDir::Files, QDir::Time);
    qDebug() << "WORKING";
    for (int i = 0; i < fileList.length(); i++) {
        qDebug() << "A1:" << fileList.at(i).absoluteFilePath() << fileList.at(i).lastModified().toString();
    }

    if (fileList.length() < 1)
        return "err";

    qDebug() << "The oldest file: " << fileList.at(fileList.length()-1).absoluteFilePath() << fileList.at(fileList.length()-1).lastModified().toString();
    QStringList list = fileList.at(fileList.length()-1).absoluteFilePath().split("/");

    index = list.length() - 1;
    if (index < 0)
        return "err";

    qDebug() << "OK";
    if (list.length() > 1)
        fileName = list.at(list.length()-1);
    else
        fileName = "err";

    list = fileName.split("__");

    if (list.length() > 1)
        fileName = list.at(0) + "_";
    else {
        list = fileName.split("_part");
        if (list.length() > 1)
            fileName = list.at(0);
        else
            fileName = "err";
    }

    return fileName;
}

/*
 * Checki if basename fileName is free for all parts.
 */
bool File::isFileNameFree(const QString &fileName)
{
    QFile file1;
    QFile file2;
    QFile file3;
    QFile file4;
    QFile file5;
    QFile file6;

    file1.setFileName(fileName + "_part_1.mp4");
    file2.setFileName(fileName + "_part_2.mp4");
    file3.setFileName(fileName + "_part_3.mp4");
    file4.setFileName(fileName + "_part_4.mp4");
    file5.setFileName(fileName + "_part_5.mp4");
    file6.setFileName(fileName + "_part_6.mp4");

    if(!file1.exists() && !file2.exists() && !file3.exists()
             && !file4.exists() && !file5.exists() && !file6.exists()) {
        return true;
    }

    return false;
}

/*
 * Generarte new filename based on baseName.
 */
QString File::generateNewFileName(const QString &baseName)
{
    bool ready = false;
    bool fileFree = true;
    int counter = 0;
    QString data;

    while (!ready) {
        fileFree = true;

        if(counter > 0)
            fileFree = isFileNameFree(APP_DIR APP_NAME "/" + baseName + "_" + QString::number(counter) + "_");
        else
            fileFree = isFileNameFree(APP_DIR APP_NAME "/" + baseName);

        if(counter == 0)
            data = baseName;
        else
            data = baseName + "_" + QString::number(counter) + "_";

        if( fileFree) {
            return data;
        }

        counter++;

        if(counter > 50000)
            ready = true;
    }

    return APP_NAME;
}

/*
 * If not exists, creates app catalog (where are stored temporary files)
 */
void File::createAppCatalog()
{
    QDir dir(APP_DIR APP_NAME);

    if(!dir.exists()) {
        dir.mkdir(APP_DIR APP_NAME);
    }
}

bool File::init()
{
    activeFileNumber = 1;

    if(!checkIfNotExists())
        return false;

    createAppCatalog();

    return true;
}

bool File::checkIfNotExists()
{
    QFile file(APP_DIR APP_NAME "/" + fileName);

    if(file.exists())
        return false;

    return true;
}

/*
 * Changes currenlty use temporary file
 */
void File::changeFile(int partNumber)
{
    activeFileNumber = partNumber + 1;
    fileName = generatedFileName + "_part_" + QString::number(activeFileNumber) + ".mp4";
}

/*
 * Moves currently recorder part to .videos dir
 */
bool File::fileReady()
{
    return true;
}

/*
 * Returns number of the currently used temporary file
 */
int File::getActiveFileNumber()
{
    return activeFileNumber;
}

/*
 * Returns full name of the currently used temporary file
 */
QString File::getActiveFile()
{
    QFile file(APP_DIR APP_NAME "/" + fileName);

    return file.fileName();
}

QString File::getGeneratedFileName()
{
    return generatedFileName;
}
