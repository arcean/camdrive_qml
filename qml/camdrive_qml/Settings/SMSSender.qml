import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import QtMobility.systeminfo 1.2
import Telephony 1.0

//! Page for creating and sending SMS
Page {
    id: smssendingPage
    orientationLock: PageOrientation.LockPortrait

    //! Variables accessed by the Addressbook.qml
    property string addressBookPhoneNumber: ""
    property alias addressBookContactName: smssenderInfoID.contactsInputText
    property bool addressBookContactSelected: false
    property alias smsSheet: sheet
    property bool contactsAvailable: false

    //! Variable to check for QmessageService instance.
    property bool qMessageServieInstance: false

    //! Variable to check for sim status.
    property alias simPresent: deviceInfo.simStatus

    //! Function to open the new page
    function openFile(file)
    {
        var component = Qt.createComponent(file);
        contactsAvailable = myTelephony.isContactsAvailable(false);

        if (component.status === Component.Ready) {
            //! After closing the sheet only newly pushed component will be shown
            sheet.close();

            //! Push the newly created component
            pageStack.push(component);
        }
    }

    //! Function to validate if the phone number contains any strings
    function phoneNumberValidator(phoneNumber)
    {
        // check for invalid charaters in  phone number
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
            //! Show busy indicator.
            smssenderInfoID.spinner.running = true;
            smssenderInfoID.spinner.opacity = 1.0;

            //! Initialize message service if not already active.
            if (qMessageServieInstance === false) {
                myTelephony.initialiseMessageService();
                qMessageServieInstance = true;
            }

        //! Send SMS message.
        myTelephony.msgSent = myTelephony.sendSMS(number, smssenderInfoID.messageText.text);

        //! Stop busy indicator.
        smssenderInfoID.spinner.opacity = 0.0;
        smssenderInfoID.spinner.running = false;
        } else {
            //! If no SIM then display a error message.
            smssenderInfoID.infobanner.text = "No Active Sim";
            smssenderInfoID.infobanner.show();
        }
    }

    //! Function to process the logic once the "SEND" button is clicked
    function sendButtonClicked()
    {
        //! Set focus from message text so text is commited from predictive text engine.
        sheet.acceptButton.forceActiveFocus();

        //! Check if Flight mode is on
        if (myTelephony.deviceMode === "Flight mode") {
            smssenderInfoID.infobanner.text = "No mobile network available"
        }
        //! Check for valid contact and message text present.
        else if (smssenderInfoID.contactsInput.text.length === 0) {
            //! checking if phone number is entered.
            smssenderInfoID.infobanner.text = "Enter number before sending";

            //! Set focus to contacts input.
            smssenderInfoID.contactsInput.forceActiveFocus();
        } else if (smssenderInfoID.messageText.text.length === 0) {
            //! checking for either message text is entered.
            smssenderInfoID.infobanner.text = "Enter message before sending";

            //! Set focus to message text.
            smssenderInfoID.messageText.forceActiveFocus();
        }
        //! Validate manually entered phone number to check if any invalid characters are present
        //! using phoneNumberValidator.
        else if (addressBookPhoneNumber === ""
                 && phoneNumberValidator(smssenderInfoID.contactsInput.text) === false) {
            smssenderInfoID.infobanner.text = "Invalid PhoneNumber";
            smssenderInfoID.contactsInput.forceActiveFocus();
        } else {
            // Set focus to item
            if (smssenderInfoID.focusedElement === "text") {
                smssenderInfoID.messageText.forceActiveFocus();
                smssenderInfoID.messageText.closeSoftwareInputPanel();
            } else if (smssenderInfoID.focusedElement === "number") {
                smssenderInfoID.contactsInput.forceActiveFocus();
                smssenderInfoID.contactsInput.closeSoftwareInputPanel();
            }

            // Disable required components.
            smssenderInfoID.messageText.enabled = false;
            sheet.acceptButton.enabled = false;
            smssenderInfoID.contactsInput.enabled = false;
            smssenderInfoID.addButton.enabled = false;

            //! Send SMS based on the phone number of contacts selected.
            if (addressBookPhoneNumber === "") {
                //! Send SMS to number.
                sendSMS(smssenderInfoID.contactsInput.text);
            } else {
                //! PhoneNumber From AddressBook
                sendSMS(addressBookPhoneNumber);
            }

            //! Check if SMS was submitted successfully.
            if (Telephony.msgSent === true) {
                //! Reset display message to wipe out message buffer.
                smssenderInfoID.infobanner.text = "";

                //! Set message text to disbaled color.
                smssenderInfoID.messageText.color = "#b2b2b4"

                //! Set accept button text as sent.
                sheet.acceptButtonText = "Sent";
            } else {
                //! Set display message.
                smssenderInfoID.infobanner.text = "Error sending SMS.";

                //! Reenable required components to try sending again.
                sheet.acceptButton.enabled = true;
                smssenderInfoID.messageText.enabled = true;

                //! Reenable required components.
                smssenderInfoID.messageText.forceActiveFocus();
                smssenderInfoID.contactsInput.enabled = true;
                smssenderInfoID.addButton.enabled = true;
                smssenderInfoID.messageText.openSoftwareInputPanel();
            }

            //! Set focus to message.
            smssenderInfoID.messageText.forceActiveFocus();
        }

        //! Display message.
        if ( smssenderInfoID.infobanner.text.length > 0 ) {
            smssenderInfoID.infobanner.show();
        }
    }

    //! Function to process the logic once cancel button is clicked
    function cancelButtonClicked()
    {
        //! Closing the VKB
        if (smssenderInfoID.focusedElement === "text") {
            smssenderInfoID.messageText.forceActiveFocus();
            smssenderInfoID.messageText.closeSoftwareInputPanel();
        } else if (smssenderInfoID.focusedElement === "number") {
            smssenderInfoID.contactsInput.forceActiveFocus();
            smssenderInfoID.contactsInput.closeSoftwareInputPanel();
        }

        // Pop page stack.
        pageStack.pop();
    }

    Component.onCompleted: {
        //! After paging is loaded, open the sheet
        sheet.open();
    }

    Sheet {
        id: sheet
        acceptButtonText: "Send"
        rejectButtonText: "Cancel"
        anchors.fill: parent

        content: SMSSenderInfo { id: smssenderInfoID }

        onAccepted: {
            //! By default Accept button closes the sheet. Here opening the sheet again.
            sheet.open();

            //! Send button functionality implemented in sendButtonClicked() method
            sendButtonClicked();
        }

        onRejected: {
            //! Cancel button functionality implemented in cancelButtonClicked() method
            cancelButtonClicked();
        }
    }

    //! Custom defined Class component for sending message
    Telephony {
        id: myTelephony
        property bool msgSent

        //! When the state changes set all properties to false.
        onStateChanged: {
            smssenderInfoID.messageText.enabled = false;
            smssenderInfoID.contactsInput.enabled = false;
            smssenderInfoID.addButton.enabled = false;
        }
    }

    //! QML DeviceInfo elmenent for retrieving device information
    DeviceInfo {
        id: deviceInfo
    }
}

//! End of File
