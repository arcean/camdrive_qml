#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include <QGLWidget>

#include "qdeclarativecamera.h"
#include "settings.h"
#include "utils.h"
#include "databasehelper.h"
#include "videothumbnails.h"
#include "accelerometer.h"
#include "gps.h"
#include "geocoder.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("arcean");
    app.setOrganizationDomain("arcean.com");
    app.setApplicationName("camdrive");

    QmlApplicationViewer viewer;
    Utils utils;
    DatabaseHelper databaseHelper;
    Database database;
    VideoThumbnails thumbnails;
    Accelerometer accelerometer;
    Gps gps;

    viewer.setViewport(new QGLWidget());
    qmlRegisterType<QDeclarativeCamera>("Camera", 1, 0, "Camera");
    qmlRegisterType<Settings>("Settings", 1, 0, "Settings");
    qmlRegisterType<GeoCoder>("GeoCoder",1,0 ,"GeoCoder");

    QDeclarativeContext *context = viewer.rootContext();
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("DatabaseHelper", &databaseHelper);
    context->setContextProperty("Database", &database);
    context->setContextProperty("Thumbnails", &thumbnails);
    context->setContextProperty("AccelDevice", &accelerometer);
    context->setContextProperty("Gps", &gps);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/camdrive_qml/main.qml"));

    viewer.showFullScreen();

    return app.exec();
}
