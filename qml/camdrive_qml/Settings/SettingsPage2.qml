import QtQuick 1.0
import com.nokia.meego 1.0
import "../Common"

Page {
    tools: commonTools

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        text: "Settings"
    }

    Flickable {
        id: flicker

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: parent.bottom
        }
        boundsBehavior: Flickable.DragOverBounds
        contentWidth: width
        contentHeight: column.height

        Column {
            id: column

            anchors { left: parent.left; top: parent.top; right: parent.right }

                Repeater {
                    id: repeater

                    model: ListModel {
                        id: settingsModel

                        ListElement { name: QT_TR_NOOP("Recording"); fileName: "RecordingSettingsPage.qml" }
                        ListElement { name: QT_TR_NOOP("Video"); fileName: "VideoSettingsPage.qml" }
                        ListElement { name: QT_TR_NOOP("Audio"); fileName: "AudioSettingsPage.qml" }
                    }

                    DrillDownDelegate {
                        id: delegate

                        width: column.width
                        title: name
                        onClicked: appWindow.pageStack.push(Qt.resolvedUrl(fileName))
                    }
                }


        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
