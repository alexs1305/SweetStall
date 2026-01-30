import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/models/price_range.dart';

void main() {
  group('PriceRange', () {
    test('average is midpoint of min and max', () {
      const range = PriceRange(min: 2.0, max: 8.0);
      expect(range.average, 5.0);
    });

    test('clamp returns value within range', () {
      const range = PriceRange(min: 3.0, max: 7.0);
      expect(range.clamp(5.0), 5.0);
      expect(range.clamp(2.0), 3.0);
      expect(range.clamp(10.0), 7.0);
    });

    test('asserts min <= max', () {
      expect(
        () => PriceRange(min: 10, max: 5),
        throwsAssertionError,
      );
    });
  });

  group('SweetPriceRange', () {
    test('holds buy and sell PriceRange', () {
      const buy = PriceRange(min: 1, max: 2);
      const sell = PriceRange(min: 3, max: 4);
      const spr = SweetPriceRange(buy: buy, sell: sell);
      expect(spr.buy, buy);
      expect(spr.sell, sell);
    });
  });
}
