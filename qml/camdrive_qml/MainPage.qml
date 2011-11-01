import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    id: mainPage
    property int orientation: 0
    orientationLock: PageOrientation.LockLandscape

    // Mask invisible region
    Rectangle {
        x: 90
        y: 170
        width: 160
        height: 110
        color: "white"
    }

    Image {
        id: startRecordingImage
        x: 51
        y: 100
        width: 240
        height: 240
        source:"qrc:/icons/start_recording.png"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                parent.source = "qrc:/icons/start_recording_highlighted.png"
            }
            onReleased: {
                parent.source = "qrc:/icons/start_recording.png"
            }
            onClicked: {
                pageStack.push(viewfinderPage);
                viewfinderPage.wakeCamera()
            }
        }
    }

        Image {
            id: settingsImage
            x: (startRecordingImage.x+startRecordingImage.width+16)
            y:100
            width: 240
            height: startRecordingImage.width
            source: "qrc:/icons/settings.png"

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.source = "qrc:/icons/settings_highlighted.png"
                }
                onReleased: {
                    parent.source = "qrc:/icons/settings.png"
                }
                onClicked: {
                    pageStack.push(settingsPage);
                    appWindow.showToolbar()
                }
            }
        }

        Image {
            id: filesImage
            x: (settingsImage.x+settingsImage.width+16)
            y:100
            width: 240
            height: startRecordingImage.width
            source:"qrc:/icons/files.png"

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.source = "qrc:/icons/files_highlighted.png"
                }
                onReleased: {
                    parent.source = "qrc:/icons/files.png"
                }
                onClicked: {
                    console.log('filesButton clicked')
                }
            }
        }
}
