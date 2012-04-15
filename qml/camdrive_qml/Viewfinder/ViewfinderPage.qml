import QtQuick 1.1
import com.nokia.meego 1.0
import Camera 1.0
import QtMobility.sensors 1.2
import QtMobility.location 1.2
import QtMobility.systeminfo 1.2
import Settings 1.0
import "../Compass"
import "../StyledComponents"
import "../"

Page {
    id: viewfinderPage

    property int orientation: 0
    property int videoPartCounter: 0
    property bool isCameraActive: false
    property bool isCameraRecording: false
    property int speed: 0
    orientationLock: PageOrientation.LockLandscape

    Component.onCompleted: {
       // frontCam.setGps(Gps);
       // frontCam.setAccelerometer(AccelDevice);
       // frontCam.setDatabase(Database);
       // Database.openDatabase();
       // Database.createTables();
        camMirrorScale.xScale = -1 * camMirrorScale.xScale;
    }

    function firstTimeFunction() {
        viewfinderPage.clearRecordingStatus();
        viewfinderPage.wakeCamera();
    }

    Compass {
        id: compass
        active: true
        property int calibrationLevel: 0
        property int tresholdLevel: 75
        onReadingChanged: {
            setDirectionFromCompass(compass.reading.azimuth)
            compassUI.azimuth = reading.azimuth;
            compassUI.calibrationLevel = reading.calibrationLevel
        }
    }

    RotationSensor {
        id: rotation
        active: true

        onReadingChanged: {
            compassUI.rotationX = reading.x;
            compassUI.rotationY = reading.y;
            compassUI.rotationZ = reading.z;
        }
    }

    OrientationSensor {
        id: orientation
        active: true

        onReadingChanged: {
            compassUI.isFaceUp = (reading.orientation === OrientationReading.FaceUp);

            switch (reading.orientation) {
            case OrientationReading.FaceUp:
                compassUI.orientationDesc = "Face Up";
                break;
            case OrientationReading.FaceDown:
                compassUI.orientationDesc = "Face Down";
                break;
            case OrientationReading.LeftUp:
                compassUI.orientationDesc = "Left Up";
                break;
            case OrientationReading.RightUp:
                compassUI.orientationDesc = "Right Up";
                break;
            case OrientationReading.TopDown:
                compassUI.orientationDesc = "Top Down"
                break;
            case OrientationReading.TopUp:
                compassUI.orientationDesc = "Top Up";
                break;
            default:
                compassUI.orientationDesc = reading.orientation
                break;
            }
        }
    }

    ScreenSaver {
        id: screenSaver
        screenSaverInhibited: viewfinderPage.isCameraRecording
    }

    Settings {
        id: settingsObject
    }
/*
    Timer {
        id: storeDataTimer
        interval: settingsObject.getStoreDataEachXSeconds() * 1000
        repeat: true
        running: false

        onTriggered: {*/
            /* TODO: special code for events (such as collision) is stored as the last value */
           // frontCam.addNewVideoInfoQML(positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude,
           //                             speed, AccelDevice.getX(), AccelDevice.getY(), AccelDevice.getZ(), 0);
     /*   }
    }*/

    Timer {
        id: timerTouchToStartRecording
        interval: 1200
        repeat: true
        running: true

        onTriggered: {
            if (textTouchToStartRecording.opacity == 1)
                textTouchToStartRecording.opacity = 0
            else
                textTouchToStartRecording.opacity = 1
        }
    }

    MouseArea {
        id: clickMeMouseArea
        anchors.fill: parent
        onClicked: {
            clickMeMouseArea.enabled = false
            timerTouchToStartRecording.stop()
            textTouchToStartRecording.visible = false
            textStatusInfo.text = "Recording..."
            statusIconTimer.start()
            startRecording()
        }
    }

    function clearRecordingStatus()
    {
        clickMeMouseArea.enabled = true;
        timerTouchToStartRecording.start();
        textTouchToStartRecording.visible = true;
        statusIconTimer.stop();
        textStatusInfo.text = "Waiting...";
        statusIcon.opacity = 0;
        statusIconInactive.opacity = 1;
        textCounter.text = "0:00";
    }

    function setDirectionFromCompass(direction)
    {
        if(direction >= 23 && direction <= 68)
            textCompass.text = "SE"
        else if(direction >= 69 && direction <= 112)
            textCompass.text = "S"
        else if(direction >= 113 && direction <= 158)
            textCompass.text = "SW"
        else if(direction >= 159 && direction <= 202)
            textCompass.text = "W"
        else if(direction >= 203 && direction <= 248)
            textCompass.text = "NW"
        else if(direction >= 249 && direction <= 292)
            textCompass.text = "N"
        else if(direction >= 293 && direction <= 339)
            textCompass.text = "NE"
        else
            textCompass.text = "E"
    }
/*
    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true
        onPositionChanged: {
            speed = positionSource.position.speed * 3.6;

            if (speed < 4)
                speed = 0;

            setSpeed(speed);
        }
    }
*/
    function updateCounter(duration)
    {
        var add = (((settingsObject.getStoreLastInMinutes() * 60 * 1000) / 2)  * videoPartCounter) + duration;
        var value = add / 1000
        var seconds = value % 60
        var minutes = value / 60
        var spacer = "0"

        seconds = Math.floor(seconds)
        minutes = Math.floor(minutes)

        if(seconds < 10)
            spacer = "0"
        else
            spacer = ""

        textCounter.text = minutes + ":" + spacer + seconds;// + "/" + settingsObject.getStoreLastInMinutes() + ":00"
    }

    function setSpeed(speed)
    {
        textSpeedInfo.text = speed + " km/h"
    }

    function wakeCamera()
    {
        //frontCam.toggleCamera()
        frontCam.start()
        viewfinderPage.isCameraActive = true
    }

    function unloadCamera()
    {
        viewfinderPage.isCameraActive = false
        viewfinderPage.isCameraRecording = false
        frontCam.unload()
    }

    function startRecording()
    {
        viewfinderPage.isCameraRecording = true;
        AccelDevice.start();
        frontCam.startRecording();
        //storeDataTimer.running = true;
    }

    function stopRecording()
    {
        viewfinderPage.isCameraRecording = false;
        frontCam.stopRecording();
        AccelDevice.stop();
        viewfinderPage.videoPartCounter = 0;
        //storeDataTimer.running = false;
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
                if(viewfinderPage.isCameraActive)
                    frontCam.start()
            }
            else {
                if(viewfinderPage.isCameraRecording) {
                    stopRecording()
                    clearRecordingStatus()
                }
                frontCam.stop()
            }
        }
    }


    Camera {
        id:frontCam
        anchors.centerIn: parent
        width: viewfinderPage.width
        height: viewfinderPage.height
        transform: [camMirrorScale, camMirrorRotate]
        // aspectRatio:Qt.KeepAspectRatioByExpanding
        onDurationChanged: {
            updateCounter(duration)
        }
        onVideoPartNumberChanged: {
            viewfinderPage.videoPartCounter++;
        }
        onGpsUpdated: {
            setSpeed(Gps.getSpeed());
        }

    //    onCreateVideoDetailsTable: {
    //        Database.createVideoDetailsTable(name);
    //   }
    //    onAddNewVideoSignal: {
           // Database.addNewVideo(videoName, numberOfVideoParts, dateTime);
    //    }
      //  onAddNewVideoInfoSignal: {
//            Database.addNewVideoInfo(videoName, latitude, longitude, speed, accelX, accelY, accelZ, specialCode);
       // }
    }

    Rectangle {
        id: upperToolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 50
        color: "black"
        opacity: 0.4
    }

    Rectangle {
        id: bottomToolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50
        color: "black"
        opacity: 0.4
    }

    Column {
        anchors.fill: parent

        CompassUI {
            id: compassUI
            width: parent.width
            height: parent.height-50
            enabled: false
            visible: false
        }
    }

    Timer {
        id: statusIconTimer
        interval: 1500
        repeat: true
        running: false

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
        anchors.left: bottomToolbar.left
        anchors.leftMargin: 5
        anchors.top: bottomToolbar.top
        anchors.verticalCenter: bottomToolbar.verticalCenter
        width: 48
        height: 48
        opacity: 0
        source:"qrc:/icons/recording_active.png"
    }

    Image {
        id: statusIconInactive
        anchors.left: bottomToolbar.left
        anchors.leftMargin: 5
        anchors.top: bottomToolbar.top
        anchors.verticalCenter: bottomToolbar.verticalCenter
        width: 48
        height: 48
        opacity: 1
        source:"qrc:/icons/recording_inactive.png"
    }

    Text {
        id: textStatusInfo
        anchors.left: statusIcon.right
        anchors.leftMargin: 5
        anchors.top: bottomToolbar.top
        anchors.topMargin: 8
        text: "Waiting..."
        color: "white"
        font.bold: true
        font.pointSize: 18
        opacity: 1
    }

    // Speed o meter
    Text {
        id: textSpeedInfo
        anchors.left: upperToolbar.left
        anchors.leftMargin: 10
        anchors.top: upperToolbar.top
        anchors.topMargin: 8
        text: "114 km/h"
        color: "white"
        font.bold: true
        font.pointSize: 18
    }

    // Compass
    Text {
        id: textCompass
        anchors.right: upperToolbar.right
        anchors.rightMargin: 10
        anchors.top: upperToolbar.top
        anchors.topMargin: 8
        text: "NW"
        color: "white"
        font.bold: true
        font.pointSize: 18

        MouseArea {
            anchors.fill: parent
            onClicked: {
                compassUI.enabled = !compassUI.enabled;
                compassUI.visible = !compassUI.visible;
            }
        }
    }

    // Counter, elapsed time
    Text {
        id: textCounter
        anchors.right: bottomToolbar.right
        anchors.rightMargin: 10
        anchors.top: bottomToolbar.top
        anchors.topMargin: 8
        text: "0:00/" + settingsObject.getStoreLastInMinutes() + ":00"
        color: "white"
        font.bold: true
        font.pointSize: 18
    }

    // Record/stop button
    Item {
        id: toggleRecordingButton
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: upperToolbar.bottom
        anchors.topMargin: 20
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
                stopDialog.open()
            }
        }
    }

    // Emergency button
    Item {
        id: emergencyButton
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: upperToolbar.bottom
        anchors.topMargin: 20
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

    Text {
        id: textTouchToStartRecording
        anchors.centerIn: parent
        horizontalAlignment: TextInput.AlignHCenter
        text: "Touch to start recording"
        color: "red"
        font.bold: true
        font.pointSize: 18
        opacity: 1
    }


    Dialog {
        id: stopDialog
        title: Item {
            id: titleField
            height: stopDialog.platformStyle.titleBarHeight
            width: parent.width
            Image {
                id: supplement
                source: "qrc:/icons/dialogStop.png"
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
                    onClicked:  { stopDialog.reject(); }
                 }
             }
         }
         content: Item {
             id: name
             height: childrenRect.height
             Text {
                  id: text
                  font.pixelSize: 22
                  color: "white"
                  text: "Do you want to stop recording and exit?\n"
             }
         }
         buttons: ButtonRow {
             platformStyle: StyledButton {}
             anchors.horizontalCenter: parent.horizontalCenter
             Button {id: b1; text: "Yes"; onClicked: {
                     stopDialog.accept()
                     frontCam.stopRecording()
                     unloadCamera()
                     appWindow.pageStack.pop()
                     screenSaver.screenSaverInhibited = false
                 }
             }
             Button {id: b2; text: "No"; onClicked: {
                     stopDialog.reject()
                 }
             }
         }
    }

}
