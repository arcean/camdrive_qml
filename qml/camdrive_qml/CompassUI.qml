import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.sensors 1.2

Rectangle {
    id: mainLayout
    color: "transparent"

    //! Properties
    property int azimuth: 0
    property real calibrationLevel: 0
    property int rotationX: 0
    property int rotationY: 0
    property int rotationZ: 0
    property int orientation: 0
    property string orientationDesc: ""
    property bool isFaceUp: false

    /*! States and transitions */
    states: [
        State {
            name: "showcompass"; when: isFaceUp
            PropertyChanges { target: compass2D; opacity: 1.0 }
            PropertyChanges { target: compass25D; opacity: 0.0 }
        },
        State {
            name: "showcompass25d"; when: !isFaceUp
            PropertyChanges { target: compass2D; opacity: 0.0 }
            PropertyChanges { target: compass25D; opacity: 1.0 }
        }
    ]

    //! Flat compass on FaceUp
    CompassUI2D {
        id: compass2D
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        size: 380-50
        azimuth: parent.azimuth

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutInQuad; duration: 200 }
        }
    }

    //! Transformed 2.5D compass on !FaceUp
    CompassUI25D {
        id: compass25D
        anchors.margins: UiConstants.DefaultMargin
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        size: 380-50
        azimuth: parent.azimuth
        rotationX: parent.rotationX
        rotationY: parent.rotationY

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutInQuad; duration: 200 }
        }
    }
}

//!  End of File
