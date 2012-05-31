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
        contentHeight: otherColumn.y + otherColumn.height - separator1Label.y

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
            title: qsTr("Save the last")
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

        Separator {
            anchors.left: parent.left
            anchors.right: separator2Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator2Label.verticalCenter
        }
        Label {
            id: separator2Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: storeLastButton.bottom
            anchors.topMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Video storing"
        }

        SelectionItem {
            id: videoStoreButton
            y: separator2Label.y + separator2Label.height + 10
            title: qsTr("Keep only the last")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("Unlimited number of videos"); value: 0; }
                ListElement { name: QT_TR_NOOP("2 videos"); value: 2; }
                ListElement { name: QT_TR_NOOP("5 videos"); value: 5; }
                ListElement { name: QT_TR_NOOP("10 videos"); value: 10; }
                ListElement { name: QT_TR_NOOP("20 videos"); value: 20; }
            }
            initialValue: settingsObject.getMaxVideoFiles()
            onValueChosen: settingsObject.setMaxVideoFiles(value)
        }

        Label {
            id: backgroundLabel
            anchors.right: parent.right
            anchors.top: videoStoreButton.bottom
            anchors.topMargin: 10
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Record in background"
        }

        Separator {
            anchors.right: backgroundLabel.left
            anchors.left: parent.left
            anchors.rightMargin: 20
            anchors.verticalCenter: backgroundLabel.verticalCenter
        }

        Label {
            id: backgroundSwitchLabel
            anchors.left: parent.left
            anchors.top: backgroundLabel.bottom
            anchors.topMargin: 10
            text: "Record in background"
        }

        Switch {
            id: backgroundSwitch
            anchors.right: parent.right
            anchors.verticalCenter: backgroundSwitchLabel.verticalCenter

            checked: settingsObject.getRecordingInBackground()
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                settingsObject.setRecordingInBackground(checked)
            }
        }

        Label {
            id: offlineLabel
            anchors.right: parent.right
            anchors.top: backgroundSwitch.bottom
            anchors.topMargin: 10
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Offline mode"
        }

        Separator {
            anchors.right: offlineLabel.left
            anchors.left: parent.left
            anchors.rightMargin: 20
            anchors.verticalCenter: offlineLabel.verticalCenter
        }

        Label {
            id: offlineSwitchLabel
            anchors.left: parent.left
            anchors.top: offlineLabel.bottom
            anchors.topMargin: 10
            text: "Offline mode while recording"
        }

        Switch {
            id: offlineSwitch
            anchors.right: parent.right
            anchors.verticalCenter: offlineSwitchLabel.verticalCenter

            checked: settingsObject.isOfflineMode()
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                settingsObject.setOfflineMode(checked)
            }
        }

        Separator {
            anchors.left: parent.left
            anchors.right: separator3Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator3Label.verticalCenter
        }
        Label {
            id: separator3Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: offlineSwitch.bottom
            anchors.topMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Other"
        }

        Column {
            id: otherColumn
            anchors { left: parent.left; right: parent.right; top: separator3Label.bottom; topMargin: 10; }
            height: 160

            Repeater {
                id: repeater
                model: ListModel {
                    id: otherColumnModel

                    ListElement { name: QT_TR_NOOP("Video"); fileName: "VideoSettingsPage.qml" }
                    ListElement { name: QT_TR_NOOP("Audio"); fileName: "AudioSettingsPage.qml" }
                }

                DrillDownDelegate {
                    id: delegate
                    width: otherColumn.width
                    title: name
                    onClicked: appWindow.pageStack.push(Qt.resolvedUrl(fileName))
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
