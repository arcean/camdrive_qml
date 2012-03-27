import QtQuick 1.0

Rectangle {
    width: compassWidth
    height: compassWidth
    color: bgColor
    radius: compassWidth
    border.width: 2
    border.color: effectColor
    opacity: useInvertedBackground ? 0.5 : 1.0

    //! Properties.
    property color bgColor: "transparent"
    property color effectColor: "white";
    property alias showBackground: backgroundImage.visible
    property bool useInvertedBackground: false
    property int compassWidth: parent.width>parent.height ? parent.height-(parent.height/4)
                                                          : parent.width-(parent.width/4)

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: useInvertedBackground ? "images/compassfacebg-inverted.png"
                                      : "images/compassfacebg.png"
        smooth: true
    }

    /* North */
    CompassUI2DArrow {
        text: "N"
        effectColor: parent.effectColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        rotation: 0
        header: true
    }

    /* South */
    CompassUI2DArrow {
        text: "S"
        effectColor: parent.effectColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        rotation: 180
        header: true
    }

    /* West */
    CompassUI2DArrow {
        text: "W"
        effectColor: parent.effectColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        rotation: 270
        header: true
    }

    /* East */
    CompassUI2DArrow {
        text: "E"
        effectColor: parent.effectColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        rotation: 90
        header: true
    }

    /* Noth East */
    CompassUI2DArrow {
        text: "NE"
        effectColor: parent.effectColor
        anchors.top: parent.top
        anchors.right: parent.right
        rotation: 45
    }

    /* North West */
    CompassUI2DArrow {
        text: "NW"
        effectColor: parent.effectColor
        anchors.top: parent.top
        anchors.left: parent.left
        rotation: 315
    }

    /* South West */
    CompassUI2DArrow {
        text: "SW"
        effectColor: parent.effectColor
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        rotation: 225
    }

    /* South East */
    CompassUI2DArrow {
        text: "SE"
        effectColor: parent.effectColor
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        rotation: 135
    }
}

//!  End of File
