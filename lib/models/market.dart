import 'dart:math';

import 'location.dart';
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

  factory Market.fromLocation(Location location, {Random? random}) {
    final seed = random ?? Random();
    final buy = <String, double>{};
    final sell = <String, double>{};

    for (final entry in location.sweetPriceRanges.entries) {
      buy[entry.key] = _sample(entry.value.buy, seed);
      sell[entry.key] = _sample(entry.value.sell, seed);
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

  static double _sample(PriceRange range, Random random) {
    return range.min + (range.max - range.min) * random.nextDouble();
  }

  @override
  String toString() =>
      'Market(location: $locationId, generatedAt: $generatedAt)';
}
