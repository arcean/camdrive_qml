import QtQuick 1.0
import com.nokia.meego 1.0

Rectangle {
    id: compass
    property alias size: compass.width
    property real azimuth: 0

    color: "transparent"
    smooth: true
    height: width

    CompassUI2DFace {
        id: face
        effectColor: "white"
        rotation: -parent.azimuth - 90  // -90 because we are in landscape
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        showBackground: true
        border.width: 4
    }

    transformOrigin: Item.Center
    transform: Rotation {}
}

//!  End of File
