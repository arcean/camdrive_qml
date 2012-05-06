#include "chart.h"

Chart::Chart(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    //! Important, otherwise the paint method is never called
    setFlag(QGraphicsItem::ItemHasNoContents, false);

    currentHightlight = 1;
}

void Chart::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    //! Color and width
    QPen penX(QColor("#5BB600"), 2);
    QPen penY(QColor("#5B00B6"), 2);
    QPen penZ(QColor("#B6005B"), 2);
    QPen backgroundColumns(QColor("#303335"), 2);
    QPen horizontalLinePen(QColor("#303335"), 2);
    QPen hightlightColumn(QColor("#8D18BE"), 2);

    if(smooth() == true) {
        painter->setRenderHint(QPainter::Antialiasing, true);
    }

    //! Number of all points
    int number = pointsX.size() - 1;
    //! Empty space between colored columns
    int spacer = this->width() / number;
    int width = number * spacer;

    painter->setPen(backgroundColumns);

    painter->drawRect(0, 0, width + 1, this->height());
    //painter->fillRect(0, 0, width, this->height(), QColor("#000400"));

    for (int i = 0; i <= number; i++)
        painter->drawLine((i * spacer) + 1, 0, (i * spacer) + 1, this->height());

    //! Highlight column
    painter->setPen(hightlightColumn);
    painter->drawLine(((this->currentHightlight-1) * spacer) + 1, 0, ((this->currentHightlight-1) * spacer) + 1, this->height());

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

void Chart::updateChart()
{
    this->update(0, 0, this->width(), this->height());
}

void Chart::addPoint(int y, int lineType)
{
    if (y > 22)
        y = 22;

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
}

void Chart::setCurrentHightlight(int column)
{
    this->currentHightlight = column;
    this->update(0, 0, this->width(), this->height());
}
