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

    orientationLock: PageOrientation.LockLandscape

    ButtonRow {
        id: tabBar

        anchors { top: parent.top; left: parent.left; right: parent.right }
        visible: (appWindow.inPortrait) || (tabGroup.currentTab != nowPlayingPage)
        style: TabButtonStyle {}

        TabButton {
            id: infoButton

            text: qsTr("Now Playing")
            tab: nowPlayingPage
        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: nowPlayingPage.exitNowPlaying()
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: queuePage.openOrCloseMenu()
            opacity: enabled ? 1 : 0.3
        }
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
