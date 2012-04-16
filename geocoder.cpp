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

/*!
 * INCLUDES
 */
#include "reversegeocode.h"

/*!
 * Constructor is called when the instance is created. We get access to geocoding services and
 * also start listening for the finished signal from instance of QGeoSearchManager class.
 */
GeoCoder::GeoCoder(QObject *parent) :
    QObject(parent)
{
    //! Create instance of QGeoServiceProvider for accessing "nokia" location plugin.
    m_provider = new QGeoServiceProvider("nokia");
    Q_ASSERT(m_provider);

    //! Create instance of QGeoSearchManager for accessing geocoding services.
    m_searchManager = m_provider->searchManager();
    Q_ASSERT(m_searchManager);

    //! Start listening for the signal QGeoSearchManager::finished
    connect(m_searchManager, SIGNAL(finished(QGeoSearchReply*)), this, SLOT(searchFinished(QGeoSearchReply*)));
}

/*!
 * Destructor is called when instance is to be destroyed.
 */
GeoCoder::~GeoCoder()
{
    //! Check if pointer to QGeoServiceProvider class instance exists
    if (!m_provider) return;

    //! Destroy created instance
    delete m_provider;
}

/*!
 * Retrieve reverse geocoding info via QGeoSearchManager::reverseGeoCode()
 */
void GeoCoder::coordToAddress(QString latitude, QString longitude)
{
    //! Get coordinate from latitude and longitude
    QGeoCoordinate coord = QGeoCoordinate(latitude.toDouble(), longitude.toDouble());

    //! Start reverse geocoding
    m_searchManager->reverseGeocode(coord);
}

/*!
 * Slot connected to QGeoSearchManager::finished signal and emits reverseGeocodeInfoRetrieved
 */
void GeoCoder::searchFinished(QtMobility::QGeoSearchReply *reply)
{
    QList<QGeoPlace> places = reply->places();

    if (places.size() > 0) {
        //! Save received values
        this->m_city = places.at(0).address().city();
        this->m_streetAddress = places.at(0).address().street();
        this->m_postalCode = places.at(0).address().postcode();
        this->m_country = places.at(0).address().country();

        //! Emit reverseGeocodeInfoRetrieved signal
        emit reverseGeocodeInfoRetrieved(this->m_country, this->m_postalCode, this->m_city, this->m_streetAddress);
    }
}

//! End of File
