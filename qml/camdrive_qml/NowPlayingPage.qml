import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import QtMobility.gallery 1.1
import QtMobility.location 1.2
import QtMobility.systeminfo 1.2
import GeoCoder 1.0
import Settings 1.0
import Line 1.0
import Chart 1.0
import "scripts/utils.js" as Utils
import "Common/"

Page {
    id: nowPlayingPage

    //! Property holding height of swiping page
    property int pageHeight: (nowPlayingPage.height - pageIndicator.height)

    property bool videoPlaying: false
    property variant currentVideo: []
    property int playlistPosition: 0
    property bool videoPaused: videoPlayer.paused
    property bool videoStopped: !videoPlayer.playing
    property int videoInfoIterator: 1

    //! Property to observe the application shown/hidden status
    property bool applicationActive: Qt.application.active
    //! Needed by hw keyboard
    focus: true

    function setPlaylist(videoList) {
        playlistPosition = 0;
        currentVideo = videoList[0];
        startPlayback();
    }

    function appendPlaylist(videoList) {
        if (playbackQueue.count == 0) {
            playlistPosition = 0;
            currentVideo = videoList[0];
        }
        for (var i = 0; i < videoList.length; i++) {
            playbackQueue.append(videoList[i]);
        }
    }

    function startSpeedInfoTimer()
    {
        var counter = 1;
        videoPlayer.currentPos = 1;
        var latitude = DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, counter);
        var longitude = DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, counter);

        //! Hide map if coordinates are undefined
        if (latitude == 0 && longitude == 0)
            map.visible = false;
        else
            map.visible = true;

        var specialCode = DatabaseHelper.getVideoInfoSpecialCodeQML(videoPlayer.source, counter);
        var accelX = DatabaseHelper.getVideoInfoAccelXQML(videoPlayer.source, counter);
        var accelY = DatabaseHelper.getVideoInfoAccelYQML(videoPlayer.source, counter);
        var accelZ = DatabaseHelper.getVideoInfoAccelZQML(videoPlayer.source, counter);

        setSpeed(DatabaseHelper.getVideoInfoSpeedQML(videoPlayer.source, counter));
        setLatitude(latitude);
        setLongitude(longitude);
        setCollision(specialCode);
        setAccelReadings(accelX, accelY, accelZ);
        reverseGeoCode.coordToAddress(latitude, longitude);

        var num = DatabaseHelper.countVideoInfo(videoPlayer.source);

        //! Show begin and end positions
        beginCoord.latitude = latitude;
        beginCoord.longitude = longitude;
        endCoord.latitude = DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, num);
        endCoord.longitude = DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, num);
        console.log('latitude', latitude)
        console.log('longitude', longitude)
        beginPos.visible = true;
        endPos.visible = true;

        //! Add accel reading to chart
        if (!gsensorChart.ready) {
            for (var i = 1; i <= num; i++) {
                gsensorChart.addPoint(DatabaseHelper.getVideoInfoAccelXQML(videoPlayer.source, i), 1);
                gsensorChart.addPoint(DatabaseHelper.getVideoInfoAccelYQML(videoPlayer.source, i), 2);
                gsensorChart.addPoint(DatabaseHelper.getVideoInfoAccelZQML(videoPlayer.source, i), 3);
            }
            gsensorChart.updateChart();
            gsensorChart.ready = true;
        }
        gsensorFlickable.contentX = -480 / 2
        gsensorChart.setCurrentHightlight(counter);
        gsensorChart.visible = true;

        videoInfoIterator++;
    }

    function startPlayback() {
        //! Hide gsensorChart, when adding new values, gsensorChart is wrongly placed (Flickable area)
        gsensorChart.visible = false;

        if (currentVideo.itemId) {
            video.item = currentVideo.itemId;
        }
        else {
            videoModel.getVideo(currentVideo.filePath);
        }
        videoPlayer.stop();
        videoPlayer.source = "";
        archivePlaybackTimer.restart();
        //state = "showMap";
    }

    function stopPlayback() {
        video.metaData.resumePosition = Math.floor(videoPlayer.position / 1000);
        videoPlayer.stop();
        videoPlaying = false;
        videoPlayer.source = "";
        currentVideo = [];
        isNowPlayingPageActive = false;
        appWindow.pageStack.pop();
    }

    //! Update accel readings for g-sensor view
    function setAccelReadings(accelX, accelY, accelZ)
    {
        if (accelX === 0 && accelY === 0 && accelZ === 0)
            return;

        gsensorXline.value = Math.abs(accelX);
        gsensorYline.value = Math.abs(accelY);
        gsensorZline.value = Math.abs(accelZ);
    }

    /* Sets speedLabel's text. */
    function setSpeed(value)
    {
        //! No GPS data available
      //  if (value == 0) {
       //     speedLabel.visible = false;
      ////      actualSpeedLabel.text = "Actual speed: n/a ";
      //      return;
       // }
       // else
       //     speedLabel.visible = true;

        var speed;

        if (settingsObject.getVelocityUnit()) {
            speed = value * 3.6;
        }
        else {
            speed = value * 2.2369;
        }

        if (speed < 4)
            speed = 0;

        var unit;
        if (settingsObject.getVelocityUnit())
            unit = " km/h";
        else
            unit = " mph";

        speedLabel.text = "Speed: " + Math.ceil(speed) + unit;
        actualSpeedLabel.text = "Actual speed: " + Math.ceil(speed) + unit;
    }

    Coordinate {
        id: ourCoord
        latitude: 56.62
        longitude: 16.16
    }

    /* Sets longitudeLabel's text and position on the map. */
    function setLongitude(value)
    {
        if (value === 0)
            return;

        var loc;

        if (value >= 0)
            loc = " E";
        else
            loc = " W";

        ourCoord.longitude = value;
        longitudeLabel.text = "Longitude: " + value.toFixed(2) + loc;
    }

    /* Sets latitudeLabel's text and position on the map. */
    function setLatitude(value)
    {
        if (value === 0)
            return;

        var loc;

        if (value >= 0)
            loc = " N";
        else
            loc = " S";

        ourCoord.latitude = value;
        latitudeLabel.text = "Latitude: " + value.toFixed(2) + loc;
    }

    function setCollision(alarmFlag)
    {
        var text;
        var flagText;

        if (alarmFlag > 0 && alarmFlag < 10)
            text = "Collision side: ";
        else if (alarmFlag > 10)
            text = "Probable collision side: ";

        if (alarmFlag > 9)
            alarmFlag -= 10;

        if (alarmFlag === 1)
            flagText = "front";
        else if (alarmFlag === 2)
            flagText = "left";
        else if (alarmFlag === 3)
            flagText = "right";
        else if (alarmFlag === 4)
            flagText = "rear";
        else {
            flagText = "";
        }

        if (flagText.length > 0) {
            collisionLabel.text = text + flagText;
        }
        else
            collisionLabel.text = "";
    }

    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Right:
                videoPlayer.position = videoPlayer.position + 10000;

                var pos = Math.floor(videoPlayer.position / 1000);

                //! Fix for disappearing video informations.
                if (pos === 0)
                    pos = 1;

                //! gsensor chart
                gsensorChart.setCurrentHightlight(pos);

                if (pos > 1 && !gsensorChart.isEmpty()) {
                    gsensorFlickable.contentX = (-480 / 2) + (gsensorChart.getSpacer() * (pos - 1));
                }
                else if (pos == 1 && !gsensorChart.isEmpty())
                    gsensorFlickable.contentX = -480 / 2;

                event.accepted = true;
                break;
            case Qt.Key_Left:
                videoPlayer.position = videoPlayer.position - 10000;

                var pos = Math.floor(videoPlayer.position / 1000);

                //! Fix for disappearing video informations.
                if (pos === 0)
                    pos = 1;

                //! gsensor chart
                gsensorChart.setCurrentHightlight(pos);

                if (pos > 1 && !gsensorChart.isEmpty()) {
                    gsensorFlickable.contentX = (-480 / 2) + (gsensorChart.getSpacer() * (pos - 1));
                }
                else if (pos == 1 && !gsensorChart.isEmpty())
                    gsensorFlickable.contentX = -480 / 2;

                event.accepted = true;
                break;
            case Qt.Key_Q:
            case Qt.Key_Backspace:
                stopPlayback();
                event.accepted = true;
                break;
            case Qt.Key_Space:
            case Qt.Key_Select:
            case Qt.Key_Enter:
            case Qt.Key_Return:
                if (nowPlayingPage.videoStopped) {
                    startPlayback();
                }
                else {
                    videoPlayer.setToPaused = !videoPlayer.setToPaused;
                }
                event.accepted = true;
                break;
            }
        }
    }

    // When going to background, pause the playback. And when returning from
    // background, resume playback.
    onApplicationActiveChanged: {
        if (!videoPlayer.paused || !nowPlayingPage.videoStopped) {
            if(!applicationActive) {
                videoPlayer.pause();
            }
        }
    }

    ScreenSaver {
        id: screenSaver
        screenSaverInhibited: nowPlayingPage.videoPlaying
    }

    Settings {
        id: settingsObject
    }

    ToolBar {
        id: toolBar
        z: 10
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

        tools: ToolBarLayout {
            id: layout

            property int itemWidth: Math.floor(width / 7)

            ToolIcon {
                id: stopButton
                anchors { left: parent.left }
                platformIconId: "toolbar-back";
                onClicked: stopPlayback()
            }

            ToolIcon {
                id: playButton
                anchors {
                    left: !appWindow.inPortrait ? stopButton.right : undefined;
                    centerIn: !appWindow.inPortrait ? undefined : layout;
                }
                iconSource: (videoPlayer.paused || nowPlayingPage.videoStopped) ?
                                "images/play-accent-" + _ACTIVE_COLOR + ".png" : "images/pause-accent-" + _ACTIVE_COLOR + ".png"
                onClicked: {
                    if (nowPlayingPage.videoStopped) {
                        startPlayback();
                    }
                    else {
                        videoPlayer.setToPaused = !videoPlayer.setToPaused;
                    }
                }
            }

            NewProgressBar {
                id: progressBar

                anchors {
                    left: !appWindow.inPortrait ? playButton.right : parent.right;
                    topMargin: 20;
                    leftMargin: 40;
                    right: parent.right;
                    rightMargin: 40
                }
                indeterminate: (videoPlayer.status == Video.Buffering) || ((videoPlayer.status == Video.Loading) && !videoPlayer.setToPaused)
                minimumValue: 0
                maximumValue: 100
                value: (nowPlayingPage.videoPlaying) ? Math.floor((videoPlayer.position / videoPlayer.duration) * 100) : 0
                visible: !appWindow.inPortrait

                Label {
                    anchors { top: parent.bottom; horizontalCenter: parent.left }
                    font.pixelSize: _SMALL_FONT_SIZE
                    color: _TEXT_COLOR
                    text: (!nowPlayingPage.videoPlaying) || ((videoPlayer.status == Video.Loading) && !videoPlayer.setToPaused) || (videoPlayer.status == Video.Buffering) ? "0:00" : Utils.getTime(videoPlayer.position)
                }

                Label {
                    anchors { top: parent.bottom; horizontalCenter: parent.right }
                    font.pixelSize: _SMALL_FONT_SIZE
                    color: _TEXT_COLOR
                    text: Utils.getTime(videoPlayer.duration)
                }

                SeekBubble {
                    id: seekBubble

                    anchors.bottom: parent.top
                    opacity: value != "" ? 1 : 0
                    value: (seekMouseArea.drag.active) && (seekMouseArea.posInsideDragArea) ? Utils.getTime(Math.floor((seekMouseArea.mouseX / seekMouseArea.width) * videoPlayer.duration)) : ""
                }

                MouseArea {
                    id: seekMouseArea

                    property bool posInsideMouseArea: false
                    property bool posInsideDragArea: (seekMouseArea.mouseX >= 0) && (seekMouseArea.mouseX <= seekMouseArea.drag.maximumX)

                    width: parent.width
                    height: 60
                    anchors.centerIn: parent
                    drag.target: seekBubble
                    drag.axis: Drag.XAxis
                    drag.minimumX: -40
                    drag.maximumX: width - 10
                    onExited: posInsideMouseArea = false
                    onEntered: posInsideMouseArea = true
                    onPressed: {
                        posInsideMouseArea = true;
                        seekBubble.x = mouseX - 40;
                    }
                    onReleased: {
                        if (posInsideMouseArea) {
                            videoPlayer.position = Math.floor((mouseX / width) * videoPlayer.duration);

                            var pos = Math.floor(videoPlayer.position / 1000);

                            //! Fix for disappearing video informations.
                            if (pos === 0)
                                pos = 1;

                            //! gsensor chart
                            gsensorChart.setCurrentHightlight(pos);

                            if (pos > 1 && !gsensorChart.isEmpty()) {
                                gsensorFlickable.contentX = (-480 / 2) + (gsensorChart.getSpacer() * (pos - 1));
                            }
                            else if (pos == 1 && !gsensorChart.isEmpty())
                                gsensorFlickable.contentX = -480 / 2;
                            //videoInfoIterator = Math.ceil(videoPlayer.position / (DatabaseHelper.getVideoStoredEachQML(videoPlayer.source) * 1000));
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        visible: !appWindow.inPortrait
    }

    Timer {
        id: archivePlaybackTimer
        /* Prevents segfault when switching between videos */

        interval: 1000
        onTriggered: {
            videoPlayer.setVideo(currentVideo.url);
            startSpeedInfoTimer();
            mapPlacer.visible = true;
        }
    }

    Label {
        id: speedLabel
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        z: 10
        font.pixelSize: _STANDARD_FONT_SIZE
    }

    Video {
        id: videoPlayer
        x: 10
        y: appWindow.inPortrait ? 20 : 10
        width: appWindow.inPortrait ? 460 : 844
        height: appWindow.inPortrait ? 300 : (nowPlayingPage.height - 20 - toolBar.height)
        fillMode: Video.PreserveAspectFit

        property bool repeat: false // True if playback of the current video is to be repeated
        property bool setToPaused: false
        property int currentPos: 1

        paused: ((platformWindow.viewMode == WindowState.Thumbnail) && ((videoPlayer.playing)) || ((appWindow.pageStack.currentPage != videoPlaybackPage) && (videoPlayer.playing)) || (videoPlayer.setToPaused))
        onError: {
        }

        onPositionChanged: {
            //! TODO: take in account: DatabaseHelper.getVideoStoredEachQML(videoPlayer.source) * 1000

            var pos = Math.floor(videoPlayer.position / 1000);

            //! Fix for disappearing video informations.
            if (pos === 0)
                pos = 1;

            //! Prevent unnecessary repainting
            if (currentPos === pos)
                return;

            currentPos = pos;

            if (!videoPlayer.setToPaused) {
                var latitude = DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, pos);
                var longitude = DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, pos);
                var specialCode = DatabaseHelper.getVideoInfoSpecialCodeQML(videoPlayer.source, pos);
                var accelX = DatabaseHelper.getVideoInfoAccelXQML(videoPlayer.source, pos);
                var accelY = DatabaseHelper.getVideoInfoAccelYQML(videoPlayer.source, pos);
                var accelZ = DatabaseHelper.getVideoInfoAccelZQML(videoPlayer.source, pos);
                setSpeed(DatabaseHelper.getVideoInfoSpeedQML(videoPlayer.source, pos));

                //! Hide map if coordinates are undefined
                if (latitude == 0 && longitude == 0)
                    map.visible = false;
                else
                    map.visible = true;

                setLatitude(latitude);
                setLongitude(longitude);
                setCollision(specialCode);
                setAccelReadings(accelX, accelY, accelZ);

                //! gsensor chart
                gsensorChart.setCurrentHightlight(pos);

                if (pos > 1 && !gsensorChart.isEmpty()) {
                    gsensorFlickable.contentX = (-480 / 2) + (gsensorChart.getSpacer() * (pos - 1));
                }
                else if (pos == 1 && !gsensorChart.isEmpty())
                    gsensorFlickable.contentX = -480 / 2;

                console.log(gsensorChart.getSpacer())
                console.log('DT', gsensorFlickable.x)
                console.log('Dx', gsensorFlickable.contentX)

                reverseGeoCode.coordToAddress(latitude, longitude);
            }
        }

        onStatusChanged: {
            if (videoPlayer.status == Video.EndOfMedia) {
                videoPlayer.stop();
                videoPlaying = false;
                // /* Play the video again. */
                //startPlayback();
            }
        }

        function setVideo(videoUrl) {
            videoPlayer.source = decodeURIComponent(videoUrl);
            videoPlaying = true;
            videoPlayer.play();
        }

        BusyIndicator {
            id: busyIndicator

            platformStyle: BusyIndicatorStyle {
                inverted: theme.inverted
                size: "large"
            }
            anchors.centerIn: parent
            visible: ((videoPlayer.status == Video.Loading) && !videoPlayer.setToPaused) || (videoPlayer.status == Video.Buffering)
            running: visible

        }

        Image {
            anchors.centerIn: videoPlayer
            source: videoMouseArea.pressed ? "images/play-button-" + _ACTIVE_COLOR + ".png" : "images/play-button.png"
            visible: (videoPlayer.paused && !busyIndicator.visible) || (nowPlayingPage.videoStopped)
        }

        MouseArea {
            id: videoMouseArea
            anchors.fill: videoPlayer

            onReleased: {
                if (nowPlayingPage.videoStopped) {
                    startPlayback();
                }
                else {
                    videoPlayer.setToPaused = !videoPlayer.setToPaused;
                }
            }
        }
    }

    Coordinate {
        id: beginCoord
        latitude: 56.62
        longitude: 16.16
    }

    Coordinate {
        id: endCoord
        latitude: 56.62
        longitude: 16.16
    }

    //! Model containing system information pages
    VisualItemModel {
        id: itemModel

        //! Page displaying map
        Item {
            width: nowPlayingPage.width; height: pageHeight

            Label {
                id: noResultsText

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 160
                font.pixelSize: _LARGE_FONT_SIZE
                font.bold: true
                color: "#4d4d4d"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("No data available")
                visible: appWindow.inPortrait ? !map.visible : false
            }

            Map {
                id: map
                width: 460
                height: 400
                plugin : Plugin { name: "nokia" }
                zoomLevel: maximumZoomLevel - 4
                center: ourCoord
                visible: videoInfoIterator == 1 ? false : appWindow.inPortrait

                MapImage {
                    id: beginPos
                    source: _ICON_LOCATION + "icon-m-common-location-selected.png"
                    coordinate: beginCoord
                    visible: false

                    /*!
                     * We want that bottom middle edge of icon points to the location, so using offset parameter
                     * to change the on-screen position from coordinate. Values are calculated based on icon size,
                     * in our case icon is 48x48.
                     */
                    offset.x: -24
                    offset.y: -48
                }

                MapImage {
                    id: endPos
                    source: _ICON_LOCATION + "icon-m-common-location.png"
                    coordinate: endCoord
                    visible: false

                    /*!
                     * We want that bottom middle edge of icon points to the location, so using offset parameter
                     * to change the on-screen position from coordinate. Values are calculated based on icon size,
                     * in our case icon is 48x48.
                     */
                    offset.x: -24
                    offset.y: -48
                }

                MapCircle {
                    id: mapPlacer
                    center: ourCoord
                    radius: 3
                    color: "green"
                    border { width: 10; color: "green" }
                }

                //! Panning and pinch implementation on the maps
                PinchArea {
                    id: pinchArea

                    //! Holds previous zoom level value
                    property double __oldZoom

                    anchors.fill: map

                    //! Calculate zoom level
                    function calcZoomDelta(zoom, percent) {
                        return zoom + Math.log(percent)/Math.log(2)
                    }

                    //! Save previous zoom level when pinch gesture started
                    onPinchStarted: {
                        __oldZoom = map.zoomLevel
                    }

                    //! Update map's zoom level when pinch is updating
                    onPinchUpdated: {
                        map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
                    }

                    //! Update map's zoom level when pinch is finished
                    onPinchFinished: {
                        map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
                    }
                }

                //! Map's mouse area for implementation of panning in the map and zoom on double click
                MouseArea {
                    id: mousearea
                    anchors.fill: map

                    //! Set default zoom level
                    onDoubleClicked: {
                        map.zoomLevel = map.maximumZoomLevel - 4;
                    }
                }
            }
        }

        //! Page displaying details
        Item {
            width: nowPlayingPage.width; height: pageHeight

            Flickable {
                id: flicker

                anchors.fill: parent
                contentWidth: width
                contentHeight: column.height + 20
                visible: appWindow.inPortrait

                Column {
                    id: column

                    anchors { top: parent.top; left: parent.left; right: parent.right; margins: 20 }
                    spacing: 10

                    Label {
                        id: titleText

                        width: parent.width
                        font.pixelSize: 32
                        color: _ACTIVE_COLOR_TEXT
                        wrapMode: Text.WordWrap
                        text: Qt.formatDateTime(video.metaData.lastModified)
                        //text: video.available ? video.metaData.fileName.slice(0, video.metaData.fileName.lastIndexOf(".")) : ""
                    }

                    Column {
                        id: column1
                        width: parent.width

                        Label {
                            color: _TEXT_COLOR
                            text: video.available ? "Length" + ": " + Utils.getDuration(video.metaData.duration) : ""
                        }

                        Label {
                            color: _TEXT_COLOR
                            text: video.available ? "Size" + ": " + video.getFileSize() : ""
                        }

                        Label {
                            color: _TEXT_COLOR
                            text: video.available ? "File name" + ": " + video.metaData.fileName.slice(0, video.metaData.fileName.lastIndexOf(".")) : ""
                        }
                    }

                    Separator {
                        anchors {
                            left: parent.left
                            right: parent.right;
                            leftMargin: 10
                            rightMargin: 30
                        }
                    }

                    Column {
                        id: column2
                        width: parent.width

                        Label {
                            id: cityLabel
                            color: _TEXT_COLOR
                            text: "City: "
                        }

                        Label {
                            id: streetLabel
                            color: _TEXT_COLOR
                            text: "Street: "
                        }

                        Label {
                            id: actualSpeedLabel
                            color: _TEXT_COLOR
                            text: "Actual speed: "
                        }

                        Label {
                            id: longitudeLabel
                            color: _TEXT_COLOR
                            text: "Longitude: "
                        }

                        Label {
                            id: latitudeLabel
                            color: _TEXT_COLOR
                            text: "Latitude: "
                        }

                        Label {
                            id: collisionLabel
                            visible: true
                            color: _ACTIVE_COLOR_TEXT
                            //text: "Probable collision side: "
                            text: ""
                        }
                    }
                }
            }
        }

        //! Page displaying accelerometer readings
        Item {
            width: nowPlayingPage.width; height: pageHeight

            Flickable {
                id: flicker2

                anchors.fill: parent
                anchors.rightMargin: 10
                contentWidth: width
                contentHeight: gsensorChart.y + gsensorChart.height - separator1Label.y
                visible: appWindow.inPortrait

                LabelSeparator {
                    id: separator1Label

                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.left: parent.left
                    text: "G-sensor"
                }

                Label {
                    id: gsensorX

                    anchors.left: parent.left
                    anchors.top: separator1Label.bottom
                    anchors.topMargin: 10
                    color: _TEXT_COLOR
                    text: "X axis"
                }
                Line {
                    id: gsensorXline

                    height: gsensorX.height
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: gsensorX.right
                    anchors.leftMargin: 40
                    anchors.verticalCenter: gsensorX.verticalCenter

                    type: 1
                    value: 5

                    Behavior on value { PropertyAnimation { duration: 500; easing.type: Easing.Linear; } }
                }

                Label {
                    id: gsensorY
                    anchors.left: parent.left
                    anchors.top: gsensorX.bottom
                    anchors.topMargin: 10
                    color: _TEXT_COLOR
                    text: "Y axis"
                }
                Line {
                    id: gsensorYline
                    height: gsensorY.height
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: gsensorY.right
                    anchors.leftMargin: 41
                    anchors.verticalCenter: gsensorY.verticalCenter

                    type: 2
                    value: 5

                    Behavior on value { PropertyAnimation { duration: 500; easing.type: Easing.Linear; } }
                }

                Label {
                    id: gsensorZ
                    anchors.left: parent.left
                    anchors.top: gsensorY.bottom
                    anchors.topMargin: 10
                    color: _TEXT_COLOR
                    text: "Z axis"
                }
                Line {
                    id: gsensorZline
                    height: gsensorZ.height
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: gsensorZ.right
                    anchors.leftMargin: 41
                    anchors.verticalCenter: gsensorZ.verticalCenter

                    type: 3
                    value: 5

                    Behavior on value { PropertyAnimation { duration: 500; easing.type: Easing.Linear; } }
                }

                LabelSeparator {
                    id: separator2Label
                    anchors.top: gsensorZ.bottom
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    text: "Chart"
                }

                Rectangle {
                    id: hiddenRectGsensor
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: separator2Label.bottom
                    anchors.topMargin: 10
                    opacity: 0
                }

                Flickable {
                    id: gsensorFlickable
                    anchors.left: hiddenRectGsensor.left
                    anchors.top: hiddenRectGsensor.top
                    height: 200
                    width: 460

                    contentHeight: gsensorChart.height
                    contentWidth: gsensorChart.width
                    interactive: false

                    Chart {
                        id: gsensorChart
                        height: 200
                        width: 460

                        property bool ready: false

                        smooth: true
                    }
                }
            }

            ScrollDecorator {
                flickableItem: flicker2
            }
        }
    }

    GeoCoder {
        id:reverseGeoCode

        function updateStreetInfo(postCode, streetadd, cityname, countryName) {
            cityLabel.text = "City: " + cityname;
            streetLabel.text = "Street: " + streetadd;
        }

        onReverseGeocodeInfoRetrieved: updateStreetInfo(postCode, streetadd, cityname, countryName)
    }

    /*!
     * Displaying all available system information pages, they can be swiped to navigate
     * from one page to another.
     * Such functionality implemented with PathView element.
     */
    PathView {
        id: view
        anchors { margins: 10; top: pageIndicator.bottom; left: parent.left;
            right: parent.right; bottom: toolBar.top; }
        model: itemModel
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange
        clip: true
        visible: appWindow.inPortrait

        //! Jump to the page that was clicked
        currentIndex: 0

        //! Put high number for flickDeceleration to make sure, that swiping only one page at time
        flickDeceleration: 500000

        path: Path {
            startX: - nowPlayingPage.width * itemModel.count / 2 + nowPlayingPage.width / 2
            startY: pageHeight / 2
            PathLine {
                x: nowPlayingPage.width * itemModel.count / 2 + nowPlayingPage.width / 2
                y: pageHeight / 2
            }
        }
    }

    //! Page indicator shows total number of pages and highlight icon for selected page
    Item {
        id: pageIndicator

        width: parent.width
        height: 40
        anchors.top: videoPlayer.bottom

        visible: appWindow.inPortrait

        //! Page indicator icons placed horizontally in a row
        Row {
            anchors.centerIn: parent
            spacing: 5

            Repeater {
                model: itemModel.count
                delegate: Image {
                    source: view.currentIndex === index ? "image://theme/icon-s-current-page"
                                                        : "image://theme/icon-s-unselected-page"
                }
            }
        }
    }

    DocumentGalleryItem {
        id: video

        function getFileSize() {
            var mb = Math.abs(video.metaData.fileSize / 1000000).toString();
            return mb.slice(0, mb.indexOf(".") + 2) + "MB";
        }
        properties: ["title", "fileName", "duration", "fileSize", "fileExtension", "playCount", "lastModified", "url", "resumePosition"]
    }

    DocumentGalleryModel {
        id: videoModel

        function getVideo(filePath) {
            videoFilter.value = filePath;
        }

        rootType: DocumentGallery.Video
        filter: GalleryEqualsFilter {
            id: videoFilter

            property: "filePath"
            value: ""
        }
        onStatusChanged: if ((videoModel.status == DocumentGalleryModel.Finished) && (videoModel.count > 0)) video.item = videoModel.get(0).itemId;
    }
}
