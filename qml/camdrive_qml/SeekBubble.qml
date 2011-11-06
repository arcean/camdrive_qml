import QtQuick 1.0
import com.nokia.meego 1.0

Image {

    property string value

    source: "images/seekbubble.png"
    opacity: 0

    Behavior on opacity { PropertyAnimation { properties: "opacity"; duration: 200 } }

    Label {
        anchors { fill: parent; bottomMargin: 20 }
        text: parent.value
        font.pixelSize: text.length > 5 ? _SMALL_FONT_SIZE : _STANDARD_FONT_SIZE
        color: "#4d4d4d"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
