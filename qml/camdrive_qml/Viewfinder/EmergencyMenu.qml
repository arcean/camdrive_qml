// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import Settings 1.0
import Telephony 1.0
import QtMobility.systeminfo 1.2
import "../Common"

Item {
    id: master
    width: 660
    height: 4 + title.height + 4 + backButton.height + 4 + backLabel.height + 24
    property bool collision: false

    property bool qMessageServieInstance: false
    //! Variable to check for sim status.
    property alias simPresent: deviceInfo.simStatus

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

    Settings {
        id: settingsObject
    }

    Telephony {
        id: telephony
    }

    DeviceInfo {
        id: deviceInfo
    }

    QueryDialog {
        id: smsDialog
        icon: "../images/sms.png"
        titleText: "Send SMS"
        message: "Are you sure that you want to send SMS to your friend?"

        acceptButtonText: "Send"
        rejectButtonText: "Reject"

        onAccepted: {
            if (settingsObject.getEmergencyContactNameEnabled())
                sendButtonClicked();
            else
                messageHandler.showMessage(qsTr("Feature disabled. Please check Settings."));
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
            if (settingsObject.getEmergencyNumberEnabled())
                telephony.call(settingsObject.getEmergencyNumber());
            else
                messageHandler.showMessage(qsTr("Feature disabled. Please check Settings."));
        }
    }

    //! Function for Telephony module

    //! Function to validate if the phone number contains any strings
    function phoneNumberValidator(phoneNumber)
    {
        // check for invalid charaters in phone number
        if ((/[a-zA-Z#*]/.test(phoneNumber) === true))
            return false;

        //! Check for valid usage of + in phone number
        if (/[+]/.test(phoneNumber) === true) {
            //! Check if + is only preceeding the number
            if (phoneNumber[0] === "+")
                phoneNumber = phoneNumber.replace("+","0")

            // Check for any unwated + in phone number
            if (/[+]/.test(phoneNumber) === true)
                return false;
        }

        //! Phone number is valid
        return true;
    }

    //! Function sendSms, which internally calls QT member function.
    function sendSMS(number)
    {
        //! Initialize message service if sim is present.
        if (simPresent) {
            //! Initialize message service if not already active.
            if (qMessageServieInstance === false) {
                telephony.initialiseMessageService();
                qMessageServieInstance = true;
            }
        //! Send SMS message.
            var ret = telephony.sendSMS(number, "dd\nprobe");

            if (ret)
                messageHandler.showMessage(qsTr("Message was sent successfully"));
            else
                messageHandler.showMessage(qsTr("Message was not sent"));

        } else {
            //! If no SIM then display a error message.
            messageHandler.showMessage(qsTr("No Active Sim"));
        }
    }

    function sendButtonClicked()
    {
        var phoneNumber = settingsObject.getEmergencyContactNumber();
        var message = settingsObject.getContactTextMessage();
        var contactName = settingsObject.getEmergencyContactName();

        if (phoneNumber.length === 0 && contactName.length > 0) {
            //! Phone number typed directly in SelectContact Item.
            phoneNumber = contactName;
        }

        //! Check if Flight mode is on
        if (telephony.deviceMode === "Flight mode") {
            messageHandler.showMessage(qsTr("No mobile network available"));
        }
        //! Check for valid contact and message text present.
        else if (phoneNumber.length === 0) {
            //! checking if phone number is defined.
            messageHandler.showMessage(qsTr("No phone number defined"));
        } else if (message.length === 0) {
            //! checking for either message text is defined.
            messageHandler.showMessage(qsTr("No message defined"));
        }
        //! Validate manually entered phone number to check if any invalid characters are present
        //! using phoneNumberValidator.
        else if (phoneNumber === ""
                 && phoneNumberValidator(phoneNumber) === false) {
            messageHandler.showMessage(qsTr("Invalid phone number"));
        } else {
            //! Send SMS based on the phone number of the selected contact.
            sendSMS(phoneNumber);
        }
    }

}
