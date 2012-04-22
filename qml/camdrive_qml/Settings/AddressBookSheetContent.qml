import QtQuick 1.0
import com.nokia.meego 1.0
import QtMobility.contacts 1.1

Item  {
   id: addressBookItem
   anchors.fill: parent

//! Elements accessed by the Addressbook.qml
   property alias phonebookModel: phonebookModel
   property alias phoneNumberList: phoneNumberList

   function getTagName()
   {
       if(name.firstName !== "" || name.lastName !== "")
           return (firstChar(name.firstName)).toUpperCase()
               + (firstChar(name.lastName)).toUpperCase();
       else
           return (firstChar(nickname.nickname));
   }

   //! Text to display when no Contacts exist on the device
   Text {
       id: blankscreentext
       text: "No Contacts"
       font { family: UiConstants.BodyTextFont.family; pixelSize: 48 }
       opacity: 0.7

       anchors {
           verticalCenter: parent.verticalCenter
           horizontalCenter: parent.horizontalCenter
       }
       visible: !smssendingPage.contactsAvailable
       color: _TEXT_COLOR
   }

   //! Spinner to indicate contacts are loading
   BusyIndicator {
       id: spinner
       platformStyle: BusyIndicatorStyle { size: "large" }
       anchors.centerIn: parent
       opacity: (smssendingPage.contactsAvailable === true ? (contactListView.count > 0? 0 : 1) : 0 )
       running: (smssendingPage.contactsAvailable === true ? (contactListView.count > 0? false : true) : false )
   }

   //! List View to display the contacts from the contactModel
   ListView {
       id: contactListView

       anchors {
           top: parent.top
           bottom: parent.bottom
           left: parent.left
           right: parent.right
       }

       model: phonebookModel.contacts
       delegate: contactDelegate
       clip: true

       section.property: "displayLabel"
       section.criteria: ViewSection.FirstCharacter

       section.delegate: Item {
           //! Set width and height.
           width: parent.width;
           height: 40

           Text {
               id: headerLabel

               anchors {
                   right: parent.right
                   bottom: parent.bottom
                   rightMargin: 20
                   bottomMargin: 2
               }

               font: UiConstants.GroupHeaderFont
               color: _TEXT_COLOR
               text: section.toUpperCase();
           }

           Image {
               anchors {
                   right: headerLabel.left
                   left: parent.left
                   leftMargin: UiConstants.DefaultMargin
                   verticalCenter: headerLabel.verticalCenter
                   rightMargin: 24
               }

               source: "image://theme/meegotouch-groupheader"
                       + (theme.inverted ? "-inverted" : "") + "-background"
           }
       }

       onCountChanged: {
           if (contactListView.count) {
               if( blankscreentext.visible == true )
                   blankscreentext.visible = false

               spinner.opacity = 0;
               spinner.running = false;
           } else if ( !firstCountChange && contactListView.count == 0 ) {
               blankscreentext.visible = true
           }

           firstCountChange = false
       }
   }

   //! ContactModel to provide requests and data access to contact store
   ContactModel {
       id: phonebookModel
       autoUpdate: true

       filter: DetailFilter {
           detail: ContactDetail.PhoneNumber
           field: PhoneNumber.Number
       }

       sortOrders: SortOrder {
           detail: ContactDetail.DisplayLabel
           direction: Qt.AscendingOrder
           caseSensitivity: Qt.CaseInsensitive
       }
   }

   //! Delegate for each contact item
   Component {
       id: contactDelegate

       Item {
           id: listItem
           width: parent.width
           height: 80

           BorderImage {
               id: background

               anchors {
                   fill: parent
                   leftMargin: -addressbookpage.anchors.leftMargin
                   rightMargin: -addressbookpage.anchors.rightMargin
               }

               visible: mouseArea.pressed
               source: "image://theme/meegotouch-list-inverted-background-pressed-center"
           }

           Image {
               id: contactImage
               height: 60
               width: 60
               source: "image://theme/meegotouch-avatar-placeholder-background"

               anchors {
                   verticalCenter: parent.verticalCenter
                   left: parent.left
                   leftMargin: UiConstants.DefaultMargin
               }

               smooth: true

               Image {
                   id: contactPic
                   anchors.fill: parent
                   source: avatar.imageUrl

                   onStatusChanged: if (status === Image.Error)
                                        contactPic.source = ""
               }

               Text {
                   id: tagName
                   anchors.centerIn: parent
                   color: _TEXT_COLOR
                   font { family: UiConstants.BodyTextFont.family; bold: true; pixelSize: 32 }
                   opacity: (contactPic.source == "") ? 1.0 : 0.0
                   text: (name.firstName !== "" || name.lastName  !== "")?
                             ((firstChar(name.firstName)).toUpperCase()
                              +(firstChar(name.lastName)).toUpperCase()):(firstChar(nickname.nickname))
               }
           }

           Image {
               id: maskedImage
               height: 60
               width: 60
               source: "image://theme/meegotouch-avatar-mask-small"

               anchors {
                   verticalCenter: parent.verticalCenter
                   left: parent.left
                   leftMargin: UiConstants.DefaultMargin
               }

               smooth: true
               opacity: 0.0
           }

           Label {
               id: contactName
               width: parent.width - (contactPic.width + UiConstants.DefaultMargin + 20)
               anchors {
                   left: contactImage.right
                   leftMargin: 20
                   verticalCenter: parent.verticalCenter
                   rightMargin: UiConstants.DefaultMargin
               }

               font: UiConstants.TitleFont
               wrapMode: Text.Wrap
               elide: Text.ElideRight
               color: _TEXT_COLOR
               text: displayLabel
               maximumLineCount: 1
           }

           MouseArea {
               id: mouseArea
               anchors.fill: background

               onClicked: {
                   if (phonebookModel.contacts[index].phoneNumbers.length == 1) {
                       smssendingPage.addressBookPhoneNumber =
                               phonebookModel.contacts[index].phoneNumber.number

                       if(phonebookModel.contacts[index].name.firstName !== "" || phonebookModel.contacts[index].name.lastName !== "")
                           smssendingPage.addressBookContactName =
                               phonebookModel.contacts[index].name.firstName + " "
                               + phonebookModel.contacts[index].name.lastName;
                       else
                           smssendingPage.addressBookContactName = phonebookModel.contacts[index].nickname.nickname;

                       smssendingPage.addressBookContactSelected = true;
                       pageStack.pop();

                       //! By default sheet doesn't open. Need to open the sheet in SMSSender.qml
                       smssendingPage.smsSheet.open();
                   } else {
                       indexValue = index;

                       if(phonebookModel.contacts[index].name.firstName !== "")
                           selectedContactName = phonebookModel.contacts[index].name.firstName;
                       else if(phonebookModel.contacts[index].name.lastName !== "")
                           selectedContactName = phonebookModel.contacts[index].name.lastName;
                       else
                           selectedContactName = phonebookModel.contacts[index].nickname.nickname

                       updatephoneNumberList();
                       singleSelectionDialog.open()
                   }
               }
           }
       }
   }

   //! Section Dialog section
   SelectionDialog {
       id: singleSelectionDialog
       titleText: selectedContactName
       model: phoneNumberList
       selectedIndex: 0

       onAccepted: {
           smssendingPage.addressBookPhoneNumber =
                   singleSelectionDialog.model.get(singleSelectionDialog.selectedIndex).name

           if(phonebookModel.contacts[indexValue].name.firstName !== "" || phonebookModel.contacts[indexValue].name.lastName !== "")
               smssendingPage.addressBookContactName =
                   phonebookModel.contacts[indexValue].name.firstName + " "
                   + phonebookModel.contacts[indexValue].name.lastName;
           else
               smssendingPage.addressBookContactName = phonebookModel.contacts[indexValue].nickname.nickname;

           smssendingPage.addressBookContactSelected = true;
           phoneNumberList.clear();
           pageStack.pop();

           //! By default sheet doesn't open. Need to open the sheet in SMSSender.qml
           smssendingPage.smsSheet.open();
       }

       onRejected: phoneNumberList.clear();
   }

   ScrollDecorator {
       flickableItem: contactListView
   }

   ListModel {
       id: phoneNumberList
   }
}
