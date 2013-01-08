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
        title: "Alarms settings"
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

        LabelSeparator {
            id: separator4Label
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Accelerometer"
        }

        SelectionItem {
            id: accelerometerButton
            anchors.top: separator4Label.bottom
            anchors.topMargin: _MARGIN
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

        LabelSeparator {
            id: separator1Label
            anchors.top: accelerometerButton.bottom
            anchors.topMargin: _MARGIN
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Speed alarm"
        }

        SelectionItem {
            id: maxAllowedSpeed
            anchors.top: separator1Label.bottom
            anchors.topMargin: _MARGIN
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

        LabelSeparator {
            id: separator3Label
            anchors.top: maxAllowedSpeed.bottom
            anchors.topMargin: _MARGIN
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Emergency service number"
        }

        SelectionItem {
            id: emergencyButton
            anchors.top: separator3Label.bottom
            anchors.topMargin: _MARGIN
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

        LabelSeparator {
            id: separator2Label
            anchors.top: emergencyButton.bottom
            anchors.topMargin: _MARGIN
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Friend's contact"
        }

        Label {
            id: contactsLabel
            anchors.left: parent.left
            anchors.top: separator2Label.bottom
            anchors.topMargin: _MARGIN_SWITCH
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
            anchors.top: contactsLabel.bottom
            anchors.topMargin: _MARGIN
            anchors.right: parent.right
            anchors.left: parent.left

            onVkbdOpen: {
                if(_IN_PORTRAIT)
                    flicker.contentY = flicker.height / 3;
                else
                    flicker.contentY = flicker.height;
            }
        }

        Column {
            id: messageContact
            anchors { top: contacts.bottom; left: parent.left; right: parent.right }
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
