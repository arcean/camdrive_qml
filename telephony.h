#ifndef TELEPHONY_H
#define TELEPHONY_H

#include <QObject>
#include <QMessageService>
#include <QDeclarativeContext>
#include <QSystemNetworkInfo>

QTM_USE_NAMESPACE

class Telephony : public QObject
{
    Q_OBJECT
public:
    explicit Telephony(QObject *parent = 0);
    ~Telephony();
    Q_INVOKABLE bool call(const QString& number);
    Q_INVOKABLE bool sendSMS(const QString &to, const QString &text);

    Q_INVOKABLE void initialiseMessageService();
    Q_INVOKABLE bool networkStatus();
    Q_INVOKABLE bool isContactsAvailable(bool nfcAddressBook);

signals:
    void error(const QString& msg);
    void stateChanged(bool state);

public slots:
    void currentState(QMessageService::State newState);

private:
    QMessageService *m_pMessageService;
    QSystemNetworkInfo *m_networkInfo;
    bool m_smsState;

};

#endif // TELEPHONY_H
