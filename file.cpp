#include "file.h"
#include <QDebug>

File::File(QString fileName)
{
    init();

    generatedFileName = generateNewFileName(fileName);

    this->fileName = generatedFileName + "_part_" + QString::number(activeFileNumber) + ".mp4";
}

QString File::generateNewFileName(QString baseName)
{
    bool ready = false;
    int counter = 0;
    QFile file;
    QString data;

    while (!ready) {
        if(counter > 0)
            file.setFileName(APP_DIR APP_NAME "/" + baseName + "(" + QString::number(counter) +")_part_1.mp4");
        else
            file.setFileName(APP_DIR APP_NAME "/" + baseName + "_part_1.mp4");

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
