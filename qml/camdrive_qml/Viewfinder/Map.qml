import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2
import GeoCoder 1.0

Page {
    id: locationPage

    tools: ToolBarLayout {
        id: toolBar

        ToolIcon { platformIconId: "toolbar-back";
            anchors.left: parent.left
            onClicked: {
                viewfinderPage.resumeRecording();
                hideToolbar();
                pageStack.pop();
            }
        }
    }

    property string latitude: ""
    property string longitude: ""

    //! Check if application is active, stop position updates if not
    Connections {
        target: Qt.application

        onActiveChanged: {
            if (Qt.application.active) {
                positionSource.start()
                informationPanel.spinnerRunning = true
            } else {
                positionSource.stop()
            }
        }
    }

    /*!
     * Function to return the string of the positioning method currently used
     *
     * Function returns string representation of current positioning method or "Source error"
     * if method of the position source undefined.
     */
    function positioningMethodType(method) {
        if (method === PositionSource.SatellitePositioningMethod)
            return "Satellite"
        else if (method === PositionSource.NoPositioningMethod)
            return "Not available"
        else if (method === PositionSource.NonSatellitePositioningMethod)
            return "Non-satellite"
        else if (method === PositionSource.AllPositioningMethods)
            return "All/multiple"
        return "Source error"
    }

    /*!
     * Function to update positioning information displayed in information panel
     *
     * Function used to set values of string properties for updating coordinates, timestamp
     * and positioning method.
     * It is called every time when a position update has been received from the location source.
     */
    function updateGeoInfo() {
        informationPanel.latitude = locationPage.latitude
        informationPanel.longitude = locationPage.longitude
        informationPanel.updateTime =
                Qt.formatDateTime(positionSource.position.timestamp, "yyyy-MM-dd hh:mm:ss")
        informationPanel.positioningMethod =
                positioningMethodType(positionSource.positioningMethod)
    }

    /*!
     * Function to street address information in information panel
     *
     * Function used to set values of string properties for updating street,
     * postal code and city name.
     * It is called every time reverse geocoding information received.
     */
    function updateStreetInfo(postal, street, city, country) {
        informationPanel.spinnerRunning = false
        informationPanel.postal = postal
        informationPanel.street = street
        informationPanel.city = city
        informationPanel.country = country
    }

    Rectangle {
        id : mapview
        height: parent.height
        width: parent.width

        Map {
            id: map
            plugin : Plugin {
                name : "nokia";

                //! Location requires usage of app_id and token parameters.
                //! Values below are for testing purposes only, please obtain real values.
                parameters: [
                    PluginParameter { name: "app_id"; value: "APPID" },
                    PluginParameter { name: "token"; value: "TOKEN" }
                ]
            }

            anchors.fill: parent
            size { width: parent.width; height: parent.height }
            center: positionSource.position.coordinate
            mapType: Map.StreetMap
            zoomLevel: maximumZoomLevel - 1

            //! Icon to display the tapped position
            MapImage {
                id: mapPlacer
                source: _ICON_LOCATION + "icon-m-common-location-selected.png"
                visible: false

                /*!
                 * We want that bottom middle edge of icon points to the location,
                 * so using offset parameter to change the on-screen position from coordinate.
                 * Values are calculated based on icon size, in our case icon is 48x48.
                 */
                offset.x: -24
                offset.y: -48
            }

            MapCircle {
                id: positionMarker
                center: positionSource.position.coordinate
                radius: 3
                color: "green"
                border { width: 10; color: "green" }
            }
        }

        PinchArea {
            id: pincharea

            property double __oldZoom

            anchors.fill: parent

            function calcZoomDelta(zoom, percent) {
                return zoom + Math.log(percent)/Math.log(2)
            }

            onPinchStarted: {
                __oldZoom = map.zoomLevel
            }

            onPinchUpdated: {
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }

            onPinchFinished: {
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }
        }

        MouseArea {
            id: mousearea

            property bool __isPanning: false

            property int __lastX: -1
            property int __lastY: -1

            anchors.fill: parent

            onPressed: {
                __isPanning = true
                __lastX = mouse.x
                __lastY = mouse.y
            }

            onReleased: {
                __isPanning = false
            }

            onPositionChanged: {
                if (__isPanning) {
                    var dx = mouse.x - __lastX
                    var dy = mouse.y - __lastY
                    map.pan(-dx, -dy)
                    __lastX = mouse.x
                    __lastY = mouse.y
                }
            }

            onCanceled: {
                __isPanning = false;
            }

            onDoubleClicked: {
                map.center = map.toCoordinate(Qt.point(__lastX,__lastY))
                if (map.zoomLevel < map.maximumZoomLevel ) map.zoomLevel += 1
            }

            onPressAndHold: {
                informationPanel.spinnerRunning = true
                mapPlacer.coordinate = map.toCoordinate(Qt.point(__lastX,__lastY))
                mapPlacer.visible = true
                locationPage.latitude = mapPlacer.coordinate.latitude
                locationPage.longitude = mapPlacer.coordinate.longitude
                reverseGeoCode.coordToAddress(mapPlacer.coordinate.latitude,
                                              mapPlacer.coordinate.longitude)
                updateGeoInfo()
            }
        }
    }

    MapInfoPanel {
        id: informationPanel
    }

    PositionSource {
        id: positionSource

        updateInterval: 10000
        active: true

        onPositionChanged: {
            if (!mapPlacer.visible) {
                locationPage.latitude = position.coordinate.latitude
                locationPage.longitude = position.coordinate.longitude
                reverseGeoCode.coordToAddress(position.coordinate.latitude,
                                              position.coordinate.longitude)
                updateGeoInfo()
            }
        }
    }

    GeoCoder {
        id:reverseGeoCode

        //! When reverse geocoding info received, update street address in information panel
        onReverseGeocodeInfoRetrieved: updateStreetInfo(postCode, streetadd, cityname, countryName)
    }
}
