import QtQuick 1.0
import com.nokia.meego 1.0
import "../"

Image {
    id: header
    property string text: ""
    property string detailsText: ""
    property bool clickable: false
    signal clicked()
    z: 1
    height: 72
    source: (mouseArea.pressed && clickable) ? "image://theme/" + _ACTIVE_COLOR + "-meegotouch-view-header-fixed-pressed" :
                                               "image://theme/" + _ACTIVE_COLOR + "-meegotouch-view-header-fixed"

    Label {
        id: titleLabel
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: _MARGIN
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
            left: parent.left
            leftMargin: _MARGIN
        }

        text: header.detailsText
        color: _TEXT_COLOR
        font.pixelSize: _SMALL_FONT_SIZE
        font.bold: false
    }

    Image {
        anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
        source: (theme.inverted) ? _ICON_LOCATION + "icon-m-textinput-combobox-arrow.png" : _ICON_LOCATION + "icon-m-common-combobox-arrow.png"
        sourceSize.width: width
        sourceSize.height: height
        visible: header.clickable
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            header.clicked();
        }
    }
}
