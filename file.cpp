#include "file.h"
#include <QDebug>

File::File(QString fileName)
{
    init();

    QString generatedFileName = generateNewFileName(fileName);

    this->fileName = generatedFileName + ".mp4";
    this->tempFileName1 = generatedFileName + "1.mp4";
    this->tempFileName2 = generatedFileName + "2.mp4";
}

QString File::generateNewFileName(QString baseName)
{
    bool ready = false;
    int counter = 0;
    QFile file;
    QString data;

    while (!ready) {
        if(counter > 0)
            file.setFileName(APP_DIR APP_NAME "/" + baseName + "(" + QString::number(counter) +").mp4");
        else
            file.setFileName(APP_DIR APP_NAME "/" + baseName + ".mp4");

        if(counter == 0)
            data = baseName;
        else
            data = baseName + "(" + QString::number(counter) +")";

        if(!file.exists()) {
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
    if(!checkIfNotExists())
        return false;

    createAppCatalog();

    //activeFile = tempFileName1
    activeFile = 0;

    return true;
}

bool File::checkIfNotExists()
{
    //createAppCatalog();

    QFile file1(APP_DIR APP_NAME "/" + tempFileName1);
    QFile file2(APP_DIR APP_NAME "/" + tempFileName2);

    if(file1.exists() || file2.exists())
        return false;

    return true;
}

/*
  Changes currenlty use temporary file
  */
void File::changeFile()
{
    if(activeFile) {
        QFile file(APP_DIR APP_NAME "/" + tempFileName1);

        activeFile = 0;
        file.remove();

    } else {
        QFile file(APP_DIR APP_NAME "/" + tempFileName2);

        activeFile = 1;
        file.remove();
    }
}

/*
  Moves currently recorder part to .videos dir
  */
bool File::fileReady()
{
    bool succeed = false;

    if(activeFile) {
        QFile file(APP_DIR APP_NAME "/" + tempFileName2);

        succeed = file.rename(APP_DIR APP_NAME "/" + fileName);
    } else {
        QFile file(APP_DIR APP_NAME "/" + tempFileName1);

        succeed = file.rename(APP_DIR APP_NAME "/" + fileName);
    }

    removeTempFiles();

    return succeed;
}

/*
  Removes temporary files
  */
void File::removeTempFiles()
{
    QFile file1(APP_DIR APP_NAME "/" + tempFileName1);
    QFile file2(APP_DIR APP_NAME "/" + tempFileName2);

    file1.remove();
    file2.remove();
}

/*
  Returns number of the currently used temporary file
  */
int File::getActiveFileNumber()
{
    return activeFile;
}

/*
  Returns full name of the currently used temporary file
  */
QString File::getActiveFile()
{
    qDebug() << "Active file: " << activeFile;
    if(activeFile)
        return QString(APP_DIR APP_NAME "/" + tempFileName2);
    else
        return QString(APP_DIR APP_NAME "/" + tempFileName1);
}
