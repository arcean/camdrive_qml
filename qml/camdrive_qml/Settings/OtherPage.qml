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

    function selectVelocityUnit()
    {
        if(settingsObject.getVelocityUnit()) {
            velocityUnitButton.text = "km/h";
        }
        else {
            velocityUnitButton.text = "mph";
        }
    }

    Component.onCompleted: {
        selectVelocityUnit();
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
        contentHeight: velocityUnitButton.y + velocityUnitButton.height - velocityUnitLabel.y

        Label {
            id: velocityUnitLabel
            anchors.left: parent.left
            text: "Record audio:"
        }

        TumblerButton {
            id: velocityUnitButton
            anchors.right: parent.right
            anchors.left: parent.left
            y: velocityUnitLabel.y + velocityUnitLabel.height + 20
            style: StyledTumblerButton {}
            text: {
                velocityUnitDialog.selectedIndex >= 0 ? velocityUnitDialog.model.get(velocityUnitDialog.selectedIndex).name : "km/h"
            }
            onClicked: {
                velocityUnitDialog.open()
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }

    SelectionDialog {
        id: velocityUnitDialog
        titleText: "Velocity unit"
        selectedIndex: settingsObject.getVelocityUnit() ? 0 : 1
        platformStyle: StyledSelectionDialog {}

        model: ListModel {
            ListElement { name: "km/h" }
            ListElement { name: "mph" }
        }

        onAccepted: {
            var result;

            if (recordLastDialog.selectedIndex == 0) {
                result = true;
                velocityUnitButton.text = "km/h";
            }
            else {
                result = false;
                velocityUnitButton.text = "mph";
            }

            settingsObject.setVelocityUnit(result);
        }
    }
}
