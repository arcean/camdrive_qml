import QtQuick 1.1
import com.meego 1.0
import FrontCamera 1.0
import QtMobility.sensors 1.2
import QtMobility.location 1.2

Page {
    tools: commonTools

    id:videoPage
    property int orientation: 0
    orientationLock: PageOrientation.LockLandscape

    Component.onCompleted: {
        camMirrorScale.xScale = -1 * camMirrorScale.xScale
    }

    Compass {
        id: compass
        active: true
        property int calibrationLevel: 0
        property int tresholdLevel: 75
        onReadingChanged: {
            setDirectionFromCompass(compass.reading.azimuth)
        }
    }

    function setDirectionFromCompass(direction)
    {
        if(direction >= 23 && direction <= 68)
            textCompass.text = "NW"
        else if(direction >= 69 && direction <= 112)
            textCompass.text = "W"
        else if(direction >= 113 && direction <= 158)
            textCompass.text = "SW"
        else if(direction >= 159 && direction <= 202)
            textCompass.text = "S"
        else if(direction >= 203 && direction <= 248)
            textCompass.text = "SE"
        else if(direction >= 249 && direction <= 292)
            textCompass.text = "E"
        else if(direction >= 293 && direction <= 339)
            textCompass.text = "NE"
        else
            textCompass.text = "N"
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
        property int speed: 0
        onPositionChanged: {
            speed = positionSource.position.speed;
            speed = speed * 3.6;
            //labelSpeed.text = speed + " km/h";
            if(speed < 4)
                setSpeed(0)
            else
                setSpeed(speed)
        }
    }

    function setSpeed(speed)
    {
        textSpeedInfo.text = speed + " km/h"
    }

    function wakeCamera()
    {
        frontCam.start()
    }

    Scale {
        id:camMirrorScale
        origin.x:parent.width/2
        origin.y:parent.height/2
        xScale:-1
    }

    Rotation {
        id:camMirrorRotate
        origin.x:parent.width/2
        origin.y:parent.height/2
        angle:0
    }

    Connections {
        target:platformWindow

        onActiveChanged: {
            if(platformWindow.active) {
                frontCam.start()
            }
            else {
                frontCam.stop()
            }
        }
    }


    FrontCamera {
        id:frontCam
        anchors.centerIn: parent
        width:videoPage.width
        height:videoPage.height
        transform: [camMirrorScale, camMirrorRotate]
        // aspectRatio:Qt.KeepAspectRatioByExpanding
    }

    Rectangle {
        id: bottomToolbar
        x: 0
        y:394
        width: parent.width
        height: 54
        color: "black"
        opacity: 0.4
    }

    Timer {
        id: statusIconTimer
        interval: 1500
        repeat: true
        running: true

        onTriggered: {
            if (statusIcon.opacity == 1) {
                statusIcon.opacity = 0
                statusIconInactive.opacity = 1
            }
            else {
                statusIcon.opacity = 1
                statusIconInactive.opacity = 0
            }

        }
    }

    Image {
        id: statusIcon
        x: 3
        y: 397
        width: 48
        height: 48
        opacity: 1
        source:"qrc:/icons/recording_active.png"

    }
    Image {
        id: statusIconInactive
        x: 3
        y: 397
        width: 48
        height: 48
        opacity: 0
        source:"qrc:/icons/recording_inactive.png"
    }

    Text {
        id: textStatusInfo
        y: 405
        x: statusIcon.x + statusIcon.width + 3
        horizontalAlignment: TextInput.AlignHCenter
        text: "Recording..."
        color: "white"
        font.bold: true
        font.pointSize: 18
        opacity: 1
    }

    Text {
        id: textSpeedInfo
        y: 405
        x: textStatusInfo.x + textStatusInfo.width + 184
        horizontalAlignment: TextInput.AlignHCenter
        text: "114 km/h"
        color: "white"
        font.bold: true
        font.pointSize: 18
    }

    Text {
        id: textCompass
        y: 405
        x: textSpeedInfo.x + textSpeedInfo.width + 280
        horizontalAlignment: TextInput.AlignHCenter
        text: "NW"
        color: "white"
        font.bold: true
        font.pointSize: 18
    }

    // Record/stop button
    Item {
        id: toggleRecordingButton
        x: 36
        y: 3
        width: 96
        height: 96

        Image {
            id: stopRecordingImage
            width:96
            height:96
            anchors.centerIn: parent
            smooth: true
            source: "qrc:/icons/stop_recording.png"

        }
        MouseArea {
            anchors.fill: parent
            onPressed: {
                stopRecordingImage.source = "qrc:/icons/stop_recording_highlighted.png"
            }
            onReleased: {
                stopRecordingImage.source = "qrc:/icons/stop_recording.png"
            }
            onClicked: {
                console.log('toggled recording clicked')
                myDialog.open()
            }
        }
    }

    // Emergency button
    Item {
        id: emergencyButton
        x: 718
        y: 3
        width: 96
        height: 96

        Image {
            width:96
            height:96
            anchors.centerIn: parent
            source:"qrc:/icons/emergency_call.png"

        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Emergency call clicked")
            }
        }
    }


    Dialog {
        id: myDialog
        title: Item {
            id: titleField
            height: myDialog.platformStyle.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "image://theme/icon-l-contacts"
                height: parent.height - 10
                width: 75
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 5
                anchors.rightMargin: 5
            }
            Label {
                id: titleLabel
                anchors.left: supplement.right
                anchors.verticalCenter: titleField.verticalCenter
                font.capitalization: Font.MixedCase
                color: "white"
                text: "Exit"
            }
            Image {
                 id: closeButton
                 anchors.verticalCenter: titleField.verticalCenter
                 anchors.right: titleField.right
                 source: "image://theme/icon-m-common-dialog-close"
                 MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked:  { myDialog.reject(); }
                 }
             }
         }
         content:Item {
             id: name
             height: childrenRect.height
             Text {
                  id: text
                  font.pixelSize: 22
                  color: "white"
                  text: "Do you want to save video?\n"
             }
         }
         buttons: ButtonRow {
             platformStyle: ButtonStyle {
                 checkedDisabledBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "")
                 checkedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "")
                 pressedBackground: "image://theme/" + "color11-" + "meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
             }
             anchors.horizontalCenter: parent.horizontalCenter
             Button {id: b1; text: "Yes"; onClicked: {

                     myDialog.accept()
                     frontCam.unload()
                     pageStack.pop()
                 }
             }
             Button {id: b2; text: "No"; onClicked: {

                     myDialog.reject()
                     frontCam.unload()
                     pageStack.pop()
                 }
             }
         }
    }

}
