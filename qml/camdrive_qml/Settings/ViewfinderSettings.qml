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
        contentHeight: nightModeButtonLabel.y + nightModeButtonLabel.height - nightModeButtonLabel.y

        Label {
            id: nightModeButtonLabel
            anchors.left: parent.left
            text: "Show night mode button:"
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
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
