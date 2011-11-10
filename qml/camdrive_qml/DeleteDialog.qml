import QtQuick 1.0
import com.nokia.meego 1.0

QueryDialog {
    id: dialog

    property variant video: []

    titleText: qsTr("Delete?")
    message: !video.title ? "" : qsTr("Do you want to delete") + " '" + video.title + "' " + qsTr("from your device?")
    acceptButtonText: qsTr("Yes")
    rejectButtonText: qsTr("No")
    onAccepted: Utils.deleteVideo(video.filePath)
}
