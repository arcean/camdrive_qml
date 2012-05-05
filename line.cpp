#include <QDebug>
#include "line.h"

Line::Line(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    //! Important, otherwise the paint method is never called
    setFlag(QGraphicsItem::ItemHasNoContents, false);

}

void Line::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    //! Color and width
    QPen penX(QColor("#5BB600"), 2);
    QPen penY(QColor("#5B00B6"), 2);
    QPen penZ(QColor("#B6005B"), 2);
    QPen penXbackground(QColor("#0F2D00"), 2);
    QPen penYbackground(QColor("#0F002D"), 2);
    QPen penZbackground(QColor("#2D000F"), 2);
    QPen horizontalLinePen(QColor("#0F2D00"), 2);

    if(smooth() == true) {
        painter->setRenderHint(QPainter::Antialiasing, true);
    }

    if (this->lineType == 2) {
        painter->fillRect(0, 0, this->width(), this->height(), QColor("#0F002D"));
        painter->fillRect(0, 0, lineValue, this->height(), QColor("#5B00B6"));
    }
    else if (this->lineType == 3) {
        painter->fillRect(0, 0, this->width(), this->height(), QColor("#2D000F"));
        painter->fillRect(0, 0, lineValue, this->height(), QColor("#B6005B"));
    }
    else {
        painter->fillRect(0, 0, this->width(), this->height(), QColor("#0F2D00"));
        painter->fillRect(0, 0, lineValue, this->height(), QColor("#5BB600"));
    }
}

void Line::setValue(double value)
{
    qDebug() << "rec value" << value;
    this->lineValue = (this->width() * value) / 22;
    qDebug() << "lin value " << lineValue;
    this->update(0, 0, this->width(), this->height());
    emit valueChanged();
}

void Line::setType(int type)
{
    this->lineType = type;
    this->update(0, 0, this->width(), this->height());
    emit typeChanged();
}
