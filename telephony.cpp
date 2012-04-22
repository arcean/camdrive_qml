#include <QtDBus>
#include <QDebug>
#include <QDBusConnection>
#include <QContactManager>
#include <QContactPhoneNumber>
#include <QContactName>
#include <QContactNickname>

#include "telephony.h"

QTM_USE_NAMESPACE

/*!
 * Constructor method for the class Telephony
 */

Telephony::Telephony(QObject *parent) :
    QObject(parent),
    m_pMessageService(NULL),
    m_networkInfo(NULL),
    m_deviceMode(NULL)
{
    //! Create instance of QmDeviceMode for accessing its methods. Memory allocated from heap.
    m_deviceMode = new QmDeviceMode();
    Q_ASSERT(m_deviceMode);

    //! Emit signal when device operation mode changed
    connect(m_deviceMode, SIGNAL(deviceModeChanged(MeeGo::QmDeviceMode::DeviceMode)), this, SIGNAL(deviceModeChanged()));

    //! Notify when device powersave mode changed
    connect(m_deviceMode, SIGNAL(devicePSMStateChanged(MeeGo::QmDeviceMode::PSMState)), this, SIGNAL(psmStateChanged()));
}

/*!
 * Destructor
 */
Telephony::~Telephony()
{
    if (m_networkInfo != NULL)
        delete m_networkInfo;

    if (m_pMessageService != NULL)
        delete m_pMessageService;

    //! Check if pointer to QmDeviceMode class instance exists
    if (!m_deviceMode) return;

    //! Destroy created instance
    delete m_deviceMode;
}

/*!
 * Function to read current device operation mode (e.g. Normal or Flight mode)
 * and convert result to string that can be displayed to user.
 */
QString Telephony::deviceMode() const
{
    QString str;

    switch ( m_deviceMode->getMode() ) {
    case QmDeviceMode::Normal:
        str = "Normal";
        break;
    case QmDeviceMode::Flight:
        str = "Flight mode";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to read current device powersave mode and convert result to string that can be
 * displayed to user
 */
QString Telephony::psmState() const
{
    QString str;

    switch ( m_deviceMode->getPSMState() ) {
    case QmDeviceMode::PSMStateOn:
        str = "On";
        break;
    case QmDeviceMode::PSMStateOff:
        str = "Off";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Called from QML code to initialize message service
 */
void Telephony::initialiseMessageService()
{
    m_pMessageService = new QMessageService(this);

    //! Check for validity of m_pMS
    Q_ASSERT(m_pMessageService);

    //! Initialize the SMS state to False
    m_smsState = false;

    //! Connect with the QMessageService and initialize the QMessageService
    connect(m_pMessageService,SIGNAL(stateChanged(QMessageService::State)),
            this,SLOT(currentState(QMessageService::State)));
}

/*!
 * Function to emit QMessageService when state Changed
 */
void Telephony::currentState(QMessageService::State state)
{
    //! Verify if the message is send
    if (state == QMessageService::FinishedState) {
        m_smsState = true;
        emit stateChanged(m_smsState);
    }
    //! Verify if the message is cancelled
    else if (state == QMessageService::CanceledState) {
        m_smsState = false;
        emit stateChanged(m_smsState);
    }
}

/*!
 * Called from QML code to check the network status
 */
bool Telephony::networkStatus()
{
    //! Verifies the network status supported by the device and set the return value accordingly
    m_networkInfo = new QSystemNetworkInfo();

    //! Check for validity of m_networkInfo
    Q_ASSERT(m_networkInfo);

    if ((m_networkInfo->networkStatus(QSystemNetworkInfo::GsmMode) == QSystemNetworkInfo::HomeNetwork)
        || (m_networkInfo->networkStatus(QSystemNetworkInfo::GsmMode) == QSystemNetworkInfo::Roaming)) {
        return true;
    } else if ((m_networkInfo->networkStatus(QSystemNetworkInfo::CdmaMode) == QSystemNetworkInfo::HomeNetwork)
        || (m_networkInfo->networkStatus(QSystemNetworkInfo::CdmaMode) == QSystemNetworkInfo::Roaming)) {
        return true;
    } else if ((m_networkInfo->networkStatus(QSystemNetworkInfo::WcdmaMode) == QSystemNetworkInfo::HomeNetwork)
        || (m_networkInfo->networkStatus(QSystemNetworkInfo::WcdmaMode) == QSystemNetworkInfo::Roaming)) {
        return true;
    } else if ((m_networkInfo->networkStatus(QSystemNetworkInfo::LteMode) == QSystemNetworkInfo::HomeNetwork)
        || (m_networkInfo->networkStatus(QSystemNetworkInfo::LteMode) == QSystemNetworkInfo::Roaming)) {
        return true;
    } else {
        return false;
    }
}

/*!
 * Called from QML code to check the contacts availability
 */
bool Telephony::isContactsAvailable(bool nfcAddressBook)
{
    QContactManager *contactManager = new QContactManager();

    //! Getting all the contact Ids
    QList<QContactLocalId> contactLocalId = contactManager->contactIds();
    QList<QContactLocalId>::iterator it;

    if(nfcAddressBook) {
        //! Iterating each contain to know either contact has name or not
        for (it = contactLocalId.begin(); it != contactLocalId.end(); ++it)
        {
            QContact contact = contactManager->contact(*it);
            QContactName name = contact.detail<QContactName>();
            QContactNickname nickname = contact.detail<QContactNickname>();

            //! Checking for contact name. If contact name is present, return true
            if(name.firstName() != "" || name.lastName() != "" || nickname.nickname() != "")
                return true;
        }
        return false;

    } else {

        //! Iterating each contain to know either contact has number or not
        for (it = contactLocalId.begin(); it != contactLocalId.end(); ++it)
        {
          QContact contact = contactManager->contact(*it);
          QContactPhoneNumber no = contact.detail<QContactPhoneNumber>();

          //! Checking for contact number. If contact number is present, return true
          if (no.number() != "") {
               return true;
          }
        }

        return false;
    }
}

/*!
 * Called from QML code with phone number and messageText content as
 * arguments inorder to send the SMS
 */
bool Telephony::sendSMS(const QString &to, const QString &text)
{
    bool ret = false;

    //! Verify the send number and the text
    if (m_pMessageService && to.size() && text.size()) {
        QMessage m;
        m.setType(QMessage::Sms);
        m.setBody(text);
        m.setTo(QMessageAddress(QMessageAddress::Phone, to));

        ret = m_pMessageService->send(m);
    }

    return ret;
}

bool Telephony::call(const QString& number){
    QDBusMessage m = QDBusMessage::createMethodCall("com.nokia.csd.Call",
                                                    "/com/nokia/csd/call",
                                                    "com.nokia.csd.Call",
                                                    "CreateWith");
    m << number;
    m << 0;

    QDBusMessage reply  = QDBusConnection::systemBus().call(m);

    if (!reply.errorMessage().isEmpty()) {
        emit error(reply.errorMessage());
        return false;
    }

    return true;
}

//!  End of File
