import QtQuick 1.0
import com.nokia.meego 1.0
import "../"

Image {
    id: header
    property string text: ""
    z: 1
    height: 72
    source: "image://theme/" + _ACTIVE_COLOR + "-meegotouch-view-header-fixed"
    Label {
        id: titleLabel
        anchors.verticalCenter: parent.verticalCenter
        x: (parent.width / 2) - titleLabel.width/2
        text: header.text
        color: _TEXT_COLOR
        font.pixelSize: _STANDARD_FONT_SIZE
        font.bold: true
    }
}
