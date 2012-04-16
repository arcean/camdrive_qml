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

#ifndef REVERSEGEOCODE_H
#define REVERSEGEOCODE_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <QGeoServiceProvider>
#include <QGeoSearchManager>
#include <qstring.h>

QTM_USE_NAMESPACE

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class GeoCoder reversegeocode.h location/reversegeocode.h
 * @brief Class inherited from QObject allow access to location services,
 * which get geographical information and converts GEO coordinates to street address.
 *
 * QGeoServiceProvider class which is part of QtMobility allows the application
 * to access plugins related to location like Nokia Plugin.
 * QGeoSearchManager class provides support for searching operations related to
 * geographic information.
 */
class GeoCoder : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class GeoCoder.
     * In constructor we create instance of QGeoServiceProvider class
     * to access "nokia" location plugin and get access to geocoding services.
     * @param *parent A pointer to the parent object.
     */
    explicit GeoCoder(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class GeoCoder.
     */
    ~GeoCoder();

    /*!
     * @brief A member function
     *
     * Function invokable from QML environment and initiates reverse geocoding of coordinate.
     * Reverse geocoding is the process of finding an address that corresponds
     * to a given coordinate.
     * @param latitude Latitude coordinate of geographic location point
     * @param longitude Longitude coordinate of geographic location point
     * @return void
     */
    Q_INVOKABLE void coordToAddress(QString latitude, QString longitude);

private slots:
    /*!
     * @brief A member function
     *
     * Slot called when QGeoSearchManager::finished signal is emitted. In turn it emits signal
     * reverseGeocodeInfoRetrieved() for updating the city,street and postal code values.
     * @param reply Pointer to the QGeoSearchReply with result of geocoding operation.
     * @return void
     */
    void searchFinished(QGeoSearchReply *reply);

signals :
    /*!
     * @brief Signal
     *
     * Signal emitted when the reverse geocode information
     * is available and its emission is interpreted in the QML code.
     * @param country Country of geographic location point
     * @param postCode Postal code of geographic location point
     * @param cityname City of geographic location point
     * @param streetadd Street address of geographic location point
     * @return void
     */
    void reverseGeocodeInfoRetrieved(QString countryName, QString postCode, QString cityname, QString streetadd);

private:
    /*!
     * @brief Pointer to the QGeoServiceProvider class which allows the application
     * to access plugins related to location.
     */
    QGeoServiceProvider *m_provider;

    /*!
     * @brief Pointer to the QGeoSearchManager class which provides support for searching
     * operations related to geographic information.
     */
    QGeoSearchManager *m_searchManager;

    /*!
     * @brief Used to store street address
     */
    QString m_streetAddress;

    /*!
     * @brief Used to store m_city name
     */
    QString m_city;

    /*!
     * @brief Used to store postal code
     */
    QString m_postalCode;

    /*!
     * @brief Used to store country
     */
    QString m_country;
};

#endif // REVERSEGEOCODE_H
