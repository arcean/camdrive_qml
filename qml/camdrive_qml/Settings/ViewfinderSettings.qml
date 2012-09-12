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
        text: "Viewfinder settings"
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

        Label {
            id: generalLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Additional buttons"
        }

        Separator {
            anchors.right: generalLabel.left
            anchors.left: parent.left
            anchors.rightMargin: 20
            anchors.verticalCenter: generalLabel.verticalCenter
        }

        Label {
            id: nightModeButtonLabel
            anchors.left: parent.left
            anchors.top: generalLabel.bottom
            anchors.topMargin: 10
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
            anchors.topMargin: 16
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
