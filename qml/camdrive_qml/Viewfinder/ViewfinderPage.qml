import QtQuick 1.1
import com.nokia.meego 1.0
import Camera 1.0
import QtMobility.sensors 1.2
import QtMobility.location 1.2
import QtMobility.systeminfo 1.2
import Settings 1.0
import GeoCoder 1.0
import "../Compass"
import "../StyledComponents"
import "../"
import "../Common/"

Page {
    id: viewfinderPage

    property int orientation: 0
    property int videoPartCounter: 0
    property bool isCameraActive: false
    property bool isCameraRecording: false
    property bool isCameraPaused: false
    property int speed: 0
    property int maxAllowedSpeed: 999
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
        maxAllowedSpeed = settingsObject.getMaxAllowedSpeed();
        //! Clear night mode button settings
        toggleNightModeButton.visible = settingsObject.getShowNightModeButton();
        toggleNightModeButton.source = "../images/night.png"
        //! Clear street name label
        streetNameLabel.text = "";
        viewfinderPage.clearRecordingStatus();
        screenSaver.screenSaverInhibited = true;
        viewfinderPage.wakeCamera();
        Gps.start();
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
        active: false

        onReadingChanged: {
            compassUI.rotationX = reading.x;
            compassUI.rotationY = reading.y;
            compassUI.rotationZ = reading.z;
        }
    }

    OrientationSensor {
        id: orientation
        active: false

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
        screenSaverInhibited: false
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

    function updateCounter(duration)
    {
        var add = duration;
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
        var unit;
        if (settingsObject.getVelocityUnit())
            unit = " km/h";
        else
            unit = " mph";

        textSpeedInfo.text = Math.ceil(speed) + unit;
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
        frontCam.startRecording(false);
    }

    function stopRecording()
    {
        viewfinderPage.isCameraRecording = false;
        frontCam.stopRecording();
        Gps.stop();
        viewfinderPage.videoPartCounter = 0;
    }

    function checkMaxAllowedSpeed(speed)
    {
        if (settingsObject.getMaxAllowedSpeed() === -1 || !isCameraRecording)
            return;

        if (speed > maxAllowedSpeed) {
            speedWarning.showSpeedWarning();
        }
    }

    function close()
    {
        stopRecording();
        unloadCamera();
        appWindow.pageStack.pop();
        screenSaver.screenSaverInhibited = false;
    }

    function closeMenuFunc()
    {
        closeMenu.enabled = false;
        viewfinderMenu.visible = false;
        emergencyMenu.visible = false;
        if (viewfinderPage.isCameraPaused)
            resumeRecording();
    }

    function pauseRecording()
    {
        if(viewfinderPage.isCameraRecording) {
            stopRecording();
            clearRecordingStatus();
        }
        frontCam.stop();
        viewfinderPage.isCameraPaused = true;
    }

    function resumeRecording()
    {
        if(viewfinderPage.isCameraActive)
            frontCam.start();
        viewfinderPage.isCameraPaused = false;
    }

    function openEmergencyMenu()
    {
        emergencyMenu.visible = true;
        closeMenu.enabled = true;
        viewfinderPage.pauseRecording();
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
                resumeRecording();
            }
            else {
                pauseRecording();
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
            var speed = Gps.getSpeed();

            if (settingsObject.getVelocityUnit()) {
                speed = speed * 3.6;
            }
            else {
                speed = speed * 2.2369;
            }

            if (speed < 4)
                speed = 0;

            setSpeed(speed);
            checkMaxAllowedSpeed(speed);

            //! Get reversed geocode, for street name
            reverseGeoCode.coordToAddress(Gps.getLatitude(),
                                          Gps.getLongitude());
        }
        //! Accelerometer alarm signal
        onAlarm: {
            //! Check if it's not an emergency alarm
            if (alarmLevel > 1) {
                openEmergencyMenu();
                emergencyButton.startAlarm();
            }
            else
                emergencyButton.startAlarm();
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

    GeoCoder {
        id:reverseGeoCode

        //! When reverse geocoding info received, update street address in information panel
        onReverseGeocodeInfoRetrieved: {
            streetNameLabel.text = streetadd;
        }
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

    Label {
        id: streetNameLabel
        anchors.verticalCenter: bottomToolbar.verticalCenter
        anchors.horizontalCenter: bottomToolbar.horizontalCenter
        color: "white"
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
        anchors.leftMargin: 10
        anchors.verticalCenter: bottomToolbar.verticalCenter
        width: 48
        height: 48
        opacity: 0
        source: "../images/led_recording.png"
    }

    Image {
        id: statusIconInactive
        anchors.left: bottomToolbar.left
        anchors.leftMargin: 10
        anchors.verticalCenter: bottomToolbar.verticalCenter
        width: 48
        height: 48
        opacity: 1
        source: "../images/led_recording1.png"
    }

    Text {
        id: textStatusInfo
        anchors.left: statusIcon.right
        anchors.leftMargin: 5
        anchors.verticalCenter: bottomToolbar.verticalCenter
        text: "Waiting..."
        color: "white"
        font.bold: true
        font.pointSize: 18
        opacity: 1
    }

    // Speed o meter
    Text {
        id: textSpeedInfo
        anchors.right: upperToolbar.right
        anchors.rightMargin: 10
        anchors.verticalCenter: upperToolbar.verticalCenter
        text: "114 km/h"
        color: "white"
        font.bold: true
        font.pointSize: 18
    }

    // Compass
    Text {
        id: textCompass
        anchors.left: upperToolbar.left
        anchors.leftMargin: 10
        anchors.verticalCenter: upperToolbar.verticalCenter
        text: "NW"
        color: "white"
        font.bold: true
        font.pointSize: 18

        MouseArea {
            anchors.fill: parent
            onClicked: {
                rotation.active = !rotation.active;
                orientation.active = !orientation.active;
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
        anchors.verticalCenter: bottomToolbar.verticalCenter
        text: "0:00/" + settingsObject.getStoreLast() + ":00"
        color: "white"
        font.bold: true
        font.pointSize: 18
    }

    // Record/stop button
    ButtonHighlight {
        id: toggleRecordingButton
        width: 80
        height: width
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: upperToolbar.bottom
        anchors.topMargin: 20

        source: "../images/menu.png"
        highlightSource: "../images/highlight80.png"

        onClicked: {
            console.log('toggled recording clicked')
            //stopDialog.open()
            viewfinderMenu.visible = true;
            closeMenu.enabled = true;
        }
    }

    // Record/stop button
    ButtonHighlight {
        id: toggleNightModeButton
        width: 80
        height: width
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: bottomToolbar.top
        anchors.bottomMargin: 20
        visible: settingsObject.getShowNightModeButton()
        property bool nightMode: false

        source: nightMode ? "../images/day.png" : "../images/night.png"
        highlightSource: "../images/highlight80.png"

        onClicked: {
            nightMode = !nightMode;
            pauseRecording();
            resumeRecording();
            frontCam.enableNightMode(nightMode);
        }
    }

/*
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
                //stopDialog.open()
                viewfinderMenu.visible = true;
                closeMenu.enabled = true;
            }
        }
    }*/

    // Emergency button
    EmergencyButton {
        id: emergencyButton
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: upperToolbar.bottom
        anchors.topMargin: 20

        MouseArea {
            anchors.fill: parent
            onClicked: {
                openEmergencyMenu();
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

    SpeedWarning {
        id: speedWarning
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 100
    }

    MouseArea {
        id: closeMenu
        anchors.fill: parent
        enabled: false

        onClicked: {
            closeMenuFunc();
        }
    }

    ViewfinderMenu {
        id: viewfinderMenu
        anchors.centerIn: parent
        visible: false
    }

    EmergencyMenu {
        id: emergencyMenu
        anchors.centerIn: parent
        visible: false
    }
}
