import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.contacts 1.1

Page {
    id: addressbookpage

    property int indexValue;
    property string selectedContactName;
    property bool firstCountChange: true;

    //! Function to retrieve the first char of the string to be displayed
    function firstChar(stringValue) {
        return stringValue.charAt(0);
    }

    //! Function to update each individuals phone number in a model
    function updatephoneNumberList() {
        for (var i = 0; i < addressBookSheetContentId.phonebookModel.contacts[indexValue].phoneNumbers.length; i++) {
            addressBookSheetContentId.phoneNumberList.append({"name": addressBookSheetContentId.phonebookModel.contacts[indexValue].phoneNumbers[i].number})
        }
    }

    Sheet {
        id: addressBookSheet
        anchors.fill: parent
        rejectButtonText: "Cancel"

        content: AddressBookSheetContent { id: addressBookSheetContentId }

        onRejected: {
            pageStack.pop();

            //! By default sheet doesn't open. Need to open the sheet in SMSSender.qml
           // smssendingPage.smsSheet.open();
        }
    }

    Component.onCompleted: {
        //! After paging is loaded, open the sheet
        addressBookSheet.open();
    }
}

//! End of File
