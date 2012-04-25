import QtQuick 1.0
import com.nokia.meego 1.0
import "../Common"

Page {
    id: textMessagePage

    tools: ToolBarLayout {
        id: toolBar

        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                messageText.closeSoftwareInputPanel();
                pageStack.pop();
            }
        }
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

            //! TextEdit for SMS message
            TextEdit {
                id: messageText
                anchors { fill: parent; leftMargin: 10; topMargin: 10}
                font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 26 }
                cursorVisible: false
                wrapMode: TextEdit.Wrap

                //! Explicit basic PlaceHolder Implemenatation
                Text {
                    id: messageTextPlaceholder
                    anchors.fill: parent.fill
                    font { family: UiConstants.BodyTextFont.family; weight: Font.Light; pixelSize: 26 }
                    color: "#b2b2b4"
                    visible: messageText.cursorPosition === 0 && !messageText.text &&
                             messageTextPlaceholder.text && !messageText.inputMethodComposing
                    opacity: 0.65
                    text: qsTr("Write your message here\nExample:\nHi!\nI have a car accident.\n$CITY $STREET,\n$LATITUDE $LONGITUDE");
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
    } //! end of Flickable
}
