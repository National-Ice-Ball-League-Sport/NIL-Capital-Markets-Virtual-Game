#pragma once

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QVector>

class MarketModel final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double cash READ cash NOTIFY accountChanged)
    Q_PROPERTY(double equity READ equity NOTIFY accountChanged)
    Q_PROPERTY(QVariantList assets READ assets NOTIFY assetsChanged)
    Q_PROPERTY(QVariantList positions READ positions NOTIFY positionsChanged)
    Q_PROPERTY(QString message READ message NOTIFY messageChanged)

public:
    explicit MarketModel(QObject *parent = nullptr);

    double cash() const;
    double equity() const;
    QVariantList assets() const;
    QVariantList positions() const;
    QString message() const;

    Q_INVOKABLE void simulateTick();
    Q_INVOKABLE void placeVirtualBuy(const QString &symbol, int quantity);

signals:
    void accountChanged();
    void assetsChanged();
    void positionsChanged();
    void messageChanged();

private:
    struct Asset {
        QString symbol;
        QString sport;
        double price;
        double modelValue;
        int readiness;
    };

    struct Position {
        QString symbol;
        int quantity;
        double averageCost;
    };

    Asset *findAsset(const QString &symbol);
    const Asset *findAsset(const QString &symbol) const;
    void setMessage(const QString &message);

    QVector<Asset> m_assets;
    QVector<Position> m_positions;
    double m_cash = 100000.0;
    QString m_message = QStringLiteral("Demo mode · virtual account");
};
