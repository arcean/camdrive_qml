/****************************************************************************
* This file is part of the Harmattan API Showcase Application.
*
* Copyright © 2012 Nokia Corporation and/or its subsidiary(-ies).
* All rights reserved.
*
* This software, including documentation, is protected by copyright
* controlled by Nokia Corporation.  All rights reserved.  You are
* entitled to use this file in accordance with the Harmattan API
* Showcase Application Agreement.
*
****************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.sensors 1.2

Item {
    Image {
        anchors.fill: parent
        source: "image://theme/meegotouch-applicationpage-background-inverted"
        opacity: 0.6
    }

    height: 50
    width: parent.width

    property alias rotationX: rotationXValue.text
    property alias rotationY: rotationYValue.text
    property alias rotationZ: rotationZValue.text

    property int orientation: 0
    property alias azimuth: azimuthValue.text
    property alias calibrationLevel: calibrationLevelValue.text

    //! Compass related UI Elements
    Row {
        spacing: 6
        anchors { left: parent.left; margins: UiConstants.DefaultMargin;
            verticalCenter: parent.verticalCenter }

        Label { text: "COMPASS" }
        Label { text: "azimuth:" }
        Label { id: azimuthValue; text: "" }
        Label { text: "calibration level:" }
        Label {
            id: calibrationLevelValue; text: ""
            color: ((+(text)+0.0)<1.0) ? "red" : "white"
        }
    }

    //! RotationSensor related UI Elements
    Row {
        spacing: 6
        anchors { margins: UiConstants.DefaultMargin; right: parent.right;
            verticalCenter: parent.verticalCenter }

        Label { text: "ROTATION" }
        Label { text: "x:" }
        Label { id: rotationXValue; text: "" }
        Label { text: "y:" }
        Label { id: rotationYValue; text: "" }
        Label { text: "z:" }
        Label { id: rotationZValue; text: "" }
    }
}

//!  End of File
