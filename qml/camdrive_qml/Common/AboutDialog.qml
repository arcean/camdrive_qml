import QtQuick 1.0
import com.nokia.meego 1.0
import "../"

QueryDialog {
    id: dialog

    titleText: qsTr("<font color=\"" + _ACTIVE_COLOR_TEXT + "\">CamDrive " + _APP_VERSION + "</font>")
    icon: "/usr/share/icons/hicolor/80x80/apps/camdrive.png"
    message: "CamDrive is a car black box. Application records various minutes and stores latitude, longitude, and speed every second. <br><br> &copy; Tomasz Pieniążek 2011, 2012 <br>"
}
