import QtQuick 1.0
import com.nokia.meego 1.0
import Settings 1.0
import "../"
import "../Common"
import "../StyledComponents"

Page {
    tools: ToolBarLayout {
        id: toolBar

        ToolIcon {
            anchors.left: parent.left
            platformIconId: "toolbar-back"
            onClicked: appWindow.pageStack.pop()
        }
    }

    Settings {
        id: settingsObject
    }

    Component.onCompleted: {
    }

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Other settings"
    }

    Flickable {
        id: flicker

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: parent.bottom
            leftMargin: _MARGIN
            rightMargin: _MARGIN
            topMargin: _MARGIN
        }
        boundsBehavior: Flickable.DragOverBounds
        contentWidth: width
        contentHeight: velocityUnit.y + velocityUnit.height - generalLabel.y

        Label {
            id: generalLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Velocity unit"
        }

        Separator {
            anchors.right: generalLabel.left
            anchors.left: parent.left
            anchors.rightMargin: 20
            anchors.verticalCenter: generalLabel.verticalCenter
        }

        SelectionItem {
            id: velocityUnit
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: generalLabel.bottom
            anchors.topMargin: 10
            title: qsTr("Velocity unit")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("km/h"); value: 1; }
                ListElement { name: QT_TR_NOOP("mph"); value: 0; }
            }
            initialValue: settingsObject.getVelocityUnit() ? 1 : 0;
            onValueChosen: value == 1 ? settingsObject.setVelocityUnit(true) : settingsObject.setVelocityUnit(false)
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
