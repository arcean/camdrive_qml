#include "chart.h"

Chart::Chart(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    //! Important, otherwise the paint method is never called
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    pointsX.append(2);
    pointsX.append(5);
    pointsX.append(8.5);
    pointsX.append(11);
    pointsX.append(14.5);
    pointsX.append(19);
    pointsX.append(15.3223);
    pointsX.append(12.1212);
    pointsX.append(-2.32);
    pointsX.append(0);
    pointsX.append(0.43);
    pointsX.append(-12.54);

    pointsY.append(12);
    pointsY.append(14);
    pointsY.append(12.5);
    pointsY.append(15);
    pointsY.append(17);
    pointsY.append(11);
    pointsY.append(-16);
    pointsY.append(-16.54);
    pointsY.append(-17.32);
    pointsY.append(-14.32);
    pointsY.append(-5.43);
    pointsY.append(-4.3221);

    pointsZ.append(-4);
    pointsZ.append(-5);
    pointsZ.append(-6);
    pointsZ.append(-7);
    pointsZ.append(-8);
    pointsZ.append(-7.6);
    pointsZ.append(-7.4);
    pointsZ.append(-6.4);
    pointsZ.append(-6.1);
    pointsZ.append(-5.4332);
    pointsZ.append(-7.322);
    pointsZ.append(-2.0970);
}

void Chart::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    //! Color and width
    QPen penX(QColor("#5BB600"), 2);
    QPen penY(QColor("#5B00B6"), 2);
    QPen penZ(QColor("#B6005B"), 2);
    QPen backgroundColumns(QColor("#0F2D00"), 2);
    QPen horizontalLinePen(QColor("#0F2D00"), 2);

    if(smooth() == true) {
        painter->setRenderHint(QPainter::Antialiasing, true);
    }

    //! Number of all points
    int number = pointsX.size() - 1;
    //! Empty space between colored columns
    int spacer = this->width() / number;
    int width = number * spacer;

    painter->setPen(backgroundColumns);

    painter->drawRect(0, 0, width, this->height());
    painter->fillRect(0, 0, width, this->height(), QColor("#000400"));

    for (int i = 0; i <= number; i++)
        painter->drawLine(i * spacer, 0, i * spacer, this->height());

    //! Draw horizontal line
    painter->setPen(horizontalLinePen);
    painter->drawLine(0, (this->height() / 2) - 1, width, (this->height() / 2) - 1);

    painter->setPen(penX);

    for (int i = 1; i < pointsX.length(); i++)
        painter->drawLine((i - 1) * spacer, convertValues(pointsX.at(i - 1)), i * spacer, convertValues(pointsX.at(i)));

    painter->setPen(penY);

    for (int i = 1; i < pointsY.length(); i++)
        painter->drawLine((i - 1) * spacer, convertValues(pointsY.at(i - 1)), i * spacer, convertValues(pointsY.at(i)));

    painter->setPen(penZ);

    for (int i = 1; i < pointsZ.length(); i++)
        painter->drawLine((i - 1) * spacer, convertValues(pointsZ.at(i - 1)), i * spacer, convertValues(pointsZ.at(i)));
}

int Chart::convertValues(double value)
{
    int maxValue = this->height() / 2;
    int currValue = (maxValue * value) / 22;

    return maxValue - currValue;
}

void Chart::addPoint(int y, int lineType)
{
    //! Line type: 1 - X, 2 - Y, 3 - Z
    switch (lineType) {
    case 1:
        pointsX.append(y);
        break;
    case 2:
        pointsY.append(y);
        break;
    case 3:
        pointsZ.append(y);
        break;
    default:
        qDebug() << "Unsupported line type [chart]";
    }
    this->update(0, 0, this->width(), this->height());
}
