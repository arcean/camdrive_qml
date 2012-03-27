import QtQuick 1.0

Rectangle {
    id: arrow
    property string text: ""
    property string fontFamily: "Nokia Pure"
    property color effectColor: "white"
    property bool header: false
    property bool debug: false
    property bool minor: false

    width: 100
    height: 200
    anchors.margins: header ? 40 : 20
    transformOrigin: Item.Center

    property int angleSW: 225
    property int angleSE: 135
    property int angleNE: 45
    property int angleNW: 315
    property int angleE: 90
    property int angleW: 270
    property int angleN: 0
    property int angleS: 180

    Translate { id: noTranslate; }
    Translate { id: translateSE; x: -50 }
    Translate { id: translateSW; x: 50 }
    Translate { id: translateNE; x: -50 }
    Translate { id: translateNW; x: 50 }
    Translate { id: translateE; x: -10 }
    Translate { id: translateW; x: 10 }
    Translate { id: translateN; y: -40}
    Translate { id: translateS; y: 40 }

    transform: {
        var translation = noTranslate;
        switch (rotation) {
        case angleSE:
            translation = translateSE;
            break;
        case angleE:
            translation = translateE;
            break;
        case angleSW:
            translation = translateSW;
            break;
        case angleNE:
            translation = translateNE;
            break;
        case angleNW:
            translation = translateNW;
            break;
        case angleN:
            translation = translateN;
            break;
        case angleS:
            translation = translateS;
            break;
        case angleW:
            translation = translateW;
            break;
        }
        return translation
    }

    color: debug ? "red" : "transparent"

    Text {
        text: arrow.text
        color: effectColor
        font.family: arrow.fontFamily
        font.pixelSize: header ? parent.width/1.5 : parent.width/3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        smooth: true
        transform: Translate { y: (header ? -40 : -20) }
    }

    Image {
        source: "images/compassarrow.png"
        width: header ? 10 : minor ? 3 : 5
        height: header ? 20 : minor ? 5 : 10
        smooth: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

//!  End of File
