import QtQuick 1.0
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import QtMobility.gallery 1.1
import QtMobility.location 1.2
import "scripts/utils.js" as Utils

Page {
    id: nowPlayingPage
    state: "smallVideo"

    property variant currentVideo: []
    property int playlistPosition: 0
    property bool videoPaused: videoPlayer.paused
    property bool videoStopped: !videoPlayer.playing

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
    }

    function exitNowPlaying() {
        appWindow.pageStack.pop();
        video.metaData.resumePosition = Math.floor(videoPlayer.position / 1000);
    }

    function stopPlayback() {
        video.metaData.resumePosition = Math.floor(videoPlayer.position / 1000);
        videoPlayer.stop();
        videoPlayer.source = "";
        currentVideo = [];
        appWindow.pageStack.pop();
    }

    orientationLock: PageOrientation.LockLandscape

    ToolBar {
        id: toolBar

        property bool show: true

        z: 10
        anchors { left: parent.left; right: parent.right; top: parent.bottom }
        //visible: !appWindow.inPortrait
        platformStyle: ToolBarStyle {
            inverted: true
           // background: Qt.resolvedUrl("images/toolbar-background-double.png")
        }

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
                onClicked: exitNowPlaying()
            }

            ToolIcon {
                id: playButton
                anchors { left: stopButton.right }
                platformIconId: videoPlayer.paused ? "toolbar-mediacontrol-play" : "toolbar-mediacontrol-pause"
                onClicked: videoPlayer.setToPaused = !videoPlayer.setToPaused
            }

            NewProgressBar {
                id: progressBar

                width: 520
                anchors { left: playButton.right; topMargin: 20; leftMargin: 40 }
                indeterminate: (videoPlayer.status == Video.Buffering) || (videoPlayer.status == Video.Loading)
                minimumValue: 0
                maximumValue: 100
                value: (appWindow.videoPlaying) && ((appWindow.inPortrait) || (toolBar.show)) ? Math.floor((videoPlayer.position / videoPlayer.duration) * 100) : 0

                Label {
                    anchors { top: parent.bottom; horizontalCenter: parent.left }
                    font.pixelSize: _SMALL_FONT_SIZE
                    color: !appWindow.inPortrait ? "white" : _TEXT_COLOR
                    text: (!appWindow.videoPlaying) || !((appWindow.inPortrait) || (toolBar.show)) || (videoPlayer.status == Video.Loading) || (videoPlayer.status == Video.Buffering) ? "0:00" : Utils.getTime(videoPlayer.position)
                }

                Label {
                    anchors { top: parent.bottom; horizontalCenter: parent.right }
                    font.pixelSize: _SMALL_FONT_SIZE
                    color: !appWindow.inPortrait ? "white" : _TEXT_COLOR
                    text: (appWindow.videoPlaying) && ((appWindow.inPortrait) || (toolBar.show)) ? Utils.getTime(videoPlayer.duration) : "0:00"
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
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: controlsTimer

        running: (toolBar.show) && (!seekMouseArea.pressed)
        interval: 3000
      //  onTriggered: toolBar.show = false
    }

    Timer {
        id: archivePlaybackTimer

        /* Prevents segfault when switching between videos */

        interval: 1000
        onTriggered: videoPlayer.setVideo(currentVideo.url)
    }

    Video {
        id: videoPlayer
        x: 10
        y: 10

        property bool repeat: false // True if playback of the current video is to be repeated
        property bool setToPaused: false

        function setVideo(videoUrl) {
            videoPlayer.source = decodeURIComponent(videoUrl);
            videoPlayer.play();
        }

       // width: !appWindow.inPortrait ? 854 : 480
        //height: !appWindow.inPortrait ? 480 : 360
        width: 460
        height: parent.height - 20 - toolBar.height
        fillMode: Video.PreserveAspectFit
        //anchors { centerIn: parent; verticalCenterOffset: appWindow.inPortrait ? -130 : 0 }
        paused: ((platformWindow.viewMode == WindowState.Thumbnail) && ((videoPlayer.playing)) || ((appWindow.pageStack.currentPage != videoPlaybackPage) && (videoPlayer.playing)) || (videoPlayer.setToPaused))
        onError: {
        }
        onStatusChanged: {
            if (videoPlayer.status == Video.EndOfMedia) {
                video.metaData.playCount++;
                video.metaData.resumePosition = 0;
                videoPlayer.position = 0;
                videoPlayer.play();

            }
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

    Map {
        id: map
        x: 480
        y: 490
        width: parent.width - 10
        height: parent.height - 20 - toolBar.height
        plugin : Plugin { name: "nokia" }
        zoomLevel: 10
    }

    Rectangle {
        id: details
        x: 480
        y: 10
        width: parent.width - 10
        height: parent.height - 20 - toolBar.height
        color: "green"
        opacity: 0
    }

    states: [
        State {
            name: "videoFullscreen"
            PropertyChanges {
                target: videoPlayer
                x: 10
                y: 10
                width: nowPlayingPage.width - 10
                height: nowPlayingPage.height - 20
            }
            PropertyChanges {
                target: map
                x: 860
            }
            PropertyChanges {
                target: details
                x: 860
            }
        },
        State {
            name: "videoSmall"
            PropertyChanges {
                target: videoPlayer
                x: 10
                y: 10
                width: 460
                height: nowPlayingPage.height - 20
            }
            PropertyChanges {
                target: map
                x: 480
            }
            PropertyChanges {
                target: details
                x: 480
            }
        },
        State {
            name: "showDetails"
            PropertyChanges {
                target: details
                x: 480
                y: 10
                height: nowPlayingPage.height - 20
            }
            PropertyChanges {
                target: map
                x: 480
                y: 490
                height: nowPlayingPage.height - 20
            }
        },
        State {
            name: "showMap"
            PropertyChanges {
                target: map
                x: 480
                y: 10
                height: nowPlayingPage.height - 20
            }
            PropertyChanges {
                target: details
                x: 480
                y: 490
                height: nowPlayingPage.height - 20
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
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }


}
