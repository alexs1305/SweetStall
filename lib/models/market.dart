import 'dart:math';

import 'location.dart';
import 'market_event.dart';
import 'price_range.dart';

class Market {
  final String locationId;
  final Map<String, double> buyPrices;
  final Map<String, double> sellPrices;
  final DateTime generatedAt;

  Market({
    required this.locationId,
    required this.buyPrices,
    required this.sellPrices,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  /// Sell price is derived as 85–97% of buy price: close spread at same
  /// market, but volatile buy ranges across locations allow profit by
  /// buying low in one place and selling higher in another.
  static const double _sellMultiplierMin = 0.85;
  static const double _sellMultiplierMax = 0.97;

  factory Market.fromLocation(Location location, {Random? random}) {
    final seed = random ?? Random();
    final buy = <String, double>{};
    final sell = <String, double>{};

    for (final entry in location.sweetPriceRanges.entries) {
      final buyPrice = _sample(entry.value.buy, seed);
      // Sell is a fraction of buy: always lower, but close enough that
      // travelling can yield sell price > previous buy price.
      final multiplier = _sellMultiplierMin +
          (_sellMultiplierMax - _sellMultiplierMin) * seed.nextDouble();
      final sellPrice = (buyPrice * multiplier * 100).round() / 100;
      buy[entry.key] = buyPrice;
      sell[entry.key] = sellPrice;
    }

    return Market(
      locationId: location.id,
      buyPrices: buy,
      sellPrices: sell,
    );
  }

  double priceFor(String sweetId, {bool buying = true}) {
    final prices = buying ? buyPrices : sellPrices;
    return prices[sweetId] ?? 0;
  }

  Market applyEvent(MarketEvent event) {
    if (!buyPrices.containsKey(event.sweetId)) {
      return this;
    }

    final updatedBuy = Map<String, double>.from(buyPrices);
    final updatedSell = Map<String, double>.from(sellPrices);
    updatedBuy[event.sweetId] =
        _roundToCents(updatedBuy[event.sweetId]! * event.priceMultiplier);
    updatedSell[event.sweetId] =
        _roundToCents(updatedSell[event.sweetId]! * event.priceMultiplier);

    return Market(
      locationId: locationId,
      buyPrices: updatedBuy,
      sellPrices: updatedSell,
      generatedAt: generatedAt,
    );
  }

  static double _sample(PriceRange range, Random random) {
    return range.min + (range.max - range.min) * random.nextDouble();
  }

  static double _roundToCents(double value) =>
      (value * 100).roundToDouble() / 100;

  @override
  String toString() =>
      'Market(location: $locationId, generatedAt: $generatedAt)';
}
