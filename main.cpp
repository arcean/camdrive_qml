#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include <QtOpenGL/QGLWidget>
#include <MDeclarativeCache>
#include <QtCore/QtGlobal>

#include "qdeclarativecamera.h"
#include "settings.h"
#include "utils.h"
#include "databasehelper.h"
#include "videothumbnails.h"
#include "accelerometer.h"
#include "gps.h"
#include "geocoder.h"
#include "telephony.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication* app = MDeclarativeCache::qApplication(argc, argv);
    QDeclarativeView* view = MDeclarativeCache::qDeclarativeView();
    app->setOrganizationName("arcean");
    app->setOrganizationDomain("arcean.com");
    app->setApplicationName("camdrive");

    Utils utils;
    DatabaseHelper databaseHelper;
    Database database;
    VideoThumbnails thumbnails;
    Accelerometer accelerometer;
    Gps gps;

    view->setViewport(new QGLWidget());
    qmlRegisterType<QDeclarativeCamera>("Camera", 1, 0, "Camera");
    qmlRegisterType<Settings>("Settings", 1, 0, "Settings");
    qmlRegisterType<GeoCoder>("GeoCoder",1,0 ,"GeoCoder");
    qmlRegisterType<Telephony, 1>("Telephony", 1, 0, "Telephony");

    QDeclarativeContext *context = view->rootContext();
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("DatabaseHelper", &databaseHelper);
    context->setContextProperty("Database", &database);
    context->setContextProperty("Thumbnails", &thumbnails);
   // context->setContextProperty("AccelDevice", &accelerometer);
    context->setContextProperty("Gps", &gps);

    view->setSource(QUrl::fromLocalFile("/opt/camdrive_qml/qml/camdrive_qml/main.qml"));

    view->showFullScreen();

    return app->exec();
}
