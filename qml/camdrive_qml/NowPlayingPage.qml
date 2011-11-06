import QtQuick 1.0
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import QtMobility.gallery 1.1
import "scripts/utils.js" as Utils

Page {
    id: nowPlayingPage

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

    function previous() {
        /* Play the previous item in the playlist */

        if (playlistPosition > 0) {
            playlistPosition--;
            getNextVideo();
        }
    }

    function next() {
        /* Play the next item in the playlist */

        if (playlistPosition < (playbackQueue.count - 1)) {
            playlistPosition++;
            getNextVideo();
        }
        else if (appWindow.videoPlaying) {
            appWindow.pageStack.pop();
        }
    }

    function getNextVideo() {
        if (playlistPosition < playbackQueue.count) {
            currentVideo = playbackQueue.get(playlistPosition);
            startPlayback();
        }
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

    function showCurrentVideoDetails() {
        var detailsPage = Utils.createObject(Qt.resolvedUrl("VideoDetailsPage.qml"), appWindow.pageStack);
        detailsPage.id = video.item;
        detailsPage.allowToPlay = false;
        appWindow.pageStack.push(detailsPage);
    }

    function getSubtitles() {
        subsGetter.sendMessage(currentVideo.url);
    }

    function setSubtitles(subtitles) {
        if (subtitles.length > 0) {
            var cv = currentVideo;
            cv["subtitles"] = subtitles;
            currentVideo = cv;
        }
    }

    function checkSubtitles() {
        subsChecker.sendMessage({"position": videoPlayer.position, "subtitles": currentVideo.subtitles})
    }

    orientationLock: PageOrientation.LockLandscape

    ToolBar {
        id: toolBar

        property bool show: false

        z: 10
        anchors { left: parent.left; right: parent.right; top: parent.bottom }
        visible: !appWindow.inPortrait
        platformStyle: ToolBarStyle {
            inverted: true
            background: Qt.resolvedUrl("images/toolbar-background-double.png")
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

            NewProgressBar {
                id: progressBar

                width: 620
                anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 20 }
                inverted: (!appWindow.inPortrait) || (theme.inverted)
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

            ToolIcon {
                id: stopButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; left: parent.left }
                iconSource: _ICON_LOCATION + "icon-m-toolbar-back-white.png"
                onClicked: exitNowPlaying()
            }

            ToolIcon {
                id: previousButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; left: stopButton.right }
                iconSource: _ICON_LOCATION + "icon-m-toolbar-mediacontrol-previous-white.png"
                enabled: playlistPosition > 0
                onClicked: previous()
            }

            ToolIcon {
                id: backwardsButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; left: previousButton.right }
                iconSource: _ICON_LOCATION + "icon-m-toolbar-mediacontrol-backwards-white.png"
                onClicked: videoPlayer.position -= 10
                enabled: videoPlayer.position > 10
            }

            ToolIcon {
                id: playButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; left: backwardsButton.right }
                iconSource: videoPlayer.paused ? _ICON_LOCATION + "icon-m-toolbar-mediacontrol-play-white.png" : _ICON_LOCATION + "icon-m-toolbar-mediacontrol-pause-white.png"
                onClicked: videoPlayer.setToPaused = !videoPlayer.setToPaused
            }

            ToolIcon {
                id: forwardButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; left: playButton.right }
                iconSource: _ICON_LOCATION + "icon-m-toolbar-mediacontrol-forward-white.png"
                onClicked: videoPlayer.position += 10
                enabled: videoPlayer.position < (videoPlayer.duration - 10)
            }

            ToolIcon {
                id: nextButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; left: forwardButton.right }
                iconSource: _ICON_LOCATION + "icon-m-toolbar-mediacontrol-next-white.png"
                onClicked: next()
            }

            ToolIcon {
                id: queueButton

                width: layout.itemWidth
                anchors { bottom: parent.bottom; right: parent.right }
                iconSource: _ICON_LOCATION + "icon-m-toolbar-list-white.png"
                onClicked: queueDialog.open()
            }
        }
    }

    Timer {
        id: controlsTimer

        running: (toolBar.show) && (!seekMouseArea.pressed)
        interval: 3000
        onTriggered: toolBar.show = false
    }

    Timer {
        id: archivePlaybackTimer

        /* Prevents segfault when switching between videos */

        interval: 1000
        onTriggered: videoPlayer.setVideo(currentVideo.url)
    }

    Video {
        id: videoPlayer

        property bool repeat: false // True if playback of the current video is to be repeated
        property bool setToPaused: false

        function setVideo(videoUrl) {
            videoPlayer.source = decodeURIComponent(videoUrl);
            videoPlayer.play();
        }

        width: !appWindow.inPortrait ? 854 : 480
        height: !appWindow.inPortrait ? 480 : 360
        fillMode: Video.PreserveAspectFit
        anchors { centerIn: parent; verticalCenterOffset: appWindow.inPortrait ? -130 : 0 }
        paused: ((platformWindow.viewMode == WindowState.Thumbnail) && ((videoPlayer.playing)) || ((appWindow.pageStack.currentPage != videoPlaybackPage) && (videoPlayer.playing)) || (videoPlayer.setToPaused))
        onError: {
        }
        onStatusChanged: {
            if (videoPlayer.status == Video.EndOfMedia) {
                video.metaData.playCount++;
                video.metaData.resumePosition = 0;
                if (videoPlayer.repeat) {
                    videoPlayer.position = 0;
                    videoPlayer.play();
                }
                else {
                    next();
                }
            }
        }

        Image {
            z: 100
            anchors { top: parent.top; right: parent.right; margins: 10 }
            source: _ICON_LOCATION + "icon-s-music-video-description.png"
            opacity: !toolBar.show ? 0 : infoMouseArea.pressed ? 0.5 : 1
            visible: !appWindow.inPortrait

            Behavior on opacity { PropertyAnimation { properties: "opacity"; duration: 300 } }

            MouseArea {
                id: infoMouseArea

                width: 60
                height: 60
                anchors.centerIn: parent
                enabled: toolBar.show
                onClicked: showCurrentVideoDetails()
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
            anchors.centerIn: parent
            source: videoMouseArea.pressed ? "images/play-button-" + _ACTIVE_COLOR + ".png" : "images/play-button.png"
            visible: (videoPlayer.paused) && (!busyIndicator.visible)
        }

        MouseArea {
            id: videoMouseArea

            property int xPos

            anchors.fill: videoPlayer
            onPressed: xPos = mouseX
            onReleased: {
                if (((xPos - mouseX) > 100) && (playlistPosition < playbackQueue.count - 1)) {
                    next();
                }
                else if ((mouseX - xPos) > 100) {
                    previous();
                }
                else if (!((appWindow.inPortrait) || (videoPlayer.setToPaused))) {
                    toolBar.show = !toolBar.show;
                }
                else {
                    videoPlayer.setToPaused = !videoPlayer.setToPaused;
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

    Flickable {
        id: scrollArea

        anchors { left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: videoPlayer.bottom; topMargin: 80; bottom: parent.bottom }
        clip: true
        contentWidth: width
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.DragOverBounds
        visible: appWindow.inPortrait
        contentHeight: column.height + 20

        Column {
            id: column

            anchors { top: parent.top; left: parent.left; right: parent.right }
            spacing: 10

            Image {
                id: thumb

                width: 160
                height: 90
                source: video.available ? "file:///home/user/.thumbnails/video-grid/" + Qt.md5(video.metaData.url) + ".jpeg" : ""
                smooth: true
                onStatusChanged: if (thumb.status == Image.Error) thumb.source = "image://theme/meegotouch-video-placeholder";
            }

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
                    text: video.available ? qsTr("Length") + ": " + Utils.getDuration(video.metaData.duration) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? qsTr("Format") + ": " + video.metaData.fileExtension.toUpperCase() : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? qsTr("Size") + ": " + video.getFileSize() : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? qsTr("Added") + ": " + Qt.formatDateTime(video.metaData.lastModified) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? qsTr("Times played") + ": " + video.metaData.playCount : ""
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: scrollArea
        visible: scrollArea.visible
    }

    states: State {
        name: "portrait"
        when: appWindow.inPortrait
        ParentChange { target: progressBar; parent: page }
        AnchorChanges { target: progressBar; anchors.top: videoPlayer.bottom  }
        PropertyChanges { target: progressBar; width: parent.width - 60; anchors.topMargin: 20 }
    }
}
