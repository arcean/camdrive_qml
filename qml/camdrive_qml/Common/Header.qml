import QtQuick 1.0
import com.nokia.meego 1.0

Image {
    id: header
    z: 1
    height: 72
    source: "image://theme/" + _ACTIVE_COLOR + "-meegotouch-view-header-fixed"

    property alias title: titleLabel.text

    Label {
        id: titleLabel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: _MARGIN
        color: "white"
        font.pixelSize: _HEADER_FONT_SIZE
        //font.bold: true
    }
}
