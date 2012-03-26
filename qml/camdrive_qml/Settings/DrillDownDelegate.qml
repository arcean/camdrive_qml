import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: delegate

    property string title

    signal clicked
    signal pressAndHold

    width: parent.width
    height: 80

    ListHighlight {
        visible: mouseArea.pressed
    }

    Label {
        font.bold: true
        anchors { fill: parent; leftMargin: 10 }
        verticalAlignment: Text.AlignVCenter
        text: title
    }

    Image {
        anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
        source: theme.inverted ? "images/drilldown-arrow-white.png" : "images/drilldown-arrow.png"
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}
