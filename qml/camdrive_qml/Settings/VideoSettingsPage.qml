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

        LabelSeparator {
            id: videoResolutionLabel
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top

            text: "Resolution"
        }

        ButtonColumn {
            id: videoResolutionButtonColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: videoResolutionLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH

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
            anchors.top: videoResolutionLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH

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

        LabelSeparator {
            id: videoQualityLabel
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: _IN_PORTRAIT ? videoResolutionButtonColumn.bottom :
                                videoResolutionButtonRow.bottom
            anchors.topMargin: _MARGIN_SWITCH

            text: "Quality"
        }

        ButtonColumn {
            id: videoQualityButtonColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: videoQualityLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH

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
            anchors.top: videoQualityLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH

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
