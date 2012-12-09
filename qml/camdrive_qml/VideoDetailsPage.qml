import QtQuick 1.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import "scripts/utils.js" as Utils
import "Common/"

Page {
    id: root

    property alias id: video.item
    property alias filePath: videoFilter.value
    property bool allowToPlay: true

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

        properties: ["title", "fileName", "duration", "fileSize", "fileExtension", "lastModified", "width", "height", "url", "filePath"]
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

    Header {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        title: "Video details"
    }

    Flickable {
        id: contentText
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        contentHeight: appWindow.inPortrait ? (column.height + videoItem.height + 10) : column.height

        Item {
            id: videoItem
            anchors.top: parent.top
            anchors.left: parent.left
            width:  460
            height: Math.floor((width / 16) * 9)
            z: 1

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

        Column {
            id: column
            width: parent.width

            anchors.top: appWindow.inPortrait ? videoItem.bottom : parent.top
            anchors.left: appWindow.inPortrait ? parent.left : videoItem.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10

            Label {
                id: titleText

                width: parent.width
                font.pixelSize: 32
                color: _ACTIVE_COLOR_TEXT
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
                    text: video.available ? "Created" + ": " + Qt.formatDateTime(video.metaData.lastModified) : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Width" + ": " + video.metaData.width + " px" : ""
                }

                Label {
                    color: _TEXT_COLOR
                    text: video.available ? "Height" + ": " + video.metaData.height + " px" : ""
                }
            }
        }
    }
}
