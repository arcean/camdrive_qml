import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

Page {
    id: videoPageList

    function showAboutDialog() {
        var aboutDialog = ObjectCreator.createObject(Qt.resolvedUrl("AboutDialog.qml"), appWindow.pageStack);
        aboutDialog.open();
    }

    function showSettings() {
        appWindow.pageStack.push(Qt.resolvedUrl("SettingsPage.qml"));
    }

    function showConfirmDeleteDialog(video) {
        var deleteDialog = ObjectCreator.createObject(Qt.resolvedUrl("ConfirmDeleteDialog.qml"), appWindow.pageStack);
        deleteDialog.video = video;
        deleteDialog.open();
    }

    function showVideoDetails(itemId) {
        var detailsPage = ObjectCreator.createObject(Qt.resolvedUrl("VideoDetailsPage.qml"), appWindow.pageStack);
        detailsPage.id = itemId;
        appWindow.pageStack.push(detailsPage);
    }

    function showPlaylists() {
        appWindow.pageStack.push(Qt.resolvedUrl("PlaylistsPage.qml"));
    }

    function showAddToPlaylistDialog(url) {
        var addToPlaylistDialog = ObjectCreator.createObject(Qt.resolvedUrl("AddToPlaylistDialog.qml"), appWindow.pageStack);
        addToPlaylistDialog.fileUrl = url;
        addToPlaylistDialog.open();
    }

    orientationLock: appWindow.pageStack.currentPage == videoPlaybackPage ? PageOrientation.Automatic
                                                                          : (Settings.screenOrientation == "landscape")
                                                                            ? PageOrientation.LockLandscape
                                                                            : (Settings.screenOrientation == "portrait")
                                                                              ? PageOrientation.LockPortrait
                                                                              : PageOrientation.Automatic

    tools: ToolBarLayout {
        id: toolBar

    //    NowPlayingButton {}

        ToolIcon {
            anchors.right: parent.right
            platformIconId: "toolbar-view-menu"
            onClicked: (menu.status == DialogStatus.Closed) ? menu.open() : menu.close()
        }
    }

    Connections {
        /* Connect to signals from C++ object Utils */

        target: Utils
        onAlert: messages.displayMessage(message)
        onVideoDeleted: reloadTimer.restart()
    }

    Timer {
        id: reloadTimer

        interval: 2000
        onTriggered: videoListModel.reload()
    }

    Menu {
        id: menu

        MenuLayout {
/*
            MenuSelectionItem {
                title: qsTr("Thumbnail size")
                model: ListModel {
                    ListElement { name: QT_TR_NOOP("Large"); value: "large" }
                    ListElement { name: QT_TR_NOOP("Small"); value: "small" }
                }
                initialValue: Settings.thumbnailSize
                onValueChosen: Settings.thumbnailSize = value
            }

            MenuSelectionItem {
                title: qsTr("Sort by")
                model: ListModel {
                    ListElement { name: QT_TR_NOOP("Date (asc)"); value: "+lastModified" }
                    ListElement { name: QT_TR_NOOP("Date (desc)"); value: "-lastModified" }
                    ListElement { name: QT_TR_NOOP("Title (asc)"); value: "+title" }
                    ListElement { name: QT_TR_NOOP("Title (desc)"); value: "-title" }
                }
                initialValue: videoListModel.sortProperties[0]
                onValueChosen: videoList.changeSortOrder(value)
            }
*/
            MenuItem {
                text: qsTr("Playlists")
                onClicked: showPlaylists()
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: showSettings()
            }

            MenuItem {
                text: qsTr("About")
                onClicked: showAboutDialog()
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
                text: qsTr("Add to playback queue")
                onClicked: appendPlaybackQueue([ObjectCreator.cloneVideoObject(videoListModel.get(videoList.selectedIndex))])
            }

            MenuItem {
                text: qsTr("Add to playlist")
                onClicked: showAddToPlaylistDialog(videoListModel.get(videoList.selectedIndex).url)
            }

            MenuItem {
                text: qsTr("Delete")
                onClicked: showConfirmDeleteDialog(videoListModel.get(videoList.selectedIndex))
            }
        }
    }

    Item {
        id: searchItem

        height: searchInput.height
        anchors { left: parent.left; leftMargin: 20; right: parent.right; rightMargin: 20; top: parent.top; topMargin: 10 }

        visible: videoList.atYBeginning
        opacity: visible ? 1 : 0

        Behavior on opacity { PropertyAnimation { duration: 300 } }
/*
        MyTextField {
            id: searchInput

            anchors { top: parent.top; left: parent.left; right: parent.right }
            placeholderText: qsTr("Search")
            inputMethodHints: Qt.ImhNoPredictiveText
            platformSipAttributes: SipAttributes {
                actionKeyEnabled: searchInput.text != ""
                actionKeyHighlighted: true
                actionKeyLabel: qsTr("Done")
                actionKeyIcon: ""
            }
            Keys.onEnterPressed: videoList.searchVideos(searchInput.text)
            Keys.onReturnPressed: videoList.searchVideos(searchInput.text)
        }
*/
        Image {
            anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
            source: titleFilter.value == "" ? _ICON_LOCATION + "icon-m-toolbar-search.png" : _ICON_LOCATION + "icon-m-input-clear.png"
            opacity: searchMouseArea.pressed ? 0.5 : 1

            MouseArea {
                id: searchMouseArea

                width: 60
                height: 60
                anchors.centerIn: parent
                enabled: searchInput.text != ""
                onClicked: titleFilter.value == "" ? videoList.searchVideos(searchInput.text) : videoList.showAllVideos()
            }
        }
    }

    GridView {
        id: videoList

        property int selectedIndex
        property real cellWidthScale: Settings.thumbnailSize == "large" ? 1.0 : 0.5
        property real cellHeightScale: Settings.thumbnailSize == "large" ? 1.0 : 0.55

        function changeSortOrder(order) {
            videoListModel.sortProperties = [order];
            videoListModel.reload();
        }

        function searchVideos(query) {
            searchInput.focus = false;
            videoList.focus = true;
            searchInput.platformCloseSoftwareInputPanel();
            titleFilter.value = query;
        }

        function showAllVideos() {
            searchInput.text = "";
            searchInput.focus = false;
            videoList.focus = true;
            searchInput.platformCloseSoftwareInputPanel();
            titleFilter.value = "";
        }

        anchors { top: searchItem.bottom; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom }
        cellWidth: appWindow.inPortrait ? Math.floor(width * cellWidthScale) : Math.floor((width / 2) * cellWidthScale)
        cellHeight: appWindow.inPortrait ? Math.floor(300 * cellHeightScale) : Math.floor(280 * cellHeightScale)
        flickableDirection: Flickable.VerticalFlick
        model: DocumentGalleryModel {
            id: videoListModel

            rootType: DocumentGallery.Video
            properties: ["filePath", "url", "fileName", "title", "duration", "resumePosition"]
            sortProperties: ["+title"]
            filter: GalleryFilterIntersection {
                filters: [
                    GalleryEndsWithFilter {
                        property: "fileName"
                        value: ".partial"
                        negated: true
                    },

                    GalleryEqualsFilter {
                        property: "path"
                        value: "/home/user/MyDocs/DCIM"
                        negated: true
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
            useMarqueeText: appWindow.pageStack.currentPage == homePage
            onClicked: playVideos([ObjectCreator.cloneVideoObject(videoListModel.get(index))])
            onPressAndHold: {
                videoList.selectedIndex = index;
                contextMenu.open();
            }
        }

        Behavior on y { NumberAnimation { duration: 300 } }
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
        visible: (videoListModel.status == DocumentGalleryModel.Finished) && (videoListModel.count == 0)
    }

    BusyIndicator {
        anchors.centerIn: videoList
        running: visible
        visible: videoListModel.status == DocumentGalleryModel.Active
        platformStyle: BusyIndicatorStyle {
            inverted: theme.inverted
            size: "large"
        }
    }

    MouseArea {
        anchors.fill: videoList
        enabled: searchInput.activeFocus
        onPressed: {
            if (titleFilter.value == "") {
                searchInput.text = "";
            }
            searchInput.focus = false;
            videoList.focus = true;
            searchInput.platformCloseSoftwareInputPanel();
        }
    }
}
