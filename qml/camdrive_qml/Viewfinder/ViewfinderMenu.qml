// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../scripts/utils.js" as Utils
import "../Common"

Item {
    id: master
    width: 600
    height: 136

    function showMapsPage()
    {
        var mapsPage = Utils.createObject(Qt.resolvedUrl("Map.qml"), appWindow.pageStack);
        showToolbar();
        pageStack.push(mapsPage);
    }

    Rectangle {
        id: rect1
        anchors.fill: parent

        color: "black"
        opacity: 0.5
        radius: 50
        smooth: true
    }

    Rectangle {
        id: rect2
        anchors.fill: rect1
        anchors.margins: 4

        color: "black"
        opacity: 0.6
        radius: 50
        smooth: true
    }

    ButtonHighlight {
        id: backButton
        anchors { top: rect2.top; left: rect2.left; topMargin: 4; leftMargin: 12; }
        width: 120
        height: width

        source: "../images/arrow.png"
        highlightSource: "../images/highlight120.png"

        onClicked: {
            viewfinderPage.closeMenuFunc();
        }
    }

    ButtonHighlight {
        id: stopButton
        anchors { top: rect2.top; topMargin: 4; horizontalCenter: rect2.horizontalCenter; }
        width: 120
        height: width

        source: "../images/stop.png"
        highlightSource: "../images/highlight120.png"
        onClicked: {
            viewfinderPage.close();
            viewfinderPage.closeMenuFunc();
        }
    }

    ButtonHighlight {
        id: mapButton
        anchors { top: rect2.top; topMargin: 4; right: rect2.right; rightMargin: 12; }
        width: 120
        height: width

        source: "../images/map.png"
        highlightSource: "../images/highlight120.png"
        onClicked: {
            viewfinderPage.pauseRecording();
            showMapsPage();
        }
    }

}
