class Player {
  final double cash;
  final Map<String, int> inventory;
  final String currentLocationId;

  const Player({
    required this.cash,
    required this.inventory,
    required this.currentLocationId,
  });

  Player copyWith({
    double? cash,
    Map<String, int>? inventory,
    String? currentLocationId,
  }) {
    return Player(
      cash: cash ?? this.cash,
      inventory: inventory ?? Map.from(this.inventory),
      currentLocationId: currentLocationId ?? this.currentLocationId,
    );
  }

  int inventoryQuantity(String sweetId) => inventory[sweetId] ?? 0;

  @override
  String toString() =>
      'Player(cash: $cash, currentLocation: $currentLocationId, inventory: $inventory)';
}
