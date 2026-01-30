import 'package:flutter_test/flutter_test.dart';
import 'package:sweetstall/models/player.dart';

void main() {
  group('Player', () {
    test('inventoryQuantity returns 0 for unknown sweet', () {
      const player = Player(
        cash: 100,
        inventory: {},
        currentLocationId: 'uptown',
      );
      expect(player.inventoryQuantity('bubble'), 0);
    });

    test('inventoryQuantity returns quantity for known sweet', () {
      const player = Player(
        cash: 100,
        inventory: {'bubble': 3, 'mint': 1},
        currentLocationId: 'uptown',
      );
      expect(player.inventoryQuantity('bubble'), 3);
      expect(player.inventoryQuantity('mint'), 1);
    });

    test('copyWith updates only provided fields', () {
      const player = Player(
        cash: 100,
        inventory: {'bubble': 2},
        currentLocationId: 'uptown',
      );
      final updated = player.copyWith(cash: 50);
      expect(updated.cash, 50);
      expect(updated.inventory, {'bubble': 2});
      expect(updated.currentLocationId, 'uptown');
    });

    test('copyWith with inventory returns new map', () {
      const player = Player(
        cash: 100,
        inventory: {'bubble': 1},
        currentLocationId: 'uptown',
      );
      final updated = player.copyWith(inventory: {'mint': 2});
      expect(updated.inventory, {'mint': 2});
      expect(player.inventory, {'bubble': 1});
    });

    test('toString includes cash, location, inventory', () {
      const player = Player(
        cash: 42.5,
        inventory: {'bubble': 1},
        currentLocationId: 'harbor',
      );
      expect(
        player.toString(),
        contains('42.5'),
      );
      expect(player.toString(), contains('harbor'));
      expect(player.toString(), contains('bubble'));
    });
  });
}
