import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    showToolBar: false

    property int _SMALL_FONT_SIZE: 18
    property int _STANDARD_FONT_SIZE: 24
    property int _LARGE_FONT_SIZE: 40
    property string _TEXT_COLOR: theme.inverted ? "white" : "black"
    property string _ICON_LOCATION: "/usr/share/themes/blanco/meegotouch/icons/"
    property string _ACTIVE_COLOR: "color11"

    platformStyle: PageStackWindowStyle {
            background: "qrc:/icons/background.png"
            backgroundFillMode: Image.Tile
        }


    ViewfinderPage { id: viewfinderPage }
    MainPage { id: mainPage }
    SettingsPage { id: settingsPage }
    VideoListPage { id: videoListPage }
    AboutDialog { id: aboutDialog }
    NowPlayingPage { id: nowPlayingPage }
    VideoPlaybackPage { id: videoPlaybackPage }

    Component.onCompleted: {
        theme.inverted = true
       // theme.color = 8
    }

    ToolBarLayout {
        id: commonTools

        visible: false
        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                if (pageStack.currentPage == viewfinderPage)
                    viewfinderPage.unloadCamera()
                pageStack.pop()
                hideToolbar()
            }
        }
        ToolIcon { platformIconId: "toolbar-tag";
            anchors.right: parent.right
            onClicked: {
                aboutDialog.open()
            }
        }
    }
/*
    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: "Sample menu item" }
        }
    }
*/

    function showToolbar()
    {
        appWindow.showToolBar = true
        commonTools.visible = true
    }

    function hideToolbar()
    {
        appWindow.showToolBar = false
        commonTools.visible = false
    }

    function playVideos(video) {
        videoPlaybackPage.setPlaylist(video)
        videoPlaybackPage.startPlayback()
        pageStack.push(videoPlaybackPage)
    }
}
