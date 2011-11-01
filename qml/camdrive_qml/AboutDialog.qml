import QtQuick 1.1
import com.nokia.meego 1.0

Dialog {
  id: myDialog
  title: Rectangle {
    id: titleField
    height: 2
    width: parent.width
    color: "red"
  }

  content:Item {
    id: name
    height: 50
    width: parent.width
    Text {
      id: text
      font.pixelSize: 22
      anchors.centerIn: parent
      color: "white"
      text: " \n\nCamdrive-qml application.\nAlpha stage.\n\n "
    }
  }

  buttons: ButtonRow {
    style: ButtonStyle { }
      anchors.horizontalCenter: parent.horizontalCenter
      Button {text: "Close"; onClicked: myDialog.accept()}
    }
  }
