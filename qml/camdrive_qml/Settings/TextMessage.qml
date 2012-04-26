import QtQuick 1.0
import com.nokia.meego 1.0
import Settings 1.0
import "../Common"
import "../StyledComponents"

Page {
    id: textMessagePage

    tools: ToolBarLayout {
        id: toolBar

        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                var message = messageText.text;

                if (message == "")
                    message = "Hi! I had a car accident.\n#CITY #STREET,\n#LATITUDE #LONGITUDE";

                settingsObject.setContactTextMessage(message);
                messageText.closeSoftwareInputPanel();
                pageStack.pop();
            }
        }
    }

    Component.onCompleted: {
        messageText.text = settingsObject.getContactTextMessage();
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
        text: "Set text message"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: messageText.closeSoftwareInputPanel();
        }
    }

    //! Flickable element holds the sheet content
    Flickable {
        id: flickableContact
        anchors { left: parent.left; right: parent.right; top: header.bottom; bottom: parent.bottom;
                    topMargin: 2; }
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
                placeholderText: qsTr("Write your message here\nExample:\nHi! I had a car accident.\n#CITY #STREET,\n#LATITUDE #LONGITUDE");
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
    } //! end of Flickable
}
