import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "../Common"
import "../StyledComponents"

Flickable {
    id: flickableContact
    anchors.fill: parent

    flickableDirection: Flickable.VerticalFlick

    //! Variables accessed by the SMSSender.qml
    property alias contactsInput: contactsInput
    property alias contactsInputText: contactsInput.text
    property alias messageText: messageText
    property alias spinner: spinner
    property alias infobanner: infobanner
    property alias addButton: addButton
    property string focusedElement: ""

    //! Rectangle component hosting Label "To", TextInput element ContactSelection/PhoneNumber
    //! and "+" AddButton
    Rectangle {
        id: contactsRect

        width: parent.width
        height: 72
        anchors.left: parent.left
        color: "#E0E1E2"

        //! Adding "TO" Label
        Label {
            id: toLabel
            anchors {
                left: contactsRect.left
                leftMargin: UiConstants.DefaultMargin
                verticalCenter: parent.verticalCenter
            }

            font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 28 }
            text: "To:"
            color: "#4591FF"
        }

        //! TextInput for contact Selction and PhoneNumber addition
        TextInput {
            id: contactsInput
            width: 300
            anchors { left: toLabel.right; leftMargin: 10; verticalCenter: parent.verticalCenter }
            font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 28 }
            horizontalAlignment: TextInput.AlignLeft
            color: "grey"
            focus: true
            inputMethodHints: Qt.ImhDialableCharactersOnly

            onActiveFocusChanged: {
                if (contactsInput.focus) {
                    focusedElement = "number";
                }
            }

            //! Basic Placeholder implementation.
            Text {
                id: contactsInputPlaceHolder
                anchors.fill: parent.fill
                font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 28 }
                color: "#b2b2b4"
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
            anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 20 }
            text: "+"
            font { pixelSize: 30; bold: false }
            platformStyle: StyledButton {}

            onClicked: {
                messageText.closeSoftwareInputPanel();
                messageText.focus = false;
                smssendingPage.openFile("AddressBook.qml");
            }
        }

    }  //!  end of contactsRect Rectangle

    //! Rectangle holding the  TextEdit element for typing the SMS message
    Rectangle {
        id: messageBox
        width: parent.width; height: parent.height - contactsRect.height
        anchors.top: contactsRect.bottom

        //! TextEdit for SMS message
        TextEdit {
            id: messageText
            anchors { fill: parent; leftMargin: 10; topMargin: 10}
            font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 26 }
            cursorVisible: false
            wrapMode: TextEdit.Wrap

            onActiveFocusChanged: {
                if (messageText.focus) {
                    focusedElement = "text";
                }
            }

            //! Explicit basic PlaceHolder Implemenatation
            Text {
                id: messageTextPlaceholder
                anchors.fill: parent.fill
                font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 26 }
                color: "#b2b2b4"
                visible: messageText.cursorPosition === 0 && !messageText.text &&
                         messageTextPlaceholder.text && !messageText.inputMethodComposing
                opacity: 0.65
                text: qsTr("Write your message here")
            }
        }
    } //!  end of messageBox Rectangle

    //! Spinner to indicate the message sending in process, by default transparent
    BusyIndicator {
        id: spinner
        platformStyle: BusyIndicatorStyle { size: "medium" }
        anchors.centerIn: parent
        opacity: 0.0
        running: false
    }

    //! Information Banners to convey alerts and information to user
    MessageHandler { id: infobanner }
}
