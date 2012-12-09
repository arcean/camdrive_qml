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
        title: "Other settings"
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

        LabelSeparator {
            id: generalLabel
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Velocity unit"
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
