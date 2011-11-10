import QtQuick 1.0
import com.nokia.meego 1.0

MenuItem {
    id: root

    property alias title: title.text
    property string initialValue
    property alias model: selectionDialog.model
    property alias pressed: mouseArea.pressed

    signal valueChosen(string value)
    signal clicked

    Item {
        id: selector
        anchors.fill: parent

        Component.onCompleted: {
            var found = false;
            var i = 0;
            while ((!found) && (i < model.count)) {
                if (model.get(i).value == initialValue) {
                    selectionDialog.selectedIndex = i;
                    found = true;
                }
                i++;
            }
        }

        Column {
            anchors { left: parent.left; leftMargin: 25; verticalCenter: parent.verticalCenter }
            Label {
                id: title
                font.bold: true
                color: _TEXT_COLOR
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: subTitle
                color: "#4d4d4d"
                verticalAlignment: Text.AlignVCenter
                text: model.get(selectionDialog.selectedIndex).name
            }
        }

        Image {
            anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
            source: theme.inverted ? _ICON_LOCATION + "icon-m-textinput-combobox-arrow.png" : _ICON_LOCATION + "icon-m-common-combobox-arrow.png"
            sourceSize.width: width
            sourceSize.height: height
        }

        SelectionDialog {
            id: selectionDialog
            titleText: title.text
            onAccepted: valueChosen(model.get(selectedIndex).value)
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            selectionDialog.open();
            if (parent.enabled) {
                parent.clicked();
            }
        }
    }

    onClicked: if (parent) parent.closeLayout();
}
