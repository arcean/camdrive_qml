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

    function selectMaxAllowedSpeed()
    {
        if(!settingsObject.getMaxAllowedSpeedEnabled()) {
            maxAllowedSpeedLabel.enabled = false;
            maxAllowedSpeedButton.enabled = false;
            speedAlarmSwitch.checked = false;
            maxAllowedSpeedButton.text = settingsObject.getMaxAllowedSpeed();
        }
        else {
            maxAllowedSpeedLabel.enabled = true;
            maxAllowedSpeedButton.enabled = true;
            speedAlarmSwitch.checked = true;
            maxAllowedSpeedButton.text = settingsObject.getMaxAllowedSpeed();
        }

    }

    Component.onCompleted: {
        selectMaxAllowedSpeed();
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
        contentHeight: maxAllowedSpeedButton.y + maxAllowedSpeedButton.height - speedAlarmLabel.y

        Label {
            id: speedAlarmLabel
            anchors.left: parent.left
            text: "Enable speed alarm:"
        }

        Switch {
            id: speedAlarmSwitch
            anchors.right: parent.right
            anchors.verticalCenter: speedAlarmLabel.verticalCenter

            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                maxAllowedSpeedLabel.enabled = checked;
                maxAllowedSpeedButton.enabled = checked;
                speedAlarmSwitch.checked = checked;
                settingsObject.setMaxAllowedSpeedEnabled(checked)
            }
        }

        Label {
            id: maxAllowedSpeedLabel
            anchors.left: parent.left
            y: speedAlarmLabel.y + speedAlarmLabel.height + 20
            text: "Max allowed speed:"
        }

        TumblerButton {
            id: maxAllowedSpeedButton
            anchors.right: parent.right
            anchors.left: parent.left
            y: maxAllowedSpeedLabel.y + maxAllowedSpeedLabel.height + 20
            style: StyledTumblerButton {}
            text: {
                speedAlarmDialog.selectedIndex >= 0 ? speedAlarmDialog.model.get(speedAlarmDialog.selectedIndex).name : settingsObject.getMaxAllowedSpeed()
            }
            onClicked: {
                speedAlarmDialog.open()
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }

    SelectionDialog {
        id: speedAlarmDialog
        titleText: "Max allowed speed"
        platformStyle: StyledSelectionDialog {}

        model: ListModel {
            ListElement { name: "50"; value: 50; }
            ListElement { name: "60"; value: 60; }
            ListElement { name: "80"; value: 80; }
            ListElement { name: "90"; value: 90; }
            ListElement { name: "100"; value: 100; }
            ListElement { name: "110"; value: 110; }
            ListElement { name: "120"; value: 120; }
            ListElement { name: "130"; value: 130; }
            ListElement { name: "140"; value: 140; }
            ListElement { name: "150"; value: 150; }
        }

        onAccepted: {
            settingsObject.setMaxAllowedSpeed(speedAlarmDialog.model.get(speedAlarmDialog.selectedIndex).value);
            maxAllowedSpeedButton.text = speedAlarmDialog.model.get(speedAlarmDialog.selectedIndex).name;
        }
    }
}
