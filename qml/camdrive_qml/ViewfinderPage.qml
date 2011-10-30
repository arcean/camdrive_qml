import QtQuick 1.1
import com.meego 1.0
import FrontCamera 1.0
import QtMobility.sensors 1.2

Page {
    tools: commonTools

    id:videoPage
    property int orientation: 0

    orientationLock: PageOrientation.LockLandscape

    function updateScaleRotation()
    {
        if(camMirrorScale.xScale>0 &&
                (videoPage.orientation == 1 ||
                 videoPage.orientation== 2))
        {
            camMirrorRotate.angle = 180
        }
        else {
            camMirrorRotate.angle = 0
        }
    }

    OrientationSensor {
        id:orientationSensor
        dataRate: 200
        active:platformWindow.visible
        onReadingChanged: {
            videoPage.orientation = reading.orientation
            updateScaleRotation()
        }
    }

    Scale {
        id:camMirrorScale
        origin.x:parent.width/2
        origin.y:parent.height/2
        xScale:-1
    }

    Rotation {
        id:camMirrorRotate
        origin.x:parent.width/2
        origin.y:parent.height/2
        angle:0
    }

    Connections {
        target:platformWindow

        onActiveChanged: {
            if(platformWindow.active) {
                orientationSensor.start()
                frontCam.start()
            }
            else {
                frontCam.stop()
                orientationSensor.stop()
            }
        }
    }


    FrontCamera {
        id:frontCam
        anchors.centerIn: parent
        width:videoPage.width
        height:videoPage.height
        transform: [camMirrorScale, camMirrorRotate]
        // aspectRatio:Qt.KeepAspectRatioByExpanding
    }

    Item {
        width:64
        height:64
        x:12
        y:12
        Image {
            width:64
            height:64
            id:flipped
            anchors.centerIn: parent
            opacity: (camMirrorScale.xScale>0) ? 0.0 : 1.0
            source:"qrc:/flipped.png"

        }
        Image {
            width:64
            height:64
            id:notFlipped
            anchors.centerIn: parent
            opacity: (camMirrorScale.xScale>0) ? 1.0 : 0.0
            source:"qrc:/notflipped.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //camMirrorScale.xScale = -1 * camMirrorScale.xScale
                //updateScaleRotation()
                frontCam.toggleCamera()
            }
        }
    }

}
