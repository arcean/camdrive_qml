import QtQuick 1.0
import com.nokia.meego 1.0
import "../"

Image {
    id: header
    property string text: ""
    property string detailsText: ""
    z: 1
    height: 72
    source: "image://theme/" + _ACTIVE_COLOR + "-meegotouch-view-header-fixed"
    Label {
        id: titleLabel
        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }

        text: header.text
        color: _TEXT_COLOR
        font.pixelSize: _STANDARD_FONT_SIZE
        font.bold: true
    }

    Label {
        id: detailsLabel
        anchors {
            top: titleLabel.bottom
            horizontalCenter: parent.horizontalCenter
        }

        text: header.detailsText
        color: _TEXT_COLOR
        font.pixelSize: _SMALL_FONT_SIZE
        font.bold: false
    }
}
