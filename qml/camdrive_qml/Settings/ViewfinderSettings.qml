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

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        title: "Viewfinder settings"
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
        contentHeight: emergencyButtonLabel.y + emergencyButtonLabel.height - generalLabel.y

        LabelSeparator {
            id: generalLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.left: parent.left

            text: "Additional buttons"
        }

        Label {
            id: nightModeButtonLabel
            anchors.left: parent.left
            anchors.top: generalLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH
            text: "Show night mode button"
        }

        Switch {
            id: nightModeButtonSwitch
            anchors.right: parent.right
            anchors.verticalCenter: nightModeButtonLabel.verticalCenter

            checked: settingsObject.getShowNightModeButton()
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                settingsObject.setShowNightModeButton(checked)
            }
        }

        Label {
            id: emergencyButtonLabel
            anchors.left: parent.left
            anchors.top: nightModeButtonLabel.bottom
            anchors.topMargin: _MARGIN_SWITCH
            text: "Show emergency button"
        }

        Switch {
            id: emergencyButtonSwitch
            anchors.right: parent.right
            anchors.verticalCenter: emergencyButtonLabel.verticalCenter

            checked: settingsObject.getShowEmergencyButton()
            platformStyle: StyledSwitch {}
            onCheckedChanged: {
                settingsObject.setShowEmergencyButton(checked)
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
