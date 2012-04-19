import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import Settings 1.0
import "scripts/utils.js" as UtilsScript

Page {
    id: videoPageList

    property string thumbnailSize: "large"
    property bool loading: true

    function showDeleteDialog(video)
    {
        var deleteDialog = UtilsScript.createObject(Qt.resolvedUrl("DeleteDialog.qml"), appWindow.pageStack);
        deleteDialog.video = video;
        deleteDialog.open();
    }

    function showVideoDetails(itemId)
    {
        var detailsPage = UtilsScript.createObject(Qt.resolvedUrl("VideoDetailsPage.qml"), appWindow.pageStack);
        detailsPage.id = itemId;
        appWindow.pageStack.push(detailsPage);
    }

    function reloadVideoList()
    {
        reloadTimer.restart();
    }

    function reloadVideoListImmediately()
    {
        videoListModel.reload();
    }

    function prepareVideoDetailsPage()
    {
        videoPageList.loading = true;
        Thumbnails.loadAllVideoFilesToList();
        Thumbnails.createNewThumbnail();
    }

    function deleteVideo(path)
    {
        Thumbnails.checkIfThumbnailExists(path, true);
        videoPageList.reloadVideoList();
        DatabaseHelper.removeVideoQML(path);
        settings.addCurrentVideoFiles(-1);
        if (DatabaseHelper.isFileNameFreeQML(path)) {
            DatabaseHelper.removeVideoFromMainQML(path);
        }
    }

    Component.onCompleted: {
        appWindow.showToolbar();
        prepareVideoDetailsPage();
        //reloadTimer.start();
    }

    Connections {
        target: Thumbnails
        onFinished: {
            reloadVideoListImmediately();
            videoPageList.loading = false;
        }
    }

    Connections {
        target: Utils
        onVideoDeleted: deleteVideo(path);
    }

    Settings {
        id: settings
    }

    tools: ToolBarLayout {
        id: toolBar

    //    NowPlayingButton {}
        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                pageStack.pop();
                hideToolbar();
            }
        }
        ToolIcon {
            anchors.right: parent.right
            platformIconId: "toolbar-view-menu"
            onClicked: (menu.status == DialogStatus.Closed) ? menu.open() : menu.close()
        }
    }

    Timer {
        id: reloadTimer

        interval: 2000
        onTriggered: videoListModel.reload()
    }

    Menu {
        id: menu
        MenuLayout {
            MenuSelectItem {
                title: "Sort by"
                model: ListModel {
                    ListElement { name: "Date (asc)"; value: "+lastModified" }
                    ListElement { name: "Date (desc)"; value: "-lastModified" }
                    ListElement { name: "Title (asc)"; value: "+title" }
                    ListElement { name: "Title (desc)"; value: "-title" }
                }
                initialValue: videoListModel.sortProperties[0]
                onValueChosen: videoList.changeSortOrder(value)
            }
            MenuSelectItem {
                title: "Thumbnail size"
                model: ListModel {
                    ListElement { name: "Large"; value: "large" }
                    ListElement { name: "Small"; value: "small" }
                }
                initialValue: videoPageList.thumbnailSize
                onValueChosen: videoPageList.thumbnailSize = value
            }
        }
    }

    ContextMenu {
        id: contextMenu

        MenuLayout {
            MenuItem {
                text: qsTr("View details")
                onClicked: showVideoDetails(videoListModel.get(videoList.selectedIndex).itemId)
            }
            MenuItem {
                text: qsTr("Delete")
                onClicked: showDeleteDialog(videoListModel.get(videoList.selectedIndex))
            }
        }
    }

    GridView {
        id: videoList
        anchors { top: parent.top; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom }
        visible: !loading

        property int selectedIndex
        property real cellWidthScale: videoPageList.thumbnailSize == "large" ? 1.0 : 0.5
        property real cellHeightScale: videoPageList.thumbnailSize == "large" ? 1.0 : 0.55

        function showAllVideos() {
            videoList.focus = true;
            titleFilter.value = "";
        }

        function changeSortOrder(order) {
            videoListModel.sortProperties = [order];
            videoListModel.reload();
        }

        cellWidth: appWindow.inPortrait ? Math.floor(width * cellWidthScale) : Math.floor((width / 2) * cellWidthScale)
        cellHeight: appWindow.inPortrait ? Math.floor(300 * cellHeightScale) : Math.floor(280 * cellHeightScale)
        flickableDirection: Flickable.VerticalFlick
        model: DocumentGalleryModel {
            id: videoListModel
            rootType: DocumentGallery.Video
            properties: ["filePath", "url", "fileName", "title", "lastModified", "duration", "resumePosition"]
            sortProperties: ["-lastModified"]
            filter: GalleryFilterIntersection {
                filters: [
                    GalleryEndsWithFilter {
                        property: "fileName"
                        value: ".partial"
                        negated: true
                    },

                    GalleryEqualsFilter {
                        property: "path"
                        value: "/home/user/MyDocs/"
                        negated: true
                    },

                    GalleryEqualsFilter {
                        property: "path"
                        value: "/home/user/MyDocs/camdrive"
                        negated: false
                    },

                    GalleryContainsFilter {
                        id: titleFilter

                        property: "title"
                        value: ""
                    }
                ]
            }
        }
        delegate: VideoListDelegate {
            id: delegate

            width: videoList.cellWidth
            height: videoList.cellHeight
            useMarqueeText: appWindow.pageStack.currentPage == videoPageList
            onClicked: {
                if (videoListModel.status == DocumentGalleryModel.Finished) {
                    playVideos([UtilsScript.cloneVideoObject(videoListModel.get(index))])
                }
            }
            onPressAndHold: {
                videoList.selectedIndex = index;
                contextMenu.open();
            }
        }

        Behavior on y { NumberAnimation { duration: 300 } }
    }

    ScrollDecorator {
        flickableItem: videoList
    }

    Label {
        id: noResultsText

        anchors.centerIn: videoList
        font.pixelSize: _LARGE_FONT_SIZE
        font.bold: true
        color: "#4d4d4d"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("No videos found")
        visible: ((videoListModel.status == DocumentGalleryModel.Finished) && (videoListModel.count == 0)) || loading
    }

    BusyIndicator {
        anchors.centerIn: videoList
        running: visible
        visible: (videoListModel.status == DocumentGalleryModel.Active) || loading
        platformStyle: BusyIndicatorStyle {
            inverted: theme.inverted
            size: "large"
        }
    }
}
