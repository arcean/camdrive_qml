// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: master
    width: 80
    height: 80
    visible: false

    property int length: 700;
    property int maxCounter: 15;
    property int counter: 0;

    Image {
        id: rect
        anchors.centerIn: parent
        state: "normal"
        source: "../images/emergency.png"

        states: [
            State {
                name: "activated"
                PropertyChanges {
                    target: rect
                    x: 16
                    y: 16
                    width: 56
                    height: 56
                }
            },
            State {
                name: "activatedOversized"
                PropertyChanges {
                    target: rect
                    x: 0
                    y: 0
                    width: 80
                    height: 80
                }
            },
            State {
                name: "normal"
                PropertyChanges {
                    target: rect
                    x: 24
                    y: 24
                    width: 32
                    height: 32
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
                    if (!settingsObject.getShowEmergencyButton())
                        master.visible = false;
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

    function stopAlarm() {
        animationTimer.stop();
        if (master.counter >= master.maxCounter) {
            master.counter = 0;
            rect.state = "normal";
            if (!settingsObject.getShowEmergencyButton())
                master.visible = false;
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

    function startAlarm() {
        master.visible = true;
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
