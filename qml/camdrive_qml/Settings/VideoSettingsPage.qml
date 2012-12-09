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

    function selectVideoQuality()
    {
        if(settingsObject.getVideoQuality() == 0) {
            videoQualityButtonRow.checkedButton = videoLow
            videoQualityButtonColumn.checkedButton = videoLowColumn
        }
        else if(settingsObject.getVideoQuality() == 2) {
            videoQualityButtonRow.checkedButton = videoHigh
            videoQualityButtonColumn.checkedButton = videoHighColumn
        }
        else {
            videoQualityButtonRow.checkedButton = videoNormal
            videoQualityButtonColumn.checkedButton = videoNormalColumn
        }
    }

    function selectVideoResolution()
    {
        if(settingsObject.getVideoResolution() == 0) {
            videoResolutionButtonRow.checkedButton = videoVGA
            videoResolutionButtonColumn.checkedButton = videoVGAColumn
        }
        else if(settingsObject.getVideoResolution() == 2) {
            videoResolutionButtonRow.checkedButton = videoHD
            videoResolutionButtonColumn.checkedButton = videoHDColumn
        }
        else {
            videoResolutionButtonRow.checkedButton = videoDVD
            videoResolutionButtonColumn.checkedButton = videoDVDColumn
        }
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
        title: "Video settings"
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
        contentHeight: _IN_PORTRAIT ? videoQualityButtonColumn.y + videoQualityButtonColumn.height - videoResolutionLabel.y :
                                      videoQualityButtonRow.y + videoQualityButtonRow.height - videoResolutionLabel.y

        Separator {
            anchors.left: parent.left
            anchors.right: videoResolutionLabel.left
            anchors.rightMargin: 20
            anchors.verticalCenter: videoResolutionLabel.verticalCenter
        }

        Label {
            id: videoResolutionLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            text: "Resolution"
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
        }

        ButtonColumn {
            id: videoResolutionButtonColumn
            anchors.left: parent.left
            anchors.right: parent.right
            y: videoResolutionLabel.y + videoResolutionLabel.height + 10

            checkedButton: videoDVD
            platformStyle: StyledButton {}
            visible: _IN_PORTRAIT

            Button { text: "VGA"
                id: videoVGAColumn
                onClicked: settingsObject.setVideoResolution(0)
            }
            Button { text: "DVD"
                id: videoDVDColumn
                onClicked: settingsObject.setVideoResolution(1)
            }
            Button { text: "HD"
                id: videoHDColumn
                onClicked: settingsObject.setVideoResolution(2)
            }
        }

        ButtonRow {
            id: videoResolutionButtonRow
            anchors.left: parent.left
            anchors.right: parent.right
            y: videoResolutionLabel.y + videoResolutionLabel.height + 10

            checkedButton: videoDVD
            platformStyle: StyledButton {}
            visible: !_IN_PORTRAIT

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

        Separator {
            anchors.left: parent.left
            anchors.right: videoQualityLabel.left
            anchors.rightMargin: 20
            anchors.verticalCenter: videoQualityLabel.verticalCenter
        }

        Label {
            id: videoQualityLabel
            anchors.right: parent.right
            anchors.rightMargin: 10
            y: _IN_PORTRAIT ? videoResolutionButtonColumn.y + videoResolutionButtonColumn.height + 10 :
                                videoResolutionButtonRow.y + videoResolutionButtonRow.height + 10
            text: "Quality"
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
        }

        ButtonColumn {
            id: videoQualityButtonColumn
            anchors.left: parent.left
            anchors.right: parent.right
            y: videoQualityLabel.y + videoQualityLabel.height + 10

            checkedButton: videoNormal
            platformStyle: StyledButton {}
            visible: _IN_PORTRAIT

            Button { text: "Low"
                id: videoLowColumn
                onClicked: settingsObject.setVideoQuality(0)
            }
            Button { text: "Normal"
                id: videoNormalColumn
                onClicked: settingsObject.setVideoQuality(1)
            }
            Button { text: "High"
                id: videoHighColumn
                onClicked: settingsObject.setVideoQuality(2)
            }
        }

        ButtonRow {
            id: videoQualityButtonRow
            anchors.left: parent.left
            anchors.right: parent.right
            y: videoQualityLabel.y + videoQualityLabel.height + 10

            checkedButton: videoNormal
            platformStyle: StyledButton {}
            visible: !_IN_PORTRAIT

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
