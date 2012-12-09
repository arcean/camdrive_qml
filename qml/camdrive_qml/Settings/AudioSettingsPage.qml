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
        if(settingsObject.getAudioQuality() == 0) {
            audioQualityButtonRow.checkedButton = audioLow
            audioQualityButtonColumn.checkedButton = audioLowColumn
        }
        else if(settingsObject.getAudioQuality() == 2) {
            audioQualityButtonRow.checkedButton = audioHigh
            audioQualityButtonColumn.checkedButton = audioHighColumn
        }
        else {
            audioQualityButtonRow.checkedButton = audioNormal
            audioQualityButtonColumn.checkedButton = audioNormalColumn
        }
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
        title: "Audio settings"
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
        contentHeight: _IN_PORTRAIT ? audioQualityButtonColumn.y + audioQualityButtonColumn.height - generalLabel.y :
                                      audioQualityButtonRow.y + audioQualityButtonRow.height - generalLabel.y

        LabelSeparator {
            id: generalLabel
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left

            text: "General"
        }

        Label {
            id: audioSwitchLabel
            anchors.left: parent.left
            text: "Record audio"
            y: generalLabel.y + generalLabel.height + 10
        }

        Switch {
            id: audioSwitch
            anchors.right: parent.right
            anchors.verticalCenter: audioSwitchLabel.verticalCenter

            checked: settingsObject.getEnableAudio()
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                audioQualityButtonRow.enabled = checked
                //audioQualityLabel.enabled = checked
                settingsObject.setEnableAudio(checked)
            }
        }

        LabelSeparator {
            id: qualityLabel
            anchors.top: audioSwitchLabel.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Quality"
        }

     /*   Label {
            id: audioQualityLabel
            anchors.left: parent.left
            y: qualityLabel.y + qualityLabel.height + 20
            text: "Audio quality:"
        }*/

        ButtonColumn {
            id: audioQualityButtonColumn
            anchors.left: parent.left
            anchors.right: parent.right
            y: qualityLabel.y + qualityLabel.height + 10

            enabled: audioSwitch.checked
            platformStyle: StyledButton {}
            visible: _IN_PORTRAIT

            Button { text: "Low"
                id: audioLowColumn
                onClicked: settingsObject.setAudioQuality(0)
            }
            Button { text: "Normal"
                id: audioNormalColumn
                onClicked: settingsObject.setAudioQuality(1)
            }
            Button { text: "High"
                id: audioHighColumn
                onClicked: settingsObject.setAudioQuality(2)
            }
        }

        ButtonRow {
            id: audioQualityButtonRow
            anchors.left: parent.left
            anchors.right: parent.right
            y: qualityLabel.y + qualityLabel.height + 10

            enabled: audioSwitch.checked
            platformStyle: StyledButton {}
            visible: !_IN_PORTRAIT

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
