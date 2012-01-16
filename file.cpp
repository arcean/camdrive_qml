#include "file.h"
#include <QDebug>

File::File(const QString &fileName)
{
    init();

    generatedFileName = generateNewFileName(fileName);

    this->fileName = generatedFileName + "_part_" + QString::number(activeFileNumber) + ".mp4";
    qDebug() << "FNAME:" << this->fileName;
}

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
  If not exists, creates app catalog (where are stored temporary files)
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
  Changes currenlty use temporary file
  */
void File::changeFile(int partNumber)
{
    activeFileNumber = partNumber + 1;
    fileName = generatedFileName + "_part_" + QString::number(activeFileNumber) + ".mp4";
}

/*
  Moves currently recorder part to .videos dir
  */
bool File::fileReady()
{
    return true;
}

/*
  Returns number of the currently used temporary file
  */
int File::getActiveFileNumber()
{
    return activeFileNumber;
}

/*
  Returns full name of the currently used temporary file
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
