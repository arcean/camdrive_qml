import QtQuick 1.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import "scripts/utils.js" as Utils

Page {
    id: root

    property alias id: video.item
    property alias filePath: videoFilter.value
    property bool allowToPlay: true

    orientationLock: PageOrientation.LockLandscape

    tools: ToolBarLayout {
        id: toolBar

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: appWindow.pageStack.pop()
        }
    }

    DocumentGalleryItem {
        id: video

        function getFileSize() {
            var mb = Math.abs(video.metaData.fileSize / 1000000).toString();
            return mb.slice(0, mb.indexOf(".") + 2) + "MB";
        }

        properties: ["title", "fileName", "duration", "fileSize", "fileExtension", "playCount", "lastModified", "url", "filePath"]
    }

    DocumentGalleryModel {
        id: videoModel

        rootType: DocumentGallery.Video
        filter: GalleryEqualsFilter {
            id: videoFilter

            property: "filePath"
            value: ""
        }
        onStatusChanged: if ((videoModel.status == DocumentGalleryModel.Finished) && (videoModel.count > 0)) video.item = videoModel.get(0).itemId;
    }


    Flickable {
        id: flicker

        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height + 20

        Column {
            id: column

            anchors { top: parent.top; left: parent.left; right: parent.right; margins: 10 }
            spacing: 10

            Item {
                width: 460
                height: Math.floor((width / 16) * 9)

                Image {
                    id: thumb

                    height: Math.floor((width / 16) * 9)
                    anchors { left: parent.left; right: parent.right; margins: mouseArea.pressed ? 10 : 0 }
                    source: video.available ? "file:///home/user/.thumbnails/video-grid/" + Qt.md5(video.metaData.url) + ".jpeg" : ""
                    smooth: true
                    onStatusChanged: if (thumb.status == Image.Error) thumb.source = "image://theme/meegotouch-video-placeholder";

                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent
                        enabled: root.allowToPlay
                        onClicked: playVideos([Utils.cloneVideoObject(video.metaData, video.item)], true)
                    }
                }
            }

            Label {
                id: titleText

                width: parent.width
                font.pixelSize: 32
                color: _TEXT_COLOR
                wrapMode: Text.WordWrap
                text: video.available ? video.metaData.fileName.slice(0, video.metaData.fileName.lastIndexOf(".")) : ""
            }

            Column {
                width: parent.width

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Length" + ": " + Utils.getDuration(video.metaData.duration) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Format" + ": " + video.metaData.fileExtension.toUpperCase() : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Size" + ": " + video.getFileSize() : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Added" + ": " + Qt.formatDateTime(video.metaData.lastModified) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Times played" + ": " + video.metaData.playCount : ""
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}