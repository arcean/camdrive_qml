import QtQuick 1.0
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import QtMobility.gallery 1.1
import QtMobility.location 1.2
import "scripts/utils.js" as Utils

Page {
    id: nowPlayingPage
    state: "smallVideo"
    property bool videoPlaying: false

    property variant currentVideo: []
    property int playlistPosition: 0
    property bool videoPaused: videoPlayer.paused
    property bool videoStopped: !videoPlayer.playing
    property int videoInfoIterator: 1

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
        videoInfoIterator = 1;
        setSpeed(DatabaseHelper.getVideoInfoSpeedQML(videoPlayer.source, videoInfoIterator));
        setLatitude(DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, videoInfoIterator));
        setLongitude(DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, videoInfoIterator));
        videoInfoIterator++;
        videoInfoTimer.restart();
    }

    function startPlayback() {
        if (currentVideo.itemId) {
            video.item = currentVideo.itemId;
        }
        else {
            videoModel.getVideo(currentVideo.filePath);
        }
        videoPlayer.stop();
        videoPlayer.source = "";
        archivePlaybackTimer.restart();
        state = "showMap";
    }

    function stopPlayback() {
        video.metaData.resumePosition = Math.floor(videoPlayer.position / 1000);
        videoPlayer.stop();
        videoPlaying = false;
        videoPlayer.source = "";
        currentVideo = [];
        videoInfoTimer.stop();
        appWindow.pageStack.pop();
    }

    /* Sets speedLabel's text. */
    function setSpeed(value)
    {
        speedLabel.text = value + " km\h";
        actualSpeedLabel.text = value + " km\h";
    }

    Coordinate {
        id: ourCoord
        latitude: 56.62
        longitude: 16.16
    }

    /* Sets longitudeLabel's text and position on the map. */
    function setLongitude(value)
    {
        if (value == 0)
            return;

        var loc;

        if (value > 0)
            loc = " E";
        else
            loc = " W";

        ourCoord.longitude = value;
        longitudeLabel.text = value + loc;
    }

    /* Sets latitudeLabel's text and position on the map. */
    function setLatitude(value)
    {
        if (value == 0)
            return;

        var loc;

        if (value > 0)
            loc = " N";
        else
            loc = " S";

        ourCoord.latitude = value;
        latitudeLabel.text = value + loc;
    }

    ToolBar {
        id: toolBar
        z: 10
        anchors { left: parent.left; right: parent.right; top: parent.bottom }

        property bool show: true

        states: State {
            name: "show"
            when: toolBar.show
            AnchorChanges { target: toolBar; anchors { top: undefined; bottom: parent.bottom } }
        }

        transitions: Transition {
            AnchorAnimation { easing.type: Easing.OutQuart; duration: 300 }
        }

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
                anchors { left: stopButton.right }
                platformIconId: videoPlayer.paused ? "toolbar-mediacontrol-play" : "toolbar-mediacontrol-pause"
                onClicked: videoPlayer.setToPaused = !videoPlayer.setToPaused
            }
            ToolIcon {
                id: animStart2
                anchors.right: animStart.left
                platformIconId: "toolbar-view-menu"
                onClicked: {
                    if(nowPlayingPage.state == "showSmall" || nowPlayingPage.state == "showMap") {
                        nowPlayingPage.state = "showDetails"
                    }
                    else
                        nowPlayingPage.state = "showMap"
                }
            }
            ToolIcon {
                id: animStart
                anchors.right: parent.right
                platformIconId: "toolbar-view-menu"
                onClicked: {
                    if(nowPlayingPage.state == "videoFullscreen") {
                        nowPlayingPage.state = "videoSmall"
                    }
                    else
                        nowPlayingPage.state = "videoFullscreen"
                }
            }

            NewProgressBar {
                id: progressBar

                anchors { left: playButton.right; topMargin: 20; leftMargin: 40; right: animStart2.left; rightMargin: 40 }
                indeterminate: (videoPlayer.status == Video.Buffering) || (videoPlayer.status == Video.Loading)
                minimumValue: 0
                maximumValue: 100
                value: (nowPlayingPage.videoPlaying) ? Math.floor((videoPlayer.position / videoPlayer.duration) * 100) : 0

                Label {
                    anchors { top: parent.bottom; horizontalCenter: parent.left }
                    font.pixelSize: _SMALL_FONT_SIZE
                    color: _TEXT_COLOR
                    text: (!nowPlayingPage.videoPlaying) || (videoPlayer.status == Video.Loading) || (videoPlayer.status == Video.Buffering) ? "0:00" : Utils.getTime(videoPlayer.position)
                }

                Label {
                    anchors { top: parent.bottom; horizontalCenter: parent.right }
                    font.pixelSize: _SMALL_FONT_SIZE
                    color: _TEXT_COLOR
                    text: (nowPlayingPage.videoPlaying) ? Utils.getTime(videoPlayer.duration) : "0:00"
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
                            videoInfoIterator = Math.ceil(videoPlayer.position / (DatabaseHelper.getVideoStoredEachQML(videoPlayer.source) * 1000));
                        }
                    }
                }
            }
        }
    }
