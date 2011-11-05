import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import Settings 1.0

Page {
    tools: commonTools
    id: settingsPage
    orientationLock: PageOrientation.LockLandscape

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

    function selectVideoQuality()
    {
        if(settingsObject.getVideoQuality() == 0)
            videoQualityButtonRow.checkedButton = videoLow
        else if(settingsObject.getVideoQuality() == 2)
            videoQualityButtonRow.checkedButton = videoHigh
        else
            videoQualityButtonRow.checkedButton = videoNormal
    }

    function selectVideoResolution()
    {
        if(settingsObject.getVideoResolution() == 0)
            videoResolutionButtonRow.checkedButton = videoVGA
        else if(settingsObject.getVideoResolution() == 2)
            videoResolutionButtonRow.checkedButton = videoHD
        else
            videoResolutionButtonRow.checkedButton = videoDVD
    }

    Component.onCompleted: {
        theme.inverted = true
       // theme.color = 8
        storeLastButton.text = settingsObject.getStoreLastToText()
        recordingOptionsSwitch.checked = settingsObject.getEnableContinousRecording()
        selectAudioQuality()
        selectVideoQuality()
        selectVideoResolution()
    }

    Flickable {
        anchors.fill: parent
        contentHeight: 600

        Separator {
            id: recordingOptionsSeparator
            x: 5
            y: 10
            width: 640
        }

        Label {
            id: recordingOptionsLabel
            x: 660
            y: recordingOptionsSeparator.y - 10
            platformStyle: LabelStyle {
                textColor: "gray"
                fontPixelSize: 20
            }
            text: "Recording options"
        }

        Label {
            id: continousRecordingLabel
            x: 10
            y: recordingOptionsSeparator.y + 20
            text: "Enable continous recording"
        }

        Switch {
            id: recordingOptionsSwitch
            x: 758
            y: continousRecordingLabel.y
            checked: false
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                storeLastButton.enabled = !checked
                storeLastLabel.enabled = !checked
                settingsObject.setEnableContinousRecording(checked)
            }
        }

        Label {
            id:storeLastLabel
            x: 10
            y: continousRecordingLabel.y + 60
            text: "Store last"
        }

        TumblerButton {
            id: storeLastButton
            x: 580
            y: storeLastLabel.y
            width: 244
            style: StyledTumblerButton {}
            text: {
                recordLastDialog.selectedIndex >= 0 ? recordLastDialog.model.get(recordLastDialog.selectedIndex).name : "5 minutes"
            }
            onClicked: {
                recordLastDialog.open()
            }
        }

        Separator {
            id: videoSettingsSeparator
            x: 5
            y: storeLastLabel.y + 70
            width: 680
        }

        Label {
            id: videoSettingsLabel
            x: 700
            y: videoSettingsSeparator.y - 10
            platformStyle: LabelStyle {
                textColor: "gray"
                fontPixelSize: 20
            }
            text: "Video settings"
        }

        Label {
            id: videoResolutionLabel
            x: 10
            y: videoSettingsSeparator.y + 20
            text: "Video resolution:"
        }

        ButtonRow {
            id: videoResolutionButtonRow
            x: 30
            width: parent.width - 60
            y: videoResolutionLabel.y + 40
            checkedButton: videoDVD
            platformStyle: StyledButton {}
            Button { text: "VGA"
                id: videoVGA
                onClicked: settingsObject.setVideoResolution(0)
            }
            Button { text: "DVD"
                id: videoDVD
                onClicked: settingsObject.setVideoResolution(1)
            }
            Button { text: "HD"
                id: videoHD
                onClicked: settingsObject.setVideoResolution(2)
            }
        }

        Label {
            id: videoQualityLabel
            x: 10
            y: videoResolutionButtonRow.y + 70
            text: "Video quality:"
        }

        ButtonRow {
            id: videoQualityButtonRow
            x: 30
            width: parent.width - 60
            y: videoQualityLabel.y + 40
            checkedButton: videoNormal
            platformStyle: StyledButton {}
            Button { text: "Low"
                id: videoLow
                onClicked: settingsObject.setVideoQuality(0)
            }
            Button { text: "Normal"
                id: videoNormal
                onClicked: settingsObject.setVideoQuality(1)
            }
            Button { text: "High"
                id: videoHigh
                onClicked: settingsObject.setVideoQuality(2)
            }
        }

        Separator {
            id: audioSettingsSeparator
            x: 5
            y: videoQualityButtonRow.y + 80
            width: 680
        }

        Label {
            x: 700
            y: audioSettingsSeparator.y - 10
            platformStyle: LabelStyle {
                textColor: "gray"
                fontPixelSize: 20
            }

            text: "Audio settings"
        }

        Label {
            id: audioSwitchLabel
            x: 10
            y: audioSettingsSeparator.y + 20
            text: "Record audio:"
        }

        Switch {
            id: audioSwitch
            x: 758
            y: audioSwitchLabel.y
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
            x: 10
            y: audioSwitchLabel.y + 40
            text: "Audio quality:"
        }

        ButtonRow {
            id: audioQualityButtonRow
            x: 30
            width: parent.width - 60
            y: audioQualityLabel.y + 40
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

    SelectionDialog {
        id: recordLastDialog
        titleText: "Store last"
        selectedIndex: settingsObject.getStoreLast()
        platformStyle: StyledSelectionDialog {}

        model: ListModel {
            ListElement { name: "1 minute " }
            ListElement { name: "3 minutes " }
            ListElement { name: "5 minutes " }
            ListElement { name: "10 minutes " }
            ListElement { name: "15 minutes " }
            ListElement { name: "30 minutes " }
        }

        onAccepted: {
            settingsObject.setStoreLast(recordLastDialog.selectedIndex)
            storeLastButton.text = settingsObject.getStoreLastToText()
        }
    }
}
