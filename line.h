#ifndef LINE_H
#define LINE_H

#include <QDeclarativeItem>
#include <QPainter>

class Line : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged);
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged);

public:
    explicit Line(QDeclarativeItem *parent = 0);
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    void setValue(double value);
    void setType(int type);

    int type() const { return lineType; }
    int value() const { return realLineValue; }

signals:
    void typeChanged();
    void valueChanged();

private:
    int convertValues(double value);

    double lineValue;
    double realLineValue;
    int lineType;
};

QML_DECLARE_TYPE(Line)

#endif // LINE_H
