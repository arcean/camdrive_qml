import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.1
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
        theme.inverted = true;
    }

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Recording settings"
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
        contentHeight: storeLastButton.y + storeLastButton.height - separator1Label.y

        Separator {
            anchors.left: parent.left
            anchors.right: separator1Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator1Label.verticalCenter
        }
        Label {
            id: separator1Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Video length"
        }

        SelectionItem {
            id: storeLastButton
            y: separator1Label.y + separator1Label.height + 10
            title: qsTr("Store last")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("Unlimited length"); value: 0; }
                ListElement { name: QT_TR_NOOP("3 minutes"); value: 3; }
                ListElement { name: QT_TR_NOOP("5 minutes"); value: 5; }
                ListElement { name: QT_TR_NOOP("10 minutes"); value: 10; }
                ListElement { name: QT_TR_NOOP("20 minutes"); value: 20; }
                ListElement { name: QT_TR_NOOP("30 minutes"); value: 30; }
            }
            initialValue: settingsObject.getStoreLast()
            onValueChosen: settingsObject.setStoreLast(value)
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
