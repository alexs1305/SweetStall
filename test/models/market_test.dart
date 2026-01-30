import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/models/location.dart';
import 'package:sweetstall/models/market.dart';
import 'package:sweetstall/models/price_range.dart';

void main() {
  late Location location;

  setUp(() {
    location = const Location(
      id: 'test',
      name: 'Test Market',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 6.0),
          sell: PriceRange(min: 8.0, max: 10.0),
        ),
      },
    );
  });

  group('Market', () {
    test('fromLocation with seeded Random produces deterministic prices', () {
      final random = Random(42);
      final market1 = Market.fromLocation(location, random: random);
      final market2 = Market.fromLocation(location, random: Random(42));
      expect(market1.buyPrices['bubble'], market2.buyPrices['bubble']);
      expect(market1.sellPrices['bubble'], market2.sellPrices['bubble']);
    });

    test('priceFor returns buy price when buying: true', () {
      final market = Market.fromLocation(location, random: Random(0));
      final price = market.priceFor('bubble', buying: true);
      expect(price, greaterThanOrEqualTo(4.0));
      expect(price, lessThanOrEqualTo(6.0));
    });

    test('priceFor returns sell price when buying: false', () {
      final market = Market.fromLocation(location, random: Random(0));
      final price = market.priceFor('bubble', buying: false);
      expect(price, greaterThanOrEqualTo(8.0));
      expect(price, lessThanOrEqualTo(10.0));
    });

    test('priceFor returns 0 for unknown sweet', () {
      final market = Market.fromLocation(location, random: Random(0));
      expect(market.priceFor('unknown', buying: true), 0);
      expect(market.priceFor('unknown', buying: false), 0);
    });

    test('locationId and generatedAt are set', () {
      final market = Market.fromLocation(location, random: Random(0));
      expect(market.locationId, 'test');
      expect(market.generatedAt, isNotNull);
    });
  });
}
