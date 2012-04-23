import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import Telephony 1.0
import Settings 1.0
import "../Common"
import "../StyledComponents"

Item {
    id: flickableContact
    property string addressBookPhoneNumber: ""
    property alias addressBookContactName: contactsInput.text
    property bool addressBookContactSelected: false
    property bool contactsAvailable: false
    height: contactsRect.height

    Settings {
        id: settingsObject
    }

    onAddressBookPhoneNumberChanged: {
        settingsObject.setEmergencyContactNumber(addressBookPhoneNumber);
    }

    onAddressBookContactNameChanged: {
        settingsObject.setEmergencyContactName(addressBookContactName);
    }

    Component.onCompleted: {
        //! Load settings
        addressBookContactName = settingsObject.getEmergencyContactName();
        addressBookPhoneNumber = settingsObject.getEmergencyContactNumber();
    }

    function openFile(file)
    {
        var component = Qt.createComponent(file);
        contactsAvailable = myTelephony.isContactsAvailable(false);

        if (component.status === Component.Ready) {
            //! After closing the sheet only newly pushed component will be shown
            //sheet.close();

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

    //! Rectangle component hosting Label "To", TextInput element ContactSelection/PhoneNumber
    //! and "+" AddButton
    Rectangle {
        id: contactsRect

        width: parent.width
        height: 72
        anchors.left: parent.left
        opacity: 0

    }  //!  end of contactsRect Rectangle

    //! Adding "TO" Label
    Label {
        id: toLabel
        anchors {
            left: contactsRect.left
            leftMargin: UiConstants.DefaultMargin
            verticalCenter: contactsRect.verticalCenter
        }

        font { family: UiConstants.BodyTextFont.family; weight: Font.Bold; pixelSize: 28 }
        text: "To:"
        color: _ACTIVE_COLOR_TEXT
    }

    //! TextInput for contact Selction and PhoneNumber addition
    TextInput {
        id: contactsInput
        width: 300
        anchors { left: toLabel.right; leftMargin: 10; verticalCenter: contactsRect.verticalCenter }
        font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 28 }
        horizontalAlignment: TextInput.AlignLeft
        color: _TEXT_COLOR
        inputMethodHints: Qt.ImhDialableCharactersOnly

        onActiveFocusChanged: {
            if (!contactsInput.focus) {
                contactsInput.closeSoftwareInputPanel();
            }
        }

        //! Basic Placeholder implementation.
        Text {
            id: contactsInputPlaceHolder
            anchors.fill: contactsRect.fill
            font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 28 }
            color: _TEXT_COLOR
            opacity: 0.65
            visible: (contactsInput.text === "") ? true : false;
            text: qsTr("Add Contact");
        }

        //! Used for one Shot clearing of Selected Contact on tabbing BackSpace.
        Keys.onPressed: {
            if (event.key === Qt.Key_Backspace)
                if (addressBookContactSelected === true) {
                    contactsInput.text = "";
                    addressBookPhoneNumber = "";
                    addressBookContactSelected = false;
                }
        }
    }

    //! Add "+" Button to launch AddressBook page with list of contacts with phone numbers
    Button {
        id: addButton
        width: 43
        height: 42
        anchors { verticalCenter: contactsRect.verticalCenter; right: contactsRect.right; rightMargin: 20 }
        text: "+"
        font { pixelSize: 30; bold: false }
        platformStyle: StyledButton {}

        onClicked: {
            openFile("AddressBook.qml");
        }
    }

    //! Custom defined Class component for sending message
    Telephony {
        id: myTelephony
        property bool msgSent

        //! When the state changes set all properties to false.
        onStateChanged: {
            contactsInput.enabled = false;
            addButton.enabled = false;
        }
    }
}
