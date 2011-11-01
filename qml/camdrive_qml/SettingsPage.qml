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
            id: videoSettingsSeparator
            x: 5
            y: 10
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
            x: 5
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
            x: 5
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
            y: 270
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
            x: 5
            y: audioSettingsSeparator.y + 20
            text: "Record audio:"
        }

        Switch {
            id: audioSwitch
            x: 780
            y: audioSwitchLabel.y
            checked: true
            platformStyle: SwitchStyle {
                switchOn: "image://theme/" + "color11-" + "meegotouch-switch-on"+__invertedString
            }
            onCheckedChanged: {
                audioQualityButtonRow.enabled = checked
            }
        }

        Label {
            id: audioQualityLabel
            x: 5
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

}
