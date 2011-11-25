#include "file.h"
#include <QDebug>

File::File(QString fileName)
{
    init();

    generatedFileName = generateNewFileName(fileName);

    this->fileName = generatedFileName + "_" + activeFileNumber + ".mp4";
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

    activeFileNumber = 1;

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
void File::changeFile()
{
    activeFileNumber++;
    fileName = generatedFileName + "_" + activeFileNumber + ".mp4";
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
    return fileName;
}
