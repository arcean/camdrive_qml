// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: master

    property alias source: image.source
    property alias highlightSource: highlight.source
    signal clicked()

    Image {
        anchors { top: parent.top; bottom: parent.bottom;
            left: parent.left; right: parent.right; }
        id: image
        opacity: 1
    }
    Image {
        anchors { top: parent.top; bottom: parent.bottom;
            left: parent.left; right: parent.right; }
        id: highlight
        opacity: 0
    }

    MouseArea {
        anchors.fill: master

        onPressed: {
            highlight.opacity = 0.3;
        }

        onReleased: {
            highlight.opacity = 0;
        }

        onClicked: {
            master.clicked();
        }

    }
}
