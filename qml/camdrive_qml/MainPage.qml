import QtQuick 1.1
import com.nokia.meego 1.0
import "scripts/utils.js" as Utils
import "Common"

Page {
    id: mainPage

    function showViewfinderPage()
    {
        viewfinderPage.firstTimeFunction();
        pageStack.push(viewfinderPage);
    }

    function showSettingsPage()
    {
        var settingsPage = Utils.createObject(Qt.resolvedUrl("Settings/SettingsPage2.qml"), appWindow.pageStack);
        appWindow.showToolbar();
        pageStack.push(settingsPage);
    }

    function showVideoListPage()
    {
        var videoListPage = Utils.createObject(Qt.resolvedUrl("VideoListPage.qml"), appWindow.pageStack);
        //! Reload videoList
        videoListPage.prepareVideoDetailsPage();
        videoListPage.reloadVideoListImmediately();

        //appWindow.showToolbar();
        pageStack.push(videoListPage);
    }

    Row {
        anchors.fill: parent
        anchors.topMargin: 120 //(480 - 240) / 2
        anchors.leftMargin: 51
        spacing: 16
        enabled: !appWindow.inPortrait
        visible: !appWindow.inPortrait

        ButtonHighlight {
            width: 240
            height: width
            source: "images/rec.png"
            highlightSource: "images/highlight240.png"
            onClicked: {
                showViewfinderPage();
            }
        }

        ButtonHighlight {
            width: 240
            height: width
            source: "images/settings.png"
            highlightSource: "images/highlight240.png"
            onClicked: {
                showSettingsPage();
            }
        }

        ButtonHighlight {
            width: 240
            height: width
            source: "images/video.png"
            highlightSource: "images/highlight240.png"
            onClicked: {
                showVideoListPage();
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.topMargin:  32
        anchors.leftMargin: 120
        spacing: 16
        enabled: appWindow.inPortrait
        visible: appWindow.inPortrait

        ButtonHighlight {
            width: 240
            height: width
            source: "images/rec.png"
            highlightSource: "images/highlight240.png"
            onClicked: {
                showViewfinderPage();
            }
        }

        ButtonHighlight {
            width: 240
            height: width
            source: "images/settings.png"
            highlightSource: "images/highlight240.png"
            onClicked: {
                showSettingsPage();
            }
        }

        ButtonHighlight {
            width: 240
            height: width
            source: "images/video.png"
            highlightSource: "images/highlight240.png"
            onClicked: {
                showVideoListPage();
            }
        }
    }
}
