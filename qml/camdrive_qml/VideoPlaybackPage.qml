import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: videoPlaybackPage

    property bool hideTitle: true
    property bool videoDisplayed: tabGroup.currentTab == nowPlayingPage
    property bool videoPaused: nowPlayingPage.videoPaused
    property bool videoStopped: nowPlayingPage.videoStopped
    property alias currentVideo: nowPlayingPage.currentVideo
    property int playlistPosition: nowPlayingPage.playlistPosition
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

    function displayVideo() {
        tabGroup.currentTab = nowPlayingPage;
    }

    function displayQueue() {
        tabGroup.currentTab = queuePage;
    }

    Menu {
        id: queueMenu1

        MenuLayout {
            MenuItem {
                text: qsTr("Select all")
                onClicked: queuePage.selectAll()
            }
        }
    }

    Menu {
        id: queueMenu2

        MenuLayout {
            MenuItem {
                text: qsTr("Select none")
                onClicked: queuePage.selectNone()
            }
            MenuItem {
                text: qsTr("Remove")
                onClicked: queuePage.remove()
            }
        }
    }

    TabGroup {
        id: tabGroup
        currentTab: nowPlayingPage

        NowPlayingPage {
            id: nowPlayingPage
        }

    }
}
