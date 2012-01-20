import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import Settings 1.0

Page {
    tools: commonTools
    id: settingsPage
    //orientationLock: PageOrientation.LockLandscape

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

    function enableContinousRecording(checked)
    {
        storeLastButton.enabled = !checked
        storeLastLabel.enabled = !checked
        settingsObject.setEnableContinousRecording(checked)
    }

    function setTextStoreLastInfoLabel()
    {
        var temp = settingsObject.getStoreLastInMinutes();

        if (temp == 1)
            storeLastInfoLabel.text = "Recorded video will be stored in one part.";
        else
            storeLastInfoLabel.text = "Recorded video will be dividied into " + temp + " parts.";
    }

    Component.onCompleted: {
        theme.inverted = true;
        storeLastButton.text = settingsObject.getStoreLastToText();
        recordingOptionsSwitch.checked = settingsObject.getEnableContinousRecording();
        selectAudioQuality();
        selectVideoQuality();
        selectVideoResolution();
        setTextStoreLastInfoLabel();
    }

    Flickable {
        anchors.fill: parent
        contentHeight: (parent.height > audioQualityButtonRow.y + audioQualityButtonRow.height) ? (parent.height + 1) : (audioQualityButtonRow.y + audioQualityButtonRow.height)

        Label {
            id: recordingOptionsLabel
            anchors.left: parent.left
            y: 10
            platformStyle: LabelStyle {
                textColor: "gray"
                fontPixelSize: 20
            }
            text: "Recording options  "
        }

        Separator {
            id: recordingOptionsSeparator
            anchors.left: recordingOptionsLabel.right
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: recordingOptionsLabel.y + 10
        }

        Label {
            id: continousRecordingLabel
            anchors.leftMargin: 10
            anchors.left: parent.left
            y: recordingOptionsLabel.y + recordingOptionsLabel.height + 20
            text: "Enable continous recording"
        }

        Switch {
            id: recordingOptionsSwitch
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: continousRecordingLabel.y - 8
            checked: false
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                enableContinousRecording(checked)
            }
        }

        Label {
            id:storeLastLabel
            anchors.leftMargin: 10
            anchors.left: parent.left
            y: continousRecordingLabel.y + continousRecordingLabel.height + 20
            color: recordingOptionsSwitch.checked ? "gray" : "white"
            text: "Store last:"
        }

        TumblerButton {
            id: storeLastButton
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.leftMargin: 10
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

        Label {
            id:storeLastInfoLabel
            anchors.leftMargin: 10
            anchors.left: parent.left
            y: storeLastButton.y + storeLastButton.height + 20
            color: recordingOptionsSwitch.checked ? "gray" : "white"
            font.pixelSize: appWindow._SMALL_FONT_SIZE
        }

        Label {
            id: videoSettingsLabel
            anchors.left: parent.left
            y: storeLastInfoLabel.y + storeLastInfoLabel.height + 20
            platformStyle: LabelStyle {
                textColor: "gray"
                fontPixelSize: 20
            }
            text: "Video settings"
        }

        Separator {
            id: videoSettingsSeparator
            anchors.left: videoSettingsLabel.right
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: videoSettingsLabel.y + 10
        }

        Label {
            id: videoResolutionLabel
            x: 10
            y: videoSettingsLabel.y + videoSettingsLabel.height + 20
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
            y: videoResolutionButtonRow.y + videoResolutionButtonRow.height + 20
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
            anchors.left: audioSettingsLabel.right
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: audioSettingsLabel.y + 10
            width: 680
        }

        Label {
            id: audioSettingsLabel
            x: 10
            y: videoQualityButtonRow.y + videoQualityButtonRow.height + 20
            platformStyle: LabelStyle {
                textColor: "gray"
                fontPixelSize: 20
            }
            text: "Audio settings"
        }

        Label {
            id: audioSwitchLabel
            x: 10
            y: audioSettingsLabel.y + audioSettingsLabel.height + 20
            text: "Record audio:"
        }

        Switch {
            id: audioSwitch
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: audioSwitchLabel.y - 8
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
            y: audioSwitchLabel.y + audioSwitchLabel.height + 20
            text: "Audio quality:"
        }

        ButtonRow {
            id: audioQualityButtonRow
            x: 30
            width: parent.width - 60
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
            setTextStoreLastInfoLabel()
        }
    }
}
