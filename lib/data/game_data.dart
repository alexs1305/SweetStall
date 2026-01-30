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

  static const locations = [
    Location(
      id: 'uptown',
      name: 'Uptown Market',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 7.0),
          sell: PriceRange(min: 8.0, max: 10.0),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 5.0, max: 6.5),
          sell: PriceRange(min: 9.5, max: 12.5),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 3.5, max: 5.0),
          sell: PriceRange(min: 6.5, max: 8.0),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 4.5, max: 6.0),
          sell: PriceRange(min: 7.5, max: 9.0),
        ),
      },
    ),
    Location(
      id: 'harbor',
      name: 'Harbor Side Bazaar',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 5.5, max: 8.5),
          sell: PriceRange(min: 9.5, max: 13.0),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 5.5),
          sell: PriceRange(min: 8.0, max: 10.0),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 3.0, max: 4.0),
          sell: PriceRange(min: 5.5, max: 7.0),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 3.5, max: 5.0),
          sell: PriceRange(min: 6.5, max: 8.5),
        ),
      },
    ),
    Location(
      id: 'meadow',
      name: 'Meadow Run Pop-Up',
      sweetPriceRanges: {
        'bubble': SweetPriceRange(
          buy: PriceRange(min: 3.5, max: 5.5),
          sell: PriceRange(min: 7.5, max: 9.0),
        ),
        'caramel': SweetPriceRange(
          buy: PriceRange(min: 6.0, max: 8.0),
          sell: PriceRange(min: 10.5, max: 13.5),
        ),
        'mint': SweetPriceRange(
          buy: PriceRange(min: 4.0, max: 6.0),
          sell: PriceRange(min: 8.5, max: 10.0),
        ),
        'berry': SweetPriceRange(
          buy: PriceRange(min: 5.0, max: 6.5),
          sell: PriceRange(min: 9.0, max: 11.0),
        ),
      },
    ),
  ];
}
