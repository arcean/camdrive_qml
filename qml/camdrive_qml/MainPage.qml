import QtQuick 1.1
import com.meego 1.0
import FrontCamera 1.0
import QtMobility.sensors 1.2

Page {
    tools: commonTools

    id: mainPage
    property int orientation: 0
    orientationLock: PageOrientation.LockLandscape

    Image {
        anchors.fill: parent
        source:"qrc:/icons/background.png"

        Rectangle {
            id: videoButton
            x: 51
            y:100
            width: 240
            height: videoButton.width
            color: "blue"

            Text {
                text: "Video"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.color = "white"
                }
                onReleased: {
                    parent.color = "blue"
                }

                onClicked: {
                    pageStack.push(viewfinderPage);
                }
            }
        }

        Rectangle {
            id: settingsButton
            x: (videoButton.x+videoButton.width+16)
            y:100
            width: 240
            height: videoButton.width
            color: "blue"

            Text {
                text: "Settings"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.color = "white"
                }
                onReleased: {
                    parent.color = "blue"
                }
                onClicked: {
                    console.log('settingsButton clicked')
                }
            }
        }

        Rectangle {
            id: filesButton
            x: (settingsButton.x+settingsButton.width+16)
            y:100
            width: 240
            height: videoButton.width
            color: "blue"

            Text {
                anchors.centerIn: parent.Center
                text: "Files"
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.color = "white"
                }
                onReleased: {
                    parent.color = "blue"
                }
                onClicked: {
                    console.log('filesButton clicked')
                }
            }
        }

    }


}
