import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/models/location.dart';
import 'package:sweetstall/models/price_range.dart';

void main() {
  late Location location;

  setUp(() {
    location = const Location(
      id: 'test',
      name: 'Test Market',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 4, max: 6),
          sell: PriceRange(min: 8, max: 10),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 2, max: 3),
          sell: PriceRange(min: 5, max: 6),
        ),
      },
    );
  });

  group('Location', () {
    test('priceRangeFor returns range for known sweet', () {
      final bubble = location.priceRangeFor('bubble');
      expect(bubble, isNotNull);
      expect(bubble!.buy.min, 4);
      expect(bubble.sell.max, 10);
    });

    test('priceRangeFor returns null for unknown sweet', () {
      expect(location.priceRangeFor('unknown'), isNull);
    });

    test('availableSweetIds returns all sweet ids', () {
      final ids = location.availableSweetIds;
      expect(ids, containsAll(['bubble', 'mint']));
      expect(ids.length, 2);
    });

    test('toString includes id and name', () {
      expect(location.toString(), contains('test'));
      expect(location.toString(), contains('Test Market'));
    });
  });
}
