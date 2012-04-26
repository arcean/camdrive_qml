import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: delegate

    property bool useMarqueeText
    signal clicked
    signal pressAndHold

    function getDate(milliseconds) {
        /* Convert the date to a string */

        var date = new Date();
        date.setTime(milliseconds);
        var dateString = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        return dateString;
    }

    function getDuration(secs) {
        /* Converts seconds to HH:MM:SS format. */
        var hours = Math.floor(secs / 3600);
        var minutes = Math.floor(secs / 60) - (hours * 60);
        var seconds = secs - (hours * 3600) - ( minutes * 60);
        if (seconds < 10) {
            seconds = "0" + seconds;
        }
        var duration = minutes + ":" + seconds;
        if (hours > 0) {
            duration = hours + ":" + duration;
        }
        return duration;
    }

    function getTime(msecs) {
        /* Convert milliseconds to HH:MM:SS format */

        var secs = Math.floor(msecs / 1000);
        var hours = Math.floor(secs / 3600);
        var minutes = Math.floor(secs / 60) - (hours * 60);
        var seconds = secs - (hours * 3600) - (minutes * 60);
        if (seconds < 10) {
            seconds = "0" + seconds;
        }
        var time = minutes + ":" + seconds;
        if (hours > 0) {
            time = hours + ":" + time;
        }
        return time;
    }

    Image {
        id: thumb
        height: Math.floor((width / 16) * 9)
        anchors { left: parent.left; right: parent.right; margins: (!delegate.parent.movingVertically) && (mouseArea.pressed) ? 20 : 10 }
        source: "file:///home/user/.thumbnails/video-grid/" + Qt.md5(url) + ".jpeg"
        smooth: true
        onStatusChanged: if (thumb.status == Image.Error) thumb.source = "image://theme/meegotouch-video-placeholder";

        Image {
            id: durationLabel
            width: durationText.width + 20
            anchors { top: thumb.top; right: thumb.right; margins: 10 }
            source: "image://theme/meegotouch-video-duration-background"
            smooth: true

            Label {
                id: durationText
                anchors.centerIn: durationLabel
                font.pixelSize: 14
                color: _TEXT_COLOR
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                smooth: true
                text: getDuration(duration - resumePosition)
            }
        }
    }

    Marquee {
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; margins: 10 }
        text: Qt.formatDateTime(lastModified)
        enableScrolling: useMarqueeText
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}
