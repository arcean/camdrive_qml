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
        contentHeight: emergencyButton.y + emergencyButton.height - separator1Label.y

        Separator {
            anchors.left: parent.left
            anchors.right: separator1Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator1Label.verticalCenter
        }

        Label {
            id: separator1Label
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Speed alarm"
        }

        SelectionItem {
            id: maxAllowedSpeed
            y: separator1Label.y + separator1Label.height + 10
            title: qsTr("Max allowed speed")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("Disabled"); value: -1; }
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
            anchors.right: separator2Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator2Label.verticalCenter
        }
        Label {
            id: separator2Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: maxAllowedSpeed.y + maxAllowedSpeed.height + 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Friend's contact"
        }

        Label {
            id: contactsLabel
            anchors.left: parent.left
            y: separator2Label.y + separator2Label.height + 10
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
            y: contactsLabel.y + contactsLabel.height
        }

        Column {
            id: messageContact
            anchors { left: parent.left; right: parent.right }
            y: contacts.y + contacts.height
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
                    onClicked: appWindow.pageStack.push(Qt.resolvedUrl(fileName))
                }
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
            y: messageContact.y + messageContact.height + 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Emergency service number"
        }

        SelectionItem {
            id: emergencyButton
            y: separator3Label.y + separator3Label.height + 10
            title: qsTr("Emergency service number")
            model: ListModel {
                ListElement { name: QT_TR_NOOP("Disabled"); value: -1; }
                ListElement { name: QT_TR_NOOP("112"); value: 112; }
                ListElement { name: QT_TR_NOOP("911"); value: 911; }
                ListElement { name: QT_TR_NOOP("999"); value: 999; }
            }
            initialValue: settingsObject.getEmergencyNumber()
            onValueChosen: settingsObject.setEmergencyNumber(value)
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
