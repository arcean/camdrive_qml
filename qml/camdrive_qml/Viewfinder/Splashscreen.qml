// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../Common"

Item {
    id: master
    signal clicked()

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Image {
        id: touchImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../images/touch-white.png"
    }

    Label {
        id: descLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: touchImage.bottom
        anchors.topMargin: 40
        font.pixelSize: 24
        color: "white"
        text: "Touch screen to start recording"
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            master.clicked();
        }
    }

    ButtonHighlight {
        id: backImage
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 80
        height: width
        source: "../images/arrow.png"
        highlightSource: "../images/highlight80.png"

        onClicked: {
            appWindow.pageStack.pop()
        }
    }
}
