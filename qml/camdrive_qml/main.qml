import QtQuick 1.1
import com.nokia.meego 1.0
import "Settings"
import "Common"
import "Viewfinder"
import "scripts/utils.js" as UtilsScript

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    showToolBar: false
    showStatusBar: false

    property int _SMALL_FONT_SIZE: 18
    property int _STANDARD_FONT_SIZE: 24
    property int _LARGE_FONT_SIZE: 40
    property int _MARGIN: 20
    property string _TEXT_COLOR: theme.inverted ? "white" : "black"
    property string _ICON_LOCATION: "/usr/share/themes/blanco/meegotouch/icons/"
    property string _ACTIVE_COLOR: "color11"
    property string _ACTIVE_COLOR_TEXT: "#8D18BE"
    property string _APP_VERSION: "0.1.10-pre6"

    platformStyle: PageStackWindowStyle {
            background: appWindow.inPortrait ? "qrc:/icons/background-portrait.png" : "qrc:/icons/background.png"
            backgroundFillMode: Image.Tile
        }


    ViewfinderPage { id: viewfinderPage }
    MainPage { id: mainPage }
    //SettingsPage2 { id: settingsPage }
    //VideoListPage { id: videoListPage }
   // NowPlayingPage { id: nowPlayingPage }
    //VideoPlaybackPage { id: videoPlaybackPage }

    Component.onCompleted: {
        theme.inverted = true;
        Database.openDatabase();
        Database.createTables();
    }

    MessageHandler {
        id: messageHandler
    }

    Connections {
        target: Utils
        onInformation: messageHandler.showMessage(message);
        //onVideoDeleted: deleteVideo(path);
    }

    function showToolbar()
    {
        appWindow.showToolBar = true
    }

    function hideToolbar()
    {
        appWindow.showToolBar = false
    }

    function playVideos(video) {
        console.log('MAIN playVideos')
        console.log('MAIN playlist '. video)

        if (video === undefined) {
            console.log('video undefined');
            return;
        }

        var videoPlaybackPage = UtilsScript.createObject(Qt.resolvedUrl("VideoPlaybackPage.qml"), appWindow.pageStack);
        videoPlaybackPage.setPlaylist(video)
        videoPlaybackPage.startPlayback()
        pageStack.push(videoPlaybackPage)
    }
}
