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

    function enableContinousRecording(checked)
    {
        storeLastButton.enabled = !checked
        storeLastLabel.enabled = !checked
        settingsObject.setEnableContinousRecording(checked)
    }

    Component.onCompleted: {
        theme.inverted = true;
        storeLastButton.text = settingsObject.getStoreLastToText();
        recordingOptionsSwitch.checked = settingsObject.getEnableContinousRecording();
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
        contentHeight: storeLastButton.y + storeLastButton.height - continousRecordingLabel.y

        Label {
            id: continousRecordingLabel
            anchors.left: parent.left
            text: "Enable continous recording"
        }

        Switch {
            id: recordingOptionsSwitch
            anchors.right: parent.right
            anchors.verticalCenter: continousRecordingLabel.verticalCenter
            checked: false
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                enableContinousRecording(checked)
            }
        }

        Label {
            id:storeLastLabel
            anchors.left: parent.left
            y: continousRecordingLabel.y + continousRecordingLabel.height + 20
            color: recordingOptionsSwitch.checked ? "gray" : "white"
            text: "Store last:"
        }


        TumblerButton {
            id: storeLastButton
            anchors.right: parent.right
            anchors.left: parent.left
            y: storeLastLabel.y + storeLastLabel.height + 20
            style: StyledTumblerButton {}
            text: {
                recordLastDialog.selectedIndex >= 0 ? recordLastDialog.model.get(recordLastDialog.selectedIndex).name : "5 minutes"
            }
            onClicked: {
                recordLastDialog.open()
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }

    SelectionDialog {
        id: recordLastDialog
        titleText: "Store last"
        selectedIndex: settingsObject.getStoreLast()
        platformStyle: StyledSelectionDialog {}

        model: ListModel {
            ListElement { name: "3 minutes " }
            ListElement { name: "5 minutes " }
            ListElement { name: "10 minutes " }
            ListElement { name: "20 minutes " }
            ListElement { name: "30 minutes " }
        }

        onAccepted: {
            settingsObject.setStoreLast(recordLastDialog.selectedIndex)
            storeLastButton.text = settingsObject.getStoreLastToText()
            //setTextStoreLastInfoLabel()
        }
    }
}
