import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import Settings 1.0
import "../"
import "../Common"
import "../StyledComponents"
import "../scripts/utils.js" as Utils

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
        contactsSwitch.checked = settingsObject.getEmergencyContactNameEnabled();
        contacts.enabled = contactsSwitch.checked;
    }

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Alarms settings"
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
        contentHeight: messageContact.y + messageContact.height - separator4Label.y

        Separator {
            anchors.left: parent.left
            anchors.right: separator4Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator4Label.verticalCenter
        }
        Label {
            id: separator4Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Accelerometer"
        }

        SelectionItem {
            id: accelerometerButton
            anchors.top: separator4Label.bottom
            anchors.topMargin: 10
            title: qsTr("Sensitivity")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("High"); value: 1; }
                ListElement { name: QT_TR_NOOP("Normal"); value: 2; }
                ListElement { name: QT_TR_NOOP("Low"); value: 3; }
            }
            initialValue: settingsObject.getAccelerometerTreshold()
            onValueChosen: {
                settingsObject.resetAccelerometerIgnoreLevel();
                settingsObject.setAccelerometerTreshold(value);
            }
        }

        Separator {
            anchors.left: parent.left
            anchors.right: separator1Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator1Label.verticalCenter
        }

        Label {
            id: separator1Label
            anchors.top: accelerometerButton.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Speed alarm"
        }

        SelectionItem {
            id: maxAllowedSpeed
            anchors.top: separator1Label.bottom
            anchors.topMargin: 10
            title: qsTr("Max allowed speed")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("Disabled"); value: 0; }
                ListElement { name: QT_TR_NOOP("50"); value: 50; }
                ListElement { name: QT_TR_NOOP("60"); value: 60; }
                ListElement { name: QT_TR_NOOP("70"); value: 70; }
                ListElement { name: QT_TR_NOOP("80"); value: 80; }
                ListElement { name: QT_TR_NOOP("90"); value: 90; }
                ListElement { name: QT_TR_NOOP("100"); value: 100; }
                ListElement { name: QT_TR_NOOP("110"); value: 110; }
                ListElement { name: QT_TR_NOOP("120"); value: 120; }
                ListElement { name: QT_TR_NOOP("130"); value: 130; }
                ListElement { name: QT_TR_NOOP("140"); value: 140; }
            }
            initialValue: settingsObject.getMaxAllowedSpeed()
            onValueChosen: settingsObject.setMaxAllowedSpeed(value)
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
            anchors.top: maxAllowedSpeed.bottom
            anchors.topMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Emergency service number"
        }

        SelectionItem {
            id: emergencyButton
            anchors.top: separator3Label.bottom
            anchors.topMargin: 10
            title: qsTr("Emergency number")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("Disabled"); value: "0"; }
                ListElement { name: QT_TR_NOOP("112"); value: "112"; }
                ListElement { name: QT_TR_NOOP("911"); value: "911"; }
                ListElement { name: QT_TR_NOOP("999"); value: "999"; }
            }
            initialValue: settingsObject.getEmergencyNumber()
            onValueChosen: settingsObject.setEmergencyNumber(value)
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
            anchors.top: emergencyButton.bottom
            anchors.topMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Friend's contact"
        }

        Label {
            id: contactsLabel
            anchors.left: parent.left
            anchors.top: separator2Label.bottom
            anchors.topMargin: 10
            text: "Friend's emergency contact"
        }
        Switch {
            id: contactsSwitch
            anchors.right: parent.right
            anchors.verticalCenter: contactsLabel.verticalCenter

            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                settingsObject.setEmergencyContactNameEnabled(checked)
                contacts.enabled = checked;
            }
        }

        SelectContact {
            id: contacts
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: contactsLabel.bottom
            onVkbdOpen: {
                if(_IN_PORTRAIT)
                    flicker.contentY = flicker.height / 3;
                else
                    flicker.contentY = flicker.height;
            }
        }

        Column {
            id: messageContact
            anchors { left: parent.left; right: parent.right }
            anchors.top: contacts.bottom
            height: 80

            Repeater {
                id: repeater
                model: ListModel {
                    id: settingsModel

                    ListElement { name: QT_TR_NOOP("Set text message"); fileName: "TextMessage.qml" }
                }

                DrillDownDelegate {
                    id: delegate
                    width: messageContact.width
                    title: name
                    onClicked: {
                        var setMessageSheet = Utils.createObject(Qt.resolvedUrl(fileName), appWindow.pageStack);
                        setMessageSheet.open();
                    }
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
