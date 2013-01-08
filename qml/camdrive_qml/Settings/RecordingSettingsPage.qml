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
        title: "Recording settings"
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

        LabelSeparator {
            id: separator1Label
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top

            text: "Video length"
        }

        SelectionItem {
            id: storeLastButton
            anchors.top: separator1Label.bottom
            anchors.topMargin: _MARGIN
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

        LabelSeparator {
            id: separator2Label
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: storeLastButton.bottom
            anchors.topMargin: _MARGIN

            text: "Video storing"
        }

        SelectionItem {
            id: videoStoreButton
            anchors.top: separator2Label.bottom
            anchors.topMargin: _MARGIN
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

        LabelSeparator {
            id: backgroundLabel
            anchors.right: parent.right
            anchors.top: videoStoreButton.bottom
            anchors.topMargin: _MARGIN
            anchors.left: parent.left

            text: "Record in background"
        }

        Label {
            id: backgroundSwitchLabel
            anchors.left: parent.left
            anchors.top: backgroundLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH
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

        LabelSeparator {
            id: offlineLabel
            anchors.right: parent.right
            anchors.top: backgroundSwitchLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH
            anchors.left: parent.left

            text: "Offline mode"
        }

        Label {
            id: offlineSwitchLabel
            anchors.left: parent.left
            anchors.top: offlineLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH
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

        LabelSeparator {
            id: separator3Label
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: offlineSwitchLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH

            text: "Other"
        }

        Column {
            id: otherColumn
            anchors { left: parent.left; right: parent.right; top: separator3Label.bottom; topMargin: _MARGIN; }
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
