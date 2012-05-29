// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../StyledComponents"

Item {

    property alias title: title.text
    property alias model: selectionDialog.model
    property string initialValue
    property string currentValue

    signal valueChosen(string value)

    width: parent.width
    height: 80

    function getInitialValue() {
        var found = false;
        var i = 0;
        while ((!found) && (i < model.count)) {
            if (model.get(i).value == initialValue) {
                selectionDialog.selectedIndex = i;
                found = true;
            }
            i++;
        }
        currentValue = initialValue;
    }

    onInitialValueChanged: getInitialValue()
    Component.onCompleted: getInitialValue()

    ListHighlight {
        visible: mouseArea.pressed
    }

    Column {

        anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }

        Label {
            id: title

            font.bold: true
            color: _TEXT_COLOR
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: subTitle

            color: _ACTIVE_COLOR_TEXT
            verticalAlignment: Text.AlignVCenter
            text: model.get(selectionDialog.selectedIndex).name
        }
    }

    Image {
        anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
        source: (theme.inverted) ? _ICON_LOCATION + "icon-m-textinput-combobox-arrow.png" : _ICON_LOCATION + "icon-m-common-combobox-arrow.png"
        sourceSize.width: width
        sourceSize.height: height
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: selectionDialog.open()
    }

    SelectionDialog {
        id: selectionDialog
        platformStyle: StyledSelectionDialog {}

        titleText: title.text
        onAccepted: {
            currentValue = model.get(selectedIndex).value;
            valueChosen(model.get(selectedIndex).value);
        }
    }
}
