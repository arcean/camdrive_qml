#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include <QGLWidget>

#include "qdeclarativecamera.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName("arcean");
    app.setOrganizationDomain("arcean.com");
    app.setApplicationName("camdrive");

    QmlApplicationViewer viewer;
    viewer.setViewport(new QGLWidget());
    qmlRegisterType<QDeclarativeCamera>("Camera", 1, 0, "Camera");
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/camdrive_qml/main.qml"));
    viewer.showFullScreen();

    return app.exec();
}
