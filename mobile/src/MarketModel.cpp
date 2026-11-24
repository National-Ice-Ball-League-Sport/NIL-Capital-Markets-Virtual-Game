#include "MarketModel.h"

#include <QRandomGenerator>
#include <QtMath>

MarketModel::MarketModel(QObject *parent)
    : QObject(parent),
      m_assets{
          {QStringLiteral("HOOP"), QStringLiteral("Basketball"), 40.00, 58.50, 88},
          {QStringLiteral("BOX-STRIKE"), QStringLiteral("Boxing"), 52.00, 67.40, 84},
          {QStringLiteral("HNDL-6M"), QStringLiteral("Team Handball"), 34.50, 43.20, 85},
          {QStringLiteral("RUGBY-GLOU"), QStringLiteral("Rugby"), 61.00, 57.80, 64},
          {QStringLiteral("FBALL-QB"), QStringLiteral("American Football"), 74.00, 88.90, 81}
      }
{
}

double MarketModel::cash() const
{
    return m_cash;
}

double MarketModel::equity() const
{
    double value = m_cash;
    for (const Position &position : m_positions) {
        const Asset *asset = findAsset(position.symbol);
        if (asset)
            value += position.quantity * asset->price;
    }
    return value;
}

QVariantList MarketModel::assets() const
{
    QVariantList result;
    result.reserve(m_assets.size());
    for (const Asset &asset : m_assets) {
        result.append(QVariantMap{
            {QStringLiteral("symbol"), asset.symbol},
            {QStringLiteral("sport"), asset.sport},
            {QStringLiteral("price"), asset.price},
            {QStringLiteral("modelValue"), asset.modelValue},
            {QStringLiteral("spread"), asset.modelValue - asset.price},
            {QStringLiteral("readiness"), asset.readiness}
        });
    }
    return result;
}

QVariantList MarketModel::positions() const
{
    QVariantList result;
    result.reserve(m_positions.size());
    for (const Position &position : m_positions) {
        const Asset *asset = findAsset(position.symbol);
        const double currentPrice = asset ? asset->price : position.averageCost;
        result.append(QVariantMap{
            {QStringLiteral("symbol"), position.symbol},
            {QStringLiteral("quantity"), position.quantity},
            {QStringLiteral("averageCost"), position.averageCost},
            {QStringLiteral("currentPrice"), currentPrice},
            {QStringLiteral("marketValue"), position.quantity * currentPrice},
            {QStringLiteral("pnl"), position.quantity * (currentPrice - position.averageCost)}
        });
    }
    return result;
}

QString MarketModel::message() const
{
    return m_message;
}

void MarketModel::simulateTick()
{
    for (Asset &asset : m_assets) {
        const double move = (QRandomGenerator::global()->generateDouble() - 0.5) * 1.2;
        asset.price = qMax(1.0, asset.price + move);
        asset.price = qRound(asset.price * 100.0) / 100.0;
    }
    emit assetsChanged();
    emit positionsChanged();
    emit accountChanged();
    setMessage(QStringLiteral("Sample market tick generated · demo data only"));
}

void MarketModel::placeVirtualBuy(const QString &symbol, int quantity)
{
    if (quantity <= 0 || quantity > 10000) {
        setMessage(QStringLiteral("Enter a quantity from 1 to 10,000."));
        return;
    }

    Asset *asset = findAsset(symbol);
    if (!asset) {
        setMessage(QStringLiteral("That demo asset is not available."));
        return;
    }

    const double cost = asset->price * quantity;
    if (cost > m_cash) {
        setMessage(QStringLiteral("Insufficient virtual cash for this paper trade."));
        return;
    }

    m_cash -= cost;
    auto position = std::find_if(m_positions.begin(), m_positions.end(),
                                 [&symbol](const Position &item) { return item.symbol == symbol; });
    if (position == m_positions.end()) {
        m_positions.append({symbol, quantity, asset->price});
    } else {
        const int combinedQuantity = position->quantity + quantity;
        position->averageCost = ((position->averageCost * position->quantity) + cost) / combinedQuantity;
        position->quantity = combinedQuantity;
    }

    emit accountChanged();
    emit positionsChanged();
    setMessage(QStringLiteral("Paper buy recorded · no real order was sent"));
}

MarketModel::Asset *MarketModel::findAsset(const QString &symbol)
{
    for (Asset &asset : m_assets) {
        if (asset.symbol == symbol)
            return &asset;
    }
    return nullptr;
}

const MarketModel::Asset *MarketModel::findAsset(const QString &symbol) const
{
    for (const Asset &asset : m_assets) {
        if (asset.symbol == symbol)
            return &asset;
    }
    return nullptr;
}

void MarketModel::setMessage(const QString &message)
{
    if (m_message == message)
        return;
    m_message = message;
    emit messageChanged();
}
