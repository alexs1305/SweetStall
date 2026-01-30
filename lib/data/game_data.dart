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
          buy: PriceRange(min: 32.0, max: 40.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 27.0, max: 35.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 12.0, max: 18.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 6.0, max: 14.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
      },
    ),
    Location(
      id: 'harbor',
      name: 'Harbor Side Bazaar',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 30.0, max: 38.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 25.0, max: 33.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 11.0, max: 19.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 5.0, max: 13.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
      },
    ),
    Location(
      id: 'meadow',
      name: 'Meadow Run Pop-Up',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 31.0, max: 39.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 26.0, max: 34.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 10.0, max: 20.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 7.0, max: 15.0),
          sell: PriceRange(min: 0.85, max: 0.97),
        ),
      },
    ),
  ];
}
