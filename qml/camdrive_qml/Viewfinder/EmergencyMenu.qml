// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../Common"

Item {
    id: master
    width: 660
    height: 4 + title.height + 4 + backButton.height + 4 + backLabel.height + 24
    property bool collision: false

    Rectangle {
        id: rect1
        anchors.fill: parent

        color: "black"
        opacity: 0.5
        radius: 50
        smooth: true
    }

    Rectangle {
        id: rect2
        anchors.fill: rect1
        anchors.margins: 4

        color: "black"
        opacity: 0.6
        radius: 50
        smooth: true
    }

    Label {
        id: title
        anchors { top: rect2.top; horizontalCenter: rect2.horizontalCenter; topMargin: 4; }
        text: collision ? "Collision detected!" : "Emergency menu"
        font.pixelSize: _LARGE_FONT_SIZE
        color: "red"
        font.bold: true
    }

    ButtonHighlight {
        id: backButton
        anchors { top: title.bottom; left: rect2.left; topMargin: 4; leftMargin: 42; }
        width: 120
        height: width

        source: "../images/arrow.png"
        highlightSource: "../images/highlight120.png"

        onClicked: {
            viewfinderPage.closeMenuFunc();
        }
    }

    Label {
        id: backLabel
        anchors { top: backButton.bottom; topMargin: 4; horizontalCenter: backButton.horizontalCenter; }
        text: "Back to viewfinder"
        font.pixelSize: _SMALL_FONT_SIZE
        color: _TEXT_COLOR
    }

    ButtonHighlight {
        id: smsButton
        anchors { top: title.bottom; topMargin: 4; horizontalCenter: rect2.horizontalCenter; }
        width: 120
        height: width

        source: "../images/sms.png"
        highlightSource: "../images/highlight120.png"
        onClicked: {
            smsDialog.open();
        }
    }

    Label {
        id: smsLabel
        anchors { top: smsButton.bottom; topMargin: 4; horizontalCenter: smsButton.horizontalCenter; }
        text: "Send SMS to your friend"
        font.pixelSize: _SMALL_FONT_SIZE
        color: _TEXT_COLOR
    }

    ButtonHighlight {
        id: emergencyCallButton
        anchors { top: title.bottom; topMargin: 4; right: rect2.right; rightMargin: 42; }
        width: 120
        height: width

        source: "../images/call-emergency.png"
        highlightSource: "../images/highlight120.png"
        onClicked: {
            emergencyCallDialog.open();
        }
    }

    Label {
        id: emergencyCallLabel
        anchors { top: emergencyCallButton.bottom; topMargin: 4; horizontalCenter: emergencyCallButton.horizontalCenter; }
        text: "Call emergency number"
        font.pixelSize: _SMALL_FONT_SIZE
        color: _TEXT_COLOR
    }

    QueryDialog {
        id: smsDialog
        icon: "../images/sms.png"
        titleText: "Send SMS"
        message: "Are you sure that you want to send SMS to your friend?"

        acceptButtonText: "Send"
        rejectButtonText: "Reject"

        onAccepted: {

        }
    }

    QueryDialog {
        id: emergencyCallDialog
        icon: "../images/call-emergency.png"
        titleText: "Call emergency number"
        message: "Are you sure that you want to call the emergency number?"

        acceptButtonText: "Call"
        rejectButtonText: "Reject"

        onAccepted: {

        }
    }
}
