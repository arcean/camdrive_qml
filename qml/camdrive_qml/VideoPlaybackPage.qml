import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: videoPlaybackPage

    property bool videoPaused: nowPlayingPage.videoPaused
    property bool videoStopped: nowPlayingPage.videoStopped
    property alias currentVideo: nowPlayingPage.currentVideo
    orientationLock: PageOrientation.LockLandscape

    function setPlaylist(videoList) {
        nowPlayingPage.setPlaylist(videoList);
    }

    function appendPlaylist(videoList) {
        nowPlayingPage.appendPlaylist(videoList);
    }

    function startPlayback() {
        nowPlayingPage.startPlayback();
    }

    TabGroup {
        id: tabGroup
        currentTab: nowPlayingPage

        NowPlayingPage {
            id: nowPlayingPage
        }
    }
}
