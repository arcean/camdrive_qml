import QtQuick 1.0
import com.nokia.meego 1.0
import Settings 1.0
import "../"
import "../Common"

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
        theme.inverted = true;
        selectVideoQuality();
        selectVideoResolution();
    }

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Video settings"
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
        contentHeight: videoQualityButtonRow.y + videoQualityButtonRow.height - videoResolutionLabel.y

        Label {
            id: videoResolutionLabel
            anchors.left: parent.left
            text: "Video resolution:"
        }

        ButtonRow {
            id: videoResolutionButtonRow
            anchors.left: parent.left
            anchors.right: parent.right

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
            anchors.left: parent.left
            y: videoResolutionButtonRow.y + videoResolutionButtonRow.height + 20
            text: "Video quality:"
        }

        ButtonRow {
            id: videoQualityButtonRow
            anchors.left: parent.left
            anchors.right: parent.right

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
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
