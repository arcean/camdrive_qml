import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.1
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

    Connections {
        target: Utils
        onInformation: messageHandler.showMessage(message);
    }

    Component.onCompleted: {
    }

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Advanced settings"
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
        contentHeight: deleteVideosButton.y + deleteVideosButton.height - separator1Label.y

        Separator {
            anchors.left: parent.left
            anchors.right: separator1Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator1Label.verticalCenter
        }
        Label {
            id: separator1Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Database"
        }

        Button {
            id: clearDatabaseButton
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: separator1Label.bottom
            anchors.margins: 10
            platformStyle: StyledButton {}

            text: "Clear database"
            onClicked: clearDatabaseDialog.open();
        }

        Separator {
            anchors.left: parent.left
            anchors.right: separator2Label.left
            anchors.rightMargin: 20
            anchors.verticalCenter: separator2Label.verticalCenter
        }
        Label {
            id: separator2Label
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: clearDatabaseButton.bottom
            anchors.topMargin: 10
            font.pixelSize: _SMALL_FONT_SIZE
            color: _DISABLED_COLOR_TEXT
            text: "Video files"
        }

        Button {
            id: deleteVideosButton
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: separator2Label.bottom
            anchors.margins: 10
            platformStyle: StyledButton {}

            text: "Delete all video files"
            onClicked: deleteVideosDialog.open();
        }

    }

    QueryDialog {
        id: deleteVideosDialog
        icon: "../images/dialog-question.png"
        titleText: "Delete all video files"
        message: "Are you sure that you want to delete all video files?"

        acceptButtonText: "Delete"
        rejectButtonText: "Reject"

        onAccepted: {
            Utils.deleteVideos();
        }
    }

    QueryDialog {
        id: clearDatabaseDialog
        icon: "../images/dialog-question.png"
        titleText: "Clear database"
        message: "Are you sure that you want to clear the video database?"

        acceptButtonText: "Clear"
        rejectButtonText: "Reject"

        onAccepted: {
            Utils.deleteDatabase();
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
