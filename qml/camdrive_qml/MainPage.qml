import QtQuick 1.1
import com.nokia.meego 1.0
import "scripts/utils.js" as Utils

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

    // Mask invisible region
    Rectangle {
        x: appWindow.inPortrait ? 160 : 90
        y: appWindow.inPortrait ? 90 : 168
        width: 160
        height: 110
        color: "white"
    }

    Row {
        anchors.fill: parent
        anchors.topMargin: 120 //(480 - 240) / 2
        anchors.leftMargin: 51
        spacing: 16
        enabled: !appWindow.inPortrait
        visible: !appWindow.inPortrait

        Image {
            id: startRecordingImage
            //x: 51
            //y: 100
            width: 240
            height: 240
            source: "qrc:/icons/start_recording.png"

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.source = "qrc:/icons/start_recording_highlighted.png"
                }
                onReleased: {
                    parent.source = "qrc:/icons/start_recording.png"
                }
                onClicked: {
                    showViewfinderPage();
                }
            }
        }

            Image {
                id: settingsImage
                width: 240
                height: startRecordingImage.width
                source: "qrc:/icons/settings.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.source = "qrc:/icons/settings_highlighted.png"
                    }
                    onReleased: {
                        parent.source = "qrc:/icons/settings.png"
                    }
                    onClicked: {
                        showSettingsPage();
                    }
                }
            }

            Image {
                id: filesImage
                width: 240
                height: startRecordingImage.width
                source:"qrc:/icons/files.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.source = "qrc:/icons/files_highlighted.png"
                    }
                    onReleased: {
                        parent.source = "qrc:/icons/files.png"
                    }
                    onClicked: {
                        showVideoListPage();
                    }
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

        Image {
            id: startRecordingImageP
            width: 240
            height: 240
            source: "qrc:/icons/start_recording.png"

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    parent.source = "qrc:/icons/start_recording_highlighted.png"
                }
                onReleased: {
                    parent.source = "qrc:/icons/start_recording.png"
                }
                onClicked: {
                    showViewfinderPage();
                }
            }
        }

            Image {
                id: settingsImageP
                width: 240
                height: startRecordingImageP.width
                source: "qrc:/icons/settings.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.source = "qrc:/icons/settings_highlighted.png"
                    }
                    onReleased: {
                        parent.source = "qrc:/icons/settings.png"
                    }
                    onClicked: {
                        showSettingsPage();
                    }
                }
            }

            Image {
                id: filesImageP
                width: 240
                height: startRecordingImageP.width
                source:"qrc:/icons/files.png"

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        parent.source = "qrc:/icons/files_highlighted.png"
                    }
                    onReleased: {
                        parent.source = "qrc:/icons/files.png"
                    }
                    onClicked: {
                        showVideoListPage();
                    }
                }
            }
    }
}
