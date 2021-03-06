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

    // Base:
    property string _APP_NAME: "CamDrive"
    property string _APP_VERSION: "1.0.3"
    // Theme:
    property string _TEXT_COLOR: theme.inverted ? "white" : "black"
    property string _ACTIVE_COLOR: "color11"
    property string _ACTIVE_COLOR_TEXT: "#8D18BE"
    property string _DISABLED_COLOR_TEXT: "#cccccc"
    property string _ICON_LOCATION: "/usr/share/themes/blanco/meegotouch/icons/"
    // Font size:
    property int _SMALL_FONT_SIZE: 18
    property int _STANDARD_FONT_SIZE: 24
    property int _HEADER_FONT_SIZE: 32
    property int _LARGE_FONT_SIZE: 40
    // Margins:
    property int _MARGIN: 16
    property int _MARGIN_SWITCH: 24

    property alias _IN_PORTRAIT: appWindow.inPortrait

    //! Prevent opening multiple NowPlaying pages
    property bool isNowPlayingPageActive: false

    platformStyle: PageStackWindowStyle {
            id: appStyle
            background: appWindow.inPortrait ? "qrc:/icons/background-portrait.png" : "qrc:/icons/background.png"
            backgroundFillMode: Image.Tile
        }

    ViewfinderPage { id: viewfinderPage }
    MainPage { id: mainPage }
    //SettingsPage2 { id: settingsPage }
    //VideoListPage { id: videoListPage }
    //NowPlayingPage { id: nowPlayingPage }
    //VideoPlaybackPage { id: videoPlaybackPage }

    Component.onCompleted: {
        theme.inverted = true;
        //! TODO: Available only in PR 1.2 and later:
        // theme.colorScheme = 11;
        Database.openDatabase();
        Database.createTables();
    }

    MessageHandler {
        id: messageHandler
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
        var videoPlaybackPage = UtilsScript.createObject(Qt.resolvedUrl("VideoPlaybackPage.qml"), appWindow.pageStack);
        isNowPlayingPageActive = true;
        videoPlaybackPage.setPlaylist(video)
        //videoPlaybackPage.startPlayback()
        pageStack.push(videoPlaybackPage)
    }
}
