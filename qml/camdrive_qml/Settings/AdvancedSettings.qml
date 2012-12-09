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
        title: "Advanced settings"
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

        LabelSeparator {
            id: separator1Label
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

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

        LabelSeparator {
            id: separator2Label
            anchors.top: clearDatabaseButton.bottom
            anchors.right: parent.right
            anchors.left: parent.left

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
