#ifndef TELEPHONY_H
#define TELEPHONY_H

#include <QObject>
#include <QMessageService>
#include <QDeclarativeContext>
#include <QSystemNetworkInfo>
#include <qmdevicemode.h>

QTM_USE_NAMESPACE
using namespace MeeGo;

class Telephony : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString deviceMode READ deviceMode NOTIFY deviceModeChanged)
    Q_PROPERTY(QString psmState READ psmState NOTIFY psmStateChanged)

public:
    explicit Telephony(QObject *parent = 0);
    ~Telephony();

    QString deviceMode() const;
    QString psmState() const;

    Q_INVOKABLE bool call(const QString& number);
    Q_INVOKABLE bool sendSMS(const QString &to, const QString &text);

    Q_INVOKABLE void initialiseMessageService();
    Q_INVOKABLE bool networkStatus();
    Q_INVOKABLE bool isContactsAvailable(bool nfcAddressBook);

signals:
    void error(const QString& msg);
    void stateChanged(bool state);
    void deviceModeChanged();
    void psmStateChanged();

public slots:
    void currentState(QMessageService::State newState);

private:
    QMessageService *m_pMessageService;
    QSystemNetworkInfo *m_networkInfo;
    QmDeviceMode *m_deviceMode;
    bool m_smsState;

};

#endif // TELEPHONY_H
