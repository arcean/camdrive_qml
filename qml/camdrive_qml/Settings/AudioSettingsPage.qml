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
        contentHeight: _IN_PORTRAIT ? audioQualityButtonColumn.y + audioQualityButtonColumn.height - generalLabel.y :
                                      audioQualityButtonRow.y + audioQualityButtonRow.height - generalLabel.y

        Label {
            id: generalLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "General"
        }

        Separator {
            anchors.right: generalLabel.left
            anchors.left: parent.left
            anchors.rightMargin: 20
            anchors.verticalCenter: generalLabel.verticalCenter
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

        Label {
            id: qualityLabel
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: audioSwitchLabel.y + audioSwitchLabel.height + 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Quality"
        }

        Separator {
            anchors.right: qualityLabel.left
            anchors.left: parent.left
            anchors.rightMargin: 20
            anchors.verticalCenter: qualityLabel.verticalCenter
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
