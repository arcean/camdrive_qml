import QtQuick 1.0
import com.nokia.meego 1.0
import Settings 1.0
import "../Common"
import "../StyledComponents"

StyledSheet {
    id: textMessagePage
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    onAccepted: {
        var message = messageText.text;

        if (message == "")
            message = "Hi! I had a car accident.\n#CITY, #STREET,\nMy coordinates:\n#LATITUDE #LONGITUDE";

        settingsObject.setContactTextMessage(message);
        messageText.closeSoftwareInputPanel();
    }

    onRejected: {
        messageText.closeSoftwareInputPanel();
    }

    Component.onCompleted: {
        messageText.text = settingsObject.getContactTextMessage();
    }

    Settings {
        id: settingsObject
    }

    //! Flickable element holds the sheet content
    content: Flickable {
            id: flickableContact
            anchors { fill: parent
                      topMargin: 2;
            }
            flickableDirection: Flickable.VerticalFlick

            //! Rectangle holding the  TextEdit element for typing the SMS message
            Rectangle {
                id: messageBox
                anchors.fill: parent
                color: theme.inverted ? "black" : "white"

                //! TextEdit for SMS message
                TextArea {
                    id: messageText
                    anchors { fill: parent; }
                    font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 26 }
                    wrapMode: TextEdit.Wrap
                    platformStyle: StyledTextArea {}
                    placeholderText: qsTr("Write your message here\nExample:\nHi! I had a car accident.\n#CITY, #STREET,\nMy coordinates:\n#LATITUDE #LONGITUDE");
                }
            } //!  end of messageBox Rectangle
        } //! end of Flickable
}