/*
    Timer {
        id: controlsTimer

        running: (toolBar.show) && (!seekMouseArea.pressed)
        interval: 3000
        onTriggered: toolBar.show = false
    }*/

    Timer {
        id: archivePlaybackTimer
        /* Prevents segfault when switching between videos */

        interval: 1000
        onTriggered: {
            videoPlayer.setVideo(currentVideo.url);
            startSpeedInfoTimer();
        }
    }

    Timer {
        id: videoInfoTimer
        interval: DatabaseHelper.getVideoStoredEachQML(videoPlayer.source) * 1000
        repeat: true
        running: false

        onTriggered: {
            /*
             * Check if videoPlayer is in paused state.
             * If so, do not update additional video infos.
             */
            if (!videoPlayer.setToPaused) {
                setSpeed(DatabaseHelper.getVideoInfoSpeedQML(videoPlayer.source, videoInfoIterator));
                setLatitude(DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, videoInfoIterator));
                setLongitude(DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, videoInfoIterator));
                videoInfoIterator++;
            }
            else
                videoInfoTimer.stop();
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
        y: 10
        width: 460
        height: nowPlayingPage.height - 20 - toolBar.height
        fillMode: Video.PreserveAspectFit

        property bool repeat: false // True if playback of the current video is to be repeated
        property bool setToPaused: false        

        paused: ((platformWindow.viewMode == WindowState.Thumbnail) && ((videoPlayer.playing)) || ((appWindow.pageStack.currentPage != videoPlaybackPage) && (videoPlayer.playing)) || (videoPlayer.setToPaused))
        onError: {
        }
        onStatusChanged: {
            if (videoPlayer.status == Video.EndOfMedia) {
                video.metaData.playCount++;
                video.metaData.resumePosition = 0;
                videoPlayer.position = 0;
                //videoPlayer.play();
                videoInfoTimer.stop();
                /* Play the video again. */
                startPlayback();
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
            visible: (videoPlayer.status == Video.Loading) || (videoPlayer.status == Video.Buffering)
            running: visible

        }

        Image {
            anchors.centerIn: videoPlayer
            source: videoMouseArea.pressed ? "images/play-button-" + _ACTIVE_COLOR + ".png" : "images/play-button.png"
            visible: (videoPlayer.paused) && (!busyIndicator.visible)
        }

        MouseArea {
            id: videoMouseArea
            anchors.fill: videoPlayer

            onReleased: {
                videoPlayer.setToPaused = !videoPlayer.setToPaused;
            }
        }
    }

    Rectangle {
        id: details
        x: videoPlayer.x + videoPlayer.width + 10
        y: nowPlayingPage.height + 10
        width: nowPlayingPage.width - map.x - 20
        height: nowPlayingPage.height - 20 - toolBar.height
        color: "green"
        opacity: 0       
    }

    Flickable {
        id: flicker

        anchors.fill: details
        contentWidth: width
        contentHeight: column.height + 20

        Column {
            id: column

            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 20 }
            spacing: 10

            Label {
                id: titleText

                width: parent.width
                font.pixelSize: 32
                color: _TEXT_COLOR
                wrapMode: Text.WordWrap
                text: video.available ? video.metaData.fileName.slice(0, video.metaData.fileName.lastIndexOf(".")) : ""
            }

            Column {
                width: parent.width

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Length" + ": " + Utils.getDuration(video.metaData.duration) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Format" + ": " + video.metaData.fileExtension.toUpperCase() : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Size" + ": " + video.getFileSize() : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Added" + ": " + Qt.formatDateTime(video.metaData.lastModified) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Times played" + ": " + video.metaData.playCount : ""
                }

                Label {
                    id: actualSpeedLabel
                    color: _TEXT_COLOR
                    text: "Actual speed: n/a"
                }

                Label {
                    id: longitudeLabel
                    color: _TEXT_COLOR
                    text: "Longitude: n/a"
                }

                Label {
                    id: latitudeLabel
                    color: _TEXT_COLOR
                    text: "Latitude: n/a"
                }
            }
        }
    }

    Map {
        id: map
        x: videoPlayer.x + videoPlayer.width + 10
        y: 10
        width: nowPlayingPage.width - x - 20
        height: nowPlayingPage.height - 20 - toolBar.height
        plugin : Plugin { name: "nokia" }
        zoomLevel: maximumZoomLevel - 2
        center: ourCoord

        MapImage {
            id: mapPlacer
            source: _ICON_LOCATION + "icon-m-common-location-selected.png"
            coordinate: ourCoord

            /*!
             * We want that bottom middle edge of icon points to the location, so using offset parameter
             * to change the on-screen position from coordinate. Values are calculated based on icon size,
             * in our case icon is 48x48.
             */
            offset.x: -24
            offset.y: -48
        }
    }
    //! Map's mouse area for implementation of panning in the map and zoom on double click
    MouseArea {
        id: mousearea
        z: 10

        //! Property used to indicate if panning the map
        property bool __isPanning: false

        //! Last pressed X and Y position
        property int __lastX: -1
        property int __lastY: -1

        anchors.fill: map

        //! When pressed, indicate that panning has been started and update saved X and Y values
        onPressed: {
            __isPanning = true
            __lastX = mouse.x
            __lastY = mouse.y
            console.log("LLLL")
        }

        //! When released, indicate that panning has finished
        onReleased: {
            __isPanning = false
        }

        //! Move the map when panning
        onPositionChanged: {
            if (__isPanning) {
                var dx = mouse.x - __lastX
                var dy = mouse.y - __lastY
                map.pan(-dx, -dy)
                __lastX = mouse.x
                __lastY = mouse.y
            }
        }

        //! When canceled, indicate that panning has finished
        onCanceled: {
            __isPanning = false;
        }

        //! Zoom one level when double clicked
        onDoubleClicked: {
            map.center = map.toCoordinate(Qt.point(__lastX,__lastY))
            map.zoomLevel += 1
        }
    }
    states: [
        State {
            name: "videoFullscreen"
            PropertyChanges {
                target: videoPlayer
                width: nowPlayingPage.width - 20
            }
            PropertyChanges {
                target: map
                y: -10 + map.height * -1
            }
            PropertyChanges {
                target: details
                y: nowPlayingPage.height + 10
            }
        },
        State {
            name: "videoSmall"
            PropertyChanges {
                target: videoPlayer
                width: 460
                height: nowPlayingPage.height - 20 - toolBar.height
            }
            PropertyChanges {
                target: map
                y: -10 + map.height * -1
            }
            PropertyChanges {
                target: details
                y: 10
            }
        },
        State {
            name: "showDetails"
            PropertyChanges {
                target: details
                y: 10
            }
            PropertyChanges {
                target: map
                y: -10 + map.height * -1
            }
        },
        State {
            name: "showMap"
            PropertyChanges {
                target: map
                y: 10
            }
            PropertyChanges {
                target: details
                y: nowPlayingPage.height + 10
            }
        }
    ]

    transitions: [
        Transition {
            to: "videoFullscreen";
            ParallelAnimation {
                NumberAnimation { properties: "x,y,width,height"; duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            from: "videoFullscreen"; to: "videoSmall";
            ParallelAnimation {
                NumberAnimation { properties: "x,y,width,height"; duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            to: "showMap";
            ParallelAnimation {
                NumberAnimation { properties: "x,y,width,height"; duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {
            to: "showDetails";
            ParallelAnimation {
                NumberAnimation { properties: "x,y,width,height"; duration: 500; easing.type: Easing.InOutQuad }
            }
        }
    ]

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

    ScrollDecorator {
        flickableItem: flicker
    }
}
