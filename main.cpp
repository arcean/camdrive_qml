#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include <QGLWidget>

#include "qdeclarativefrontcamera.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);


    QmlApplicationViewer viewer;
    viewer.setViewport(new QGLWidget());
    qmlRegisterType<QDeclarativeFrontCamera>("FrontCamera", 1, 0, "FrontCamera");
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/camdrive_qml/main.qml"));
    viewer.showFullScreen();

    return app.exec();
}
