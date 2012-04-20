// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: master
    width: label.x + label.width + 30
    height: 100
    visible: false

    function showSpeedWarning() {
        timer.start();
        master.visible = true;
    }

    Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.5

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            color: "black"
        }
    }

    Image {
        id: image
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.leftMargin: 10
        width: 80
        height: 80
        source: "images/warning.png"
    }

    Label {
        id: label
        anchors.left: image.right
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        text: "You have exceeded the speed limit!"
        font.pixelSize: _LARGE_FONT_SIZE
        color: "white"
    }

    Timer {
        id: timer
        interval: 5000
        onTriggered: master.visible = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: master.visible = false
    }
}
