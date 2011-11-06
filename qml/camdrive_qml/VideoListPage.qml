import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

Page {
    id: videoPageList

    function showConfirmDeleteDialog(video) {

    }

    function showVideoDetails(itemId) {

    }

    orientationLock: PageOrientation.LockLandscape

    tools: ToolBarLayout {
        id: toolBar

    //    NowPlayingButton {}
        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                pageStack.pop()
                hideToolbar()
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
                onClicked: showConfirmDeleteDialog(videoListModel.get(videoList.selectedIndex))
            }
        }
    }

    GridView {
        id: videoList

        property int selectedIndex
        property real cellWidthScale: 1.0
        property real cellHeightScale: 1.0

        function showAllVideos() {
            videoList.focus = true;
            titleFilter.value = "";
        }

        anchors { top: parent.top; topMargin: 10; left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom }
        //anchors.fill: parent
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
            useMarqueeText: appWindow.pageStack.currentPage == videoListPage
            //onClicked: playing videos
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
        font.pixelSize: 28
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
}
