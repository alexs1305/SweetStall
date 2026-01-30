import 'price_range.dart';

class Location {
  final String id;
  final String name;
  final Map<String, SweetPriceRange> sweetPriceRanges;

  const Location({
    required this.id,
    required this.name,
    required this.sweetPriceRanges,
  });

  SweetPriceRange? priceRangeFor(String sweetId) =>
      sweetPriceRanges[sweetId];

  List<String> get availableSweetIds => sweetPriceRanges.keys.toList();

  @override
  String toString() => 'Location(id: $id, name: $name)';
}
