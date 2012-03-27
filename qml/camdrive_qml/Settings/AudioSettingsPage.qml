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

    function selectAudioQuality()
    {
        if(settingsObject.getAudioQuality() == 0)
            audioQualityButtonRow.checkedButton = audioLow
        else if(settingsObject.getAudioQuality() == 2)
            audioQualityButtonRow.checkedButton = audioHigh
        else
            audioQualityButtonRow.checkedButton = audioNormal
    }

    Component.onCompleted: {
        selectAudioQuality();
    }

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Audio settings"
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
        contentHeight: audioQualityButtonRow.y + audioQualityButtonRow.height - audioSwitchLabel.y

        Label {
            id: audioSwitchLabel
            anchors.left: parent.left
            text: "Record audio:"
        }

        Switch {
            id: audioSwitch
            anchors.right: parent.right
            anchors.verticalCenter: audioSwitchLabel.verticalCenter

            checked: settingsObject.getEnableAudio()
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                audioQualityButtonRow.enabled = checked
                audioQualityLabel.enabled = checked
                settingsObject.setEnableAudio(checked)
            }
        }

        Label {
            id: audioQualityLabel
            anchors.left: parent.left
            y: audioSwitchLabel.y + audioSwitchLabel.height + 20
            text: "Audio quality:"
        }

        ButtonRow {
            id: audioQualityButtonRow
            anchors.left: parent.left
            anchors.right: parent.right

            y: audioQualityLabel.y + audioQualityLabel.height + 20

            enabled: audioSwitch.checked
            //checkedButton:
            platformStyle: StyledButton {}
            Button { text: "Low"
                id: audioLow
                onClicked: settingsObject.setAudioQuality(0)
            }
            Button { text: "Normal"
                id: audioNormal
                onClicked: settingsObject.setAudioQuality(1)
            }
            Button { text: "High"
                id: audioHigh
                onClicked: settingsObject.setAudioQuality(2)
            }
        }


    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
