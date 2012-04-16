import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import QtMobility.gallery 1.1
import QtMobility.location 1.2
import QtMobility.systeminfo 1.2
import GeoCoder 1.0
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
        console.log('setPlaylist DONE')
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
        var latitude = DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, videoInfoIterator);
        var longitude = DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, videoInfoIterator);

        setSpeed(DatabaseHelper.getVideoInfoSpeedQML(videoPlayer.source, videoInfoIterator));
        setLatitude(latitude);
        setLongitude(longitude);
        reverseGeoCode.coordToAddress(latitude, longitude);

        videoInfoIterator++;
        videoInfoTimer.restart();
    }

    function startPlayback() {
        console.log('startPlayback ')
        if (currentVideo.itemId) {
            video.item = currentVideo.itemId;
            console.log('startPlayback IF')
        }
        else {
            videoModel.getVideo(currentVideo.filePath);
            console.log('startPlayback ELSE')
        }
        videoPlayer.stop();
        console.log('startPlayback stop')
        videoPlayer.source = "";
        archivePlaybackTimer.restart();
        console.log('startPlayback DONE')
        //state = "showMap";
    }

    function stopPlayback() {
        video.metaData.resumePosition = Math.floor(videoPlayer.position / 1000);
        videoPlayer.stop();
        console.log('stopPlayback stop')
        videoPlaying = false;
        videoPlayer.source = "";
        currentVideo = [];
        console.log('stopPlayback stop 2')
        videoInfoTimer.stop();
        appWindow.pageStack.pop();
    }

    /* Sets speedLabel's text. */
    function setSpeed(value)
    {
        speedLabel.text = "Speed: " + value + " km\h";
        actualSpeedLabel.text = "Actual speed: " + value + " km\h";
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
        longitudeLabel.text = "Longitude: " + value.toFixed(2) + loc;
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
        latitudeLabel.text = "Latitude: " + value.toFixed(2) + loc;
    }

    Keys.onPressed: {
        if (!event.isAutoRepeat) {
            switch (event.key) {
            case Qt.Key_Right:
                videoPlayer.position = videoPlayer.position + 10000;
                videoInfoIterator = Math.ceil(videoPlayer.position / (DatabaseHelper.getVideoStoredEachQML(videoPlayer.source) * 1000));
                event.accepted = true;
                break;
            case Qt.Key_Left:
                videoPlayer.position = videoPlayer.position - 10000;
                videoInfoIterator = Math.ceil(videoPlayer.position / (DatabaseHelper.getVideoStoredEachQML(videoPlayer.source) * 1000));
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
                anchors {
                    left: (nowPlayingPage.width > nowPlayingPage.height) ? stopButton.right : undefined;
                    centerIn: (nowPlayingPage.width > nowPlayingPage.height) ? undefined : layout;
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
                    left: (nowPlayingPage.width > nowPlayingPage.height) ? playButton.right : parent.right;
                    topMargin: 20;
                    leftMargin: 40;
                    right: parent.right;
                    rightMargin: 40
                }
                indeterminate: (videoPlayer.status == Video.Buffering) || ((videoPlayer.status == Video.Loading) && !videoPlayer.setToPaused)
                minimumValue: 0
                maximumValue: 100
                value: (nowPlayingPage.videoPlaying) ? Math.floor((videoPlayer.position / videoPlayer.duration) * 100) : 0
                visible: nowPlayingPage.width > nowPlayingPage.height

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
            console.log('archivePlaybackTimer setVideo')
            videoPlayer.setVideo(currentVideo.url);
            console.log('archivePlaybackTimer setVideo DONE')
            startSpeedInfoTimer();
            mapPlacer.visible = true;
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
                var latitude = DatabaseHelper.getVideoInfoLatitudeQML(videoPlayer.source, videoInfoIterator);
                var longitude = DatabaseHelper.getVideoInfoLongitudeQML(videoPlayer.source, videoInfoIterator);
                setSpeed(DatabaseHelper.getVideoInfoSpeedQML(videoPlayer.source, videoInfoIterator));
                setLatitude(latitude);
                setLongitude(longitude);
                reverseGeoCode.coordToAddress(latitude, longitude);
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
        y: (nowPlayingPage.height > nowPlayingPage.width) ? 20 : 10
        width: (nowPlayingPage.height > nowPlayingPage.width) ? 460 : 844
        height: (nowPlayingPage.height > nowPlayingPage.width) ? 300 : (nowPlayingPage.height - 20 - toolBar.height)
        fillMode: Video.PreserveAspectFit

        property bool repeat: false // True if playback of the current video is to be repeated
        property bool setToPaused: false

        paused: ((platformWindow.viewMode == WindowState.Thumbnail) && ((videoPlayer.playing)) || ((appWindow.pageStack.currentPage != videoPlaybackPage) && (videoPlayer.playing)) || (videoPlayer.setToPaused))
        onError: {
        }
        onStatusChanged: {
            if (videoPlayer.status == Video.EndOfMedia) {
                //video.metaData.playCount++;
                //video.metaData.resumePosition = 0;
                videoPlayer.stop();
                //videoPlayer.position = 0;
                //videoPlayer.play();
                videoInfoTimer.stop();
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

    //! Model containing system information pages
    VisualItemModel {
        id: itemModel

        //! Page displaying map
        Item {
            width: nowPlayingPage.width; height: pageHeight

            Map {
                id: map
                width: 460
                height: 400
                plugin : Plugin { name: "nokia" }
                zoomLevel: maximumZoomLevel - 4
                center: ourCoord
                visible: nowPlayingPage.height > nowPlayingPage.width

                MapImage {
                    id: mapPlacer
                    source: _ICON_LOCATION + "icon-m-common-location-selected.png"
                    coordinate: ourCoord
                    visible: false

                    /*!
                     * We want that bottom middle edge of icon points to the location, so using offset parameter
                     * to change the on-screen position from coordinate. Values are calculated based on icon size,
                     * in our case icon is 48x48.
                     */
                    offset.x: -24
                    offset.y: -48
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

            Rectangle {
                id: details
                anchors.fill: parent
                color: "green"
                opacity: 0
                visible: nowPlayingPage.height > nowPlayingPage.width
            }
            Flickable {
                id: flicker

                anchors.fill: details
                contentWidth: width
                contentHeight: column.height + 20
                visible: nowPlayingPage.height > nowPlayingPage.width

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
                        text: video.available ? video.metaData.fileName.slice(0, video.metaData.fileName.lastIndexOf(".")) : ""
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
                            text: video.available ? "Created" + ": " + Qt.formatDateTime(video.metaData.lastModified) : ""
                        }
                    }

                    Separator {
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: 10
                            rightMargin: 10
                        }
                    }

                    Column {
                        id: column2
                        width: parent.width

                        Label {
                            id: cityLabel
                            color: _TEXT_COLOR
                            text: "City: n/a"
                        }

                        Label {
                            id: streetLabel
                            color: _TEXT_COLOR
                            text: "Street: n/a"
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

            ScrollDecorator {
                flickableItem: flicker
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
        visible: nowPlayingPage.height > nowPlayingPage.width

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

        visible: nowPlayingPage.height > nowPlayingPage.width

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
