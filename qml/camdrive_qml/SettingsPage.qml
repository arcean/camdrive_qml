import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    id: settingsPage
    orientationLock: PageOrientation.LockLandscape

    Component.onCompleted: {
        theme.inverted = true
       // theme.color = 8
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
            platformStyle: SwitchStyle {
                switchOn: "image://theme/" + "color11-" + "meegotouch-switch-on"+__invertedString
            }
            onCheckedChanged: {
                storeLastButton.enabled = !checked
                storeLastLabel.enabled = !checked
            }
        }

        Label {
            id:storeLastLabel
            x: 10
            y: continousRecordingLabel.y + 60
            text: "Store last"
        }

        Button {
            id: storeLastButton
            x: 630
            y: storeLastLabel.y
            width: 194
            text: {
                recordLastDialog.selectedIndex >= 0 ? recordLastDialog.model.get(recordLastDialog.selectedIndex).name : "5 minutes"
            }

            platformStyle: ButtonStyle {
                pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
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
            Button { text: "VGA"
                id: videoVGA
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
            Button { text: "DVD"
                id: videoDVD
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
            Button { text: "HD"
                id: videoHD
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
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
            Button { text: "Low"
                id: videoLow
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
            Button { text: "Normal"
                id: videoNormal
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
            Button { text: "High"
                id: videoHigh
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
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
            checked: true
            platformStyle: SwitchStyle {
                switchOn: "image://theme/" + "color11-" + "meegotouch-switch-on"+__invertedString
            }
            onCheckedChanged: {
                audioQualityButtonRow.enabled = checked
                audioQualityLabel.enabled = checked
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
            checkedButton: audioNormal
            Button { text: "Low"
                id: audioLow
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
            Button { text: "Normal"
                id: audioNormal
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
            Button { text: "High"
                id: audioHigh
                platformStyle: ButtonStyle {
                    pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
                    checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                    checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                }
            }
        }
    }

    SelectionDialog {
        id: recordLastDialog
        titleText: "Record last"

        model: ListModel {
            ListElement { name: "1 minute " }
            ListElement { name: "3 minutes " }
            ListElement { name: "5 minutes " }
            ListElement { name: "10 minutes " }
            ListElement { name: "15 minutes " }
            ListElement { name: "30 minutes " }
        }
    }

}
