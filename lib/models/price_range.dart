class PriceRange {
  final double min;
  final double max;

  const PriceRange({
    required this.min,
    required this.max,
  }) : assert(min <= max, 'min must be <= max');

  double get average => (min + max) / 2;

  double clamp(double value) => value.clamp(min, max);
}

class SweetPriceRange {
  final PriceRange buy;
  final PriceRange sell;

  const SweetPriceRange({
    required this.buy,
    required this.sell,
  });
}
