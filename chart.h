#ifndef CHART_H
#define CHART_H

#include <QDeclarativeItem>
#include <QPainter>

class Chart : public QDeclarativeItem
{
    Q_OBJECT

public:
    Chart(QDeclarativeItem *parent = 0);
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    Q_INVOKABLE void addPoint(int y, int lineType);
    Q_INVOKABLE void updateChart();
    Q_INVOKABLE void setCurrentHightlight(int column);

private:
    int convertValues(double value);

    QList<double> pointsX;
    QList<double> pointsY;
    QList<double> pointsZ;
    //! Number of a column to hightlight
    int currentHightlight;
    int divideCounter;

};

QML_DECLARE_TYPE(Chart)

#endif // CHART_H
