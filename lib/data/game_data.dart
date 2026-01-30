import '../models/location.dart';
import '../models/price_range.dart';
import '../models/sweet.dart';

/// Static sweet/location data used throughout the game.
class GameData {
  GameData._();

  static const sweets = [
    Sweet(id: 'bubble', name: 'Bubble Gum Blaster'),
    Sweet(id: 'caramel', name: 'Caramel Crunch'),
    Sweet(id: 'mint', name: 'Minty Refresh'),
    Sweet(id: 'berry', name: 'Berry Burst Chews'),
  ];

  static final Map<String, Sweet> sweetsById =
      {for (final sweet in sweets) sweet.id: sweet};

  /// Buy ranges are wide and vary by location so travelling can yield
  /// profit (sell at new location > buy at previous). Sell is derived
  /// from buy in Market (85–97%).
  static const locations = [
    Location(
      id: 'uptown',
      name: 'Uptown Market',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 9.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 5.0, max: 10.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 3.0, max: 7.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 8.5),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
      },
    ),
    Location(
      id: 'harbor',
      name: 'Harbor Side Bazaar',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 6.0, max: 11.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 3.0, max: 7.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 9.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 2.5, max: 6.5),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
      },
    ),
    Location(
      id: 'meadow',
      name: 'Meadow Run Pop-Up',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 2.5, max: 6.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 6.0, max: 12.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 3.0, max: 8.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 4.5, max: 9.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
      },
    ),
  ];
}
