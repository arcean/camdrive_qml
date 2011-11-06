import QtQuick 1.0
import com.nokia.meego 1.0

ProgressBar {
    id: root
    property bool inverted: theme.inverted

    platformStyle: ProgressBarStyle {
        inverted: root.inverted
        unknownTexture: "image://theme/" + _ACTIVE_COLOR + "-meegotouch-progressindicator"+__invertedString+"-bar-unknown-texture"
        knownTexture: "image://theme/" + _ACTIVE_COLOR + "-meegotouch-progressindicator"+__invertedString+"-bar-known-texture"
    }
}
