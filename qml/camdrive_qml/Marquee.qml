import QtQuick 1.0
import com.nokia.meego 1.0

Item {
    id: root

    property alias textColor: marqueeText.color
    property alias boldFont: marqueeText.font.bold
    property alias fontSize: marqueeText.font.pixelSize
    property alias text: marqueeText.text
    property alias scrollDuration: textAnimation.duration
    property bool enableScrolling

    height: marqueeText.height
    clip: true

    Label {
        id: marqueeText

        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap
        font.bold: true
        color: _TEXT_COLOR
        x: textAnimation.running ? root.width : 0
    }

    NumberAnimation {
        id: textAnimation

        target: marqueeText
        properties: "x"
        from: root.width
        to: -marqueeText.width
        duration: Settings.thumbnailSize == "large" ? marqueeText.text.length * 200 : marqueeText.text.length * 300
        loops: Animation.Infinite
        running: (Settings.enableMarqueeText) && (enableScrolling) && (marqueeText.width > root.width) && (platformWindow.viewMode == WindowState.Fullsize) && (!appWindow.pageStack.busy)
    }
}
