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
    int spacer = width() / number;
    //int width = number * spacer;
    divideCounter = 0;

    while (true) {
        if (spacer == 0) {
            number = number / 2;
            spacer = this->width() / number;
            divideCounter++;
        }
        else
            break;
    }

  //  painter->setPen(backgroundColumns);

  //  painter->drawRect(0, 0, width + 1, height());
    //painter->fillRect(0, 0, width, this->height(), QColor("#000400"));

  //  for (int i = 0; i <= number; i++)
  //      painter->drawLine((i * spacer) + 1, 0, (i * spacer) + 1, height());

    //! Highlight column
    painter->setPen(hightlightColumn);
    painter->drawLine((currentHightlight-1) * spacer, 0, (currentHightlight-1) * spacer, height());

    //! Draw horizontal line
    painter->setPen(horizontalLinePen);
    painter->drawLine(0, (this->height() / 2) - 1, width(), (this->height() / 2) - 1);

    painter->setPen(penX);

    int tmp;

    for (int i = 1; i < pointsX.length(); i++) {
        if (divideCounter != 0)
            tmp = i / (divideCounter * 2);
        else
            tmp = i;

        if (divideCounter != 0) {
            if (i % (divideCounter * 2) == 0) {
                painter->drawLine((tmp - 1) * spacer, convertValues(pointsX.at(tmp - 1)), tmp * spacer, convertValues(pointsX.at(tmp)));
            }
        }
        else
            painter->drawLine((tmp - 1) * spacer, convertValues(pointsX.at(tmp - 1)), tmp * spacer, convertValues(pointsX.at(tmp)));
    }

    painter->setPen(penY);

    for (int i = 1; i < pointsY.length(); i++) {
        if (divideCounter != 0)
            tmp = i / (divideCounter * 2);
        else
            tmp = i;

        if (divideCounter != 0) {
            if (i % (divideCounter * 2) == 0) {
                painter->drawLine((tmp - 1) * spacer, convertValues(pointsY.at(tmp - 1)), tmp * spacer, convertValues(pointsY.at(tmp)));
            }
        }
        else
            painter->drawLine((tmp - 1) * spacer, convertValues(pointsY.at(tmp - 1)), tmp * spacer, convertValues(pointsY.at(tmp)));
    }

    painter->setPen(penZ);

    for (int i = 1; i < pointsZ.length(); i++) {
        if (divideCounter != 0)
            tmp = i / (divideCounter * 2);
        else
            tmp = i;

        if (divideCounter != 0) {
            if (i % (divideCounter * 2) == 0) {
                painter->drawLine((tmp - 1) * spacer, convertValues(pointsZ.at(tmp - 1)), tmp * spacer, convertValues(pointsZ.at(tmp)));
            }
        }
        else
            painter->drawLine((tmp - 1) * spacer, convertValues(pointsZ.at(tmp - 1)), tmp * spacer, convertValues(pointsZ.at(tmp)));
    }
}

int Chart::convertValues(double value)
{
    int maxValue = this->height() / 2;
    int currValue = (maxValue * value) / 22;

    return maxValue - currValue;
}

void Chart::updateChart()
{
    update(0, 0, this->width(), this->height());
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
    //! Number of all points
    int number = pointsX.size();

    if (column <= number) {
        if (divideCounter != 0)
            column = column / (divideCounter * 2);
        if (column == 0)
            column = 1;
        qDebug() << "new column" << column;
        currentHightlight = column;
        update(0, 0, this->width(), this->height());
    }
}
