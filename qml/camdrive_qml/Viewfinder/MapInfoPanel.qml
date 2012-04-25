import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: infoContainer

    property bool isPortrait: (screen.currentOrientation === Screen.Landscape) ? false : true

    property string latitude: ""
    property string longitude: ""
    property string updateTime: ""
    property string positioningMethod: ""
    property string street: ""
    property string city: ""
    property string postal: ""
    property string country: ""

    //! Property indicating if busy indicator running and visible
    property bool spinnerRunning: true

    width: parent.width
    height: countrynameLabel.y + 39 //! 39 is calculated as size of font + bottom margin
    anchors.top: parent.top

    //! Busy indicator running while retrieving reverse geocoding info
    BusyIndicator {
        id: spinner

        platformStyle: BusyIndicatorStyle { size: "medium" }
        anchors { top: parent.top; topMargin: 13; right: parent.right; rightMargin: 16 }
        z: 1
        opacity: spinnerRunning ? 1 : 0
        running: spinnerRunning
    }

    //! Background image for information panel
    Image {
        id: infoRect

        height: parent.height; width: parent.width
        source: "image://theme/meegotouch-applicationpage-background-inverted"
        state: "close"
        anchors.top: parent.top
        opacity: 0.6
        clip: true

        //! Displaying street name. It is visible only when panel is closed as top line
        Label {
            id: streetnameLabelClose
            anchors { top: parent.top; topMargin: 16; left: parent.left; leftMargin: 16 }
            text: "Street: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            opacity: 0
        }

        Label {
            id: streetNameClose
            anchors {
                left: streetnameLabelClose.right
                top:  parent.top
                topMargin: 16
                leftMargin: 10
            }

            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            opacity: 0
            text: street
        }

        //! Displaying coordinate
        Label {
            id: latlabel
            anchors { top: parent.top; topMargin: 16; left: parent.left; leftMargin: 16 }
            text: "Coordinate: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: lattextLabel
            anchors { left: latlabel.right; top: parent.top; topMargin: 16; leftMargin: 10 }
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            text: latitude + (latitude !== "" ? ", " : "")
        }

        Label {
            id: longtextLabel
            anchors {
                top: isPortrait ? latlabel.bottom: parent.top
                left: isPortrait ? parent.left: lattextLabel.right
                leftMargin: isPortrait ? 16 : 10
                topMargin: isPortrait ? 0 : 16
            }

            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            text: longitude
        }

        //! Displaying last update time
        Label {
            id: timelabel
            anchors { top: longtextLabel.bottom; topMargin: 5; left: parent.left; leftMargin: 16 }
            text: "Last update time: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: timestampLabel
            anchors {
                left: isPortrait ? parent.left: timelabel.right
                top: isPortrait ? timelabel.bottom : longtextLabel.bottom
                leftMargin: isPortrait ? 16 : 10
                topMargin: isPortrait ? 0 : 5
            }

            text: updateTime
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        //! Displaying positioning method
        Label {
            id: posmethodlabel
            anchors { left: parent.left; top: timestampLabel.bottom; topMargin:5; leftMargin: 16 }
            text: "Positioning Method: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: sourceLabel
            anchors {
                left: posmethodlabel.right
                top: timestampLabel.bottom
                topMargin: 5
                leftMargin: 10
            }

            text: positioningMethod
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        //! Displaying street name
        Label {
            id: streetnameLabel
            anchors { top: posmethodlabel.bottom; topMargin: 5; left: parent.left; leftMargin: 16 }
            text: "Street: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: streetName
            anchors {
                left: streetnameLabel.right
                top: posmethodlabel.bottom
                topMargin: 5
                leftMargin: 10
            }

            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            text: street
        }

        //! Displaying postal code
        Label {
            id: postCodeLabel
            anchors {
                left: parent.left
                top: streetnameLabel.bottom
                topMargin: 5
                leftMargin: 16
            }

            text: "Postalcode: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: postalCode
            anchors {
                top: streetnameLabel.bottom
                left: postCodeLabel.right
                topMargin: 5
                leftMargin: 10
            }

            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            text: postal
        }

        //! Displaying city
        Label {
            id: citynameLabel
            anchors { left: parent.left; top: postCodeLabel.bottom; topMargin: 5; leftMargin: 16 }
            text: "City: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: cityName
            anchors {
                left: citynameLabel.right
                top: postCodeLabel.bottom
                topMargin: 5
                leftMargin: 10
            }

            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            text: city
        }

        //! Displaying country
        Label {
            id: countrynameLabel
            anchors { left: parent.left; top: citynameLabel.bottom; topMargin: 5; leftMargin: 16 }
            text: "Country: "
            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
        }

        Label {
            id: countryName
            anchors {
                left: countrynameLabel.right
                top: citynameLabel.bottom
                topMargin: 5
                leftMargin: 10
            }

            font.pixelSize: _STANDARD_FONT_SIZE
            color: _TEXT_COLOR
            text: country
        }

        //! Drop down and up of rectangle implementation with states and transitions.
        states: [
            State {
                //! Defining "open" state
                name: "open"
                PropertyChanges {
                    target: infoContainer
                    height: countrynameLabel.y + 39
                }
                PropertyChanges {
                    target: latlabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: lattextLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: longtextLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: timelabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: timestampLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: posmethodlabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: sourceLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: streetName
                    opacity: 1.0
                }
                PropertyChanges {
                    target: streetnameLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: postCodeLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: postalCode
                    opacity: 1.0
                }
                PropertyChanges {
                    target: citynameLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: cityName
                    opacity: 1.0
                }
                PropertyChanges {
                    target: countrynameLabel
                    opacity: 1.0
                }
                PropertyChanges {
                    target: countryName
                    opacity: 1.0
                }
                PropertyChanges {
                    target: streetNameClose
                    opacity: 0.0
                }
                PropertyChanges {
                    target: streetnameLabelClose
                    opacity: 0.0
                }
            },

            State {
                //! Defining "close" state
                name: "close"
                PropertyChanges {
                    target: infoContainer
                    height: 60
                }
                PropertyChanges {
                    target: streetNameClose
                    opacity: 1.0
                }
                PropertyChanges {
                    target: streetnameLabelClose
                    opacity: 1.0
                }
                PropertyChanges {
                    target: latlabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: lattextLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: longtextLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: timelabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: timestampLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: posmethodlabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: sourceLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: postCodeLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: postalCode
                    opacity: 0.0
                }
                PropertyChanges {
                    target: citynameLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: cityName
                    opacity: 0.0
                }
                PropertyChanges {
                    target: countrynameLabel
                    opacity: 0.0
                }
                PropertyChanges {
                    target: countryName
                    opacity: 0.0
                }
                PropertyChanges {
                    target: streetName
                    opacity: 0.0
                }
                PropertyChanges {
                    target: streetnameLabel
                    opacity: 0.0
                }
            }
        ]

        //! Animating transitions between states
        transitions: [
            Transition {
                from: "open"; to: "close"
                reversible: true
                ParallelAnimation {
                    PropertyAnimation {
                        target: infoContainer
                        properties: "height"; duration: 300
                        easing.type: Easing.OutQuad
                    }

                    SequentialAnimation {
                        ParallelAnimation {
                            PropertyAnimation {
                                target: countrynameLabel
                                properties: "opacity"; duration: 10
                            }
                            PropertyAnimation {
                                target: countryName
                                properties: "opacity"; duration: 10
                            }
                            PropertyAnimation {
                                target: citynameLabel
                                properties: "opacity"; duration: 20
                            }
                            PropertyAnimation {
                                target: cityName
                                properties: "opacity"; duration: 20
                            }
                            PropertyAnimation {
                                target: postCodeLabel
                                properties: "opacity"; duration: 40
                            }
                            PropertyAnimation {
                                target: postalCode
                                properties: "opacity"; duration: 40
                            }
                        }

                        ParallelAnimation {
                            PropertyAnimation {
                                target: latlabel
                                properties: "opacity"; duration: 100
                            }
                            PropertyAnimation {
                                target: lattextLabel
                                properties: "opacity"; duration: 100
                            }
                            PropertyAnimation {
                                target: longtextLabel
                                properties: "opacity"; duration: 100
                            }
                            PropertyAnimation {
                                target: timelabel
                                properties: "opacity"; duration: 70
                            }
                            PropertyAnimation {
                                target: timestampLabel
                                properties: "opacity"; duration: 70
                            }
                            PropertyAnimation {
                                target: posmethodlabel
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: sourceLabel
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: streetName
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: streetnameLabel
                                properties: "opacity"; duration: 50
                            }
                        }
                        ParallelAnimation {
                            PropertyAnimation {
                                target: streetNameClose
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: streetnameLabelClose
                                properties: "opacity"; duration: 50
                            }
                        }
                    }
                }
            }
            ,
            Transition {
                from: "close"; to: "open"
                reversible: true

                ParallelAnimation {
                    PropertyAnimation {
                        target: infoContainer
                        properties: "height"; duration: 300
                        easing.type: Easing.OutQuad
                    }

                    SequentialAnimation {
                        ParallelAnimation {
                            PropertyAnimation {
                                target: streetNameClose
                                properties: "opacity"; duration: 1
                            }
                            PropertyAnimation {
                                target: streetnameLabelClose
                                properties: "opacity"; duration: 1
                            }
                            PropertyAnimation {
                                target: latlabel
                                properties: "opacity"; duration: 1
                            }
                            PropertyAnimation {
                                target: lattextLabel
                                properties: "opacity"; duration: 1
                            }
                            PropertyAnimation {
                                target: longtextLabel
                                properties: "opacity"; duration: 20
                            }
                            PropertyAnimation {
                                target: timelabel
                                properties: "opacity"; duration: 40
                            }
                            PropertyAnimation {
                                target: timestampLabel
                                properties: "opacity"; duration: 60
                            }
                            PropertyAnimation {
                                target: posmethodlabel
                                properties: "opacity"; duration: 80
                            }
                            PropertyAnimation {
                                target: sourceLabel
                                properties: "opacity"; duration: 80
                            }
                        }

                        ParallelAnimation {
                            PropertyAnimation {
                                target: streetName
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: streetnameLabel
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: citynameLabel
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: cityName
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: countrynameLabel
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: countryName
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: postCodeLabel
                                properties: "opacity"; duration: 50
                            }
                            PropertyAnimation {
                                target: postalCode
                                properties: "opacity"; duration: 50
                            }
                        }
                    }
                }
            }
        ]

        //! Image for shadow at the bottom of information panel
        Image {
            id: shadowSource
            source: "image://theme/meegotouch-menu-shadow-bottom"
            width: parent.width
            height: 10
            y:infoRect.height -10
            anchors.top: infoRect.bottom
        }

    }

    //! Dropdown button image changing depending on state
    Image {
        id: dropDownButton

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: -12
        }

        source: "image://theme/meegotouch-editor-expand-button-inverted-background"
                + (expandButtonArea.pressed ? "-pressed" : "")

        Image {
            id: triangleImg
            source: "../images/icon-s-common-expand.png"
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            scale: 0.8
            state: "close"

            //! Defining states
            states: [
                State {
                    name: "open"
                    PropertyChanges {
                        target: triangleImg
                        source: "../images/icon-s-common-collapse.png"
                    }
                },

                State {
                    name: "close"
                    PropertyChanges {
                        target: triangleImg
                        source: "../images/icon-s-common-expand.png"
                    }
                }
            ]
        }

        //! Mouse area for handling when we need to open and close the info panel
        MouseArea {
            id: expandButtonArea
            anchors.fill: parent

            //! When clicked, we need to change state
            onClicked: {
                if (infoRect.state ===  "open") {
                    infoRect.state= "close"
                    triangleImg.state = "close"
                } else {
                    infoRect.state = "open"
                    triangleImg.state = "open"
                }
            }
        }
    }
}
