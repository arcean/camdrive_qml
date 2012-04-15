// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: master
    width: 96
    height: 96

    property int length: 700;
    property int maxCounter: 9;
    property int counter: 0;

    Image {
        id: rect
        anchors.centerIn: parent
        state: "normal"
        source:"qrc:/icons/emergency_call.png"

        states: [
            State {
                name: "activated"
                PropertyChanges {
                    target: rect
                    x: 16
                    y: 16
                    width: 64
                    height: 64
                }
            },
            State {
                name: "activatedOversized"
                PropertyChanges {
                    target: rect
                    x: 0
                    y: 0
                    width: 96
                    height: 96
                }
            },
            State {
                name: "normal"
                PropertyChanges {
                    target: rect
                    x: 24
                    y: 24
                    width: 48
                    height: 48
                }
            }
        ]

        Timer {
            id: animationTimer
            interval: master.length
            running: false
            repeat: true
            onTriggered: {
                if (master.counter >= master.maxCounter) {
                    master.counter = 0;
                    rect.state = "normal";
                    return;
                }

                if (rect.state == "activated") {
                    rect.state = "activatedOversized";
                    master.counter++;
                }
                else if (rect.state == "activatedOversized"){
                    rect.state = "activated";
                    master.counter++;
                }
            }
        }

        transitions: [
            Transition {
                NumberAnimation { target: rect; properties: "x,y,width,height"; duration: length }
            }
        ]
    }

    function startAlarm() {
        animationTimer.start();
        rect.state = "activated";
    }

/*
    MouseArea {
        anchors.fill: rect

        onClicked: {
                animationTimer.start();
                rect.state = "activated";

        }
    }*/
}
