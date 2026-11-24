#include "MarketModel.h"

#include <QSettings>
#include <QTemporaryDir>
#include <QTest>

class MarketModelTests final : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void startsWithDemoBalance();
    void buysVirtualPositionAndUpdatesAverageCost();
    void rejectsInvalidAndUnaffordableOrders();
    void persistsAndRestoresPaperAccount();
};

void MarketModelTests::initTestCase()
{
    QCoreApplication::setOrganizationName(QStringLiteral("BIM-APES-Tests"));
    QCoreApplication::setApplicationName(QStringLiteral("NilMarketsTests"));
}

void MarketModelTests::startsWithDemoBalance()
{
    MarketModel model(nullptr, false);
    QCOMPARE(model.cash(), 100000.0);
    QCOMPARE(model.equity(), 100000.0);
    QVERIFY(model.positions().isEmpty());
    QCOMPARE(model.assets().size(), 5);
}

void MarketModelTests::buysVirtualPositionAndUpdatesAverageCost()
{
    MarketModel model(nullptr, false);
    model.placeVirtualBuy(QStringLiteral("HOOP"), 10);
    QCOMPARE(model.cash(), 99600.0);
    QCOMPARE(model.positions().size(), 1);
    const QVariantMap first = model.positions().first().toMap();
    QCOMPARE(first.value(QStringLiteral("quantity")).toInt(), 10);
    QCOMPARE(first.value(QStringLiteral("averageCost")).toDouble(), 40.0);

    model.placeVirtualBuy(QStringLiteral("HOOP"), 5);
    QCOMPARE(model.cash(), 99400.0);
    const QVariantMap combined = model.positions().first().toMap();
    QCOMPARE(combined.value(QStringLiteral("quantity")).toInt(), 15);
    QCOMPARE(combined.value(QStringLiteral("averageCost")).toDouble(), 40.0);
}

void MarketModelTests::rejectsInvalidAndUnaffordableOrders()
{
    MarketModel model(nullptr, false);
    model.placeVirtualBuy(QStringLiteral("HOOP"), 0);
    model.placeVirtualBuy(QStringLiteral("HOOP"), 10001);
    model.placeVirtualBuy(QStringLiteral("UNKNOWN"), 1);
    model.placeVirtualBuy(QStringLiteral("HOOP"), 2501);
    QCOMPARE(model.cash(), 100000.0);
    QVERIFY(model.positions().isEmpty());
}

void MarketModelTests::persistsAndRestoresPaperAccount()
{
    QTemporaryDir temp;
    QVERIFY(temp.isValid());
    QSettings::setDefaultFormat(QSettings::IniFormat);
    QSettings::setPath(QSettings::IniFormat, QSettings::UserScope, temp.path());
    {
        MarketModel model;
        model.placeVirtualBuy(QStringLiteral("HOOP"), 12);
        QCOMPARE(model.cash(), 99520.0);
    }
    {
        MarketModel restored;
        QCOMPARE(restored.cash(), 99520.0);
        QCOMPARE(restored.positions().size(), 1);
        const QVariantMap position = restored.positions().first().toMap();
        QCOMPARE(position.value(QStringLiteral("symbol")).toString(), QStringLiteral("HOOP"));
        QCOMPARE(position.value(QStringLiteral("quantity")).toInt(), 12);
        QCOMPARE(position.value(QStringLiteral("averageCost")).toDouble(), 40.0);
    }
}

QTEST_GUILESS_MAIN(MarketModelTests)
#include "MarketModelTests.moc"
