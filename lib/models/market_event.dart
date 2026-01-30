enum MarketEventType { crash, shortage }

class MarketEvent {
  final int id;
  final String sweetId;
  final MarketEventType type;
  final double priceMultiplier;
  final DateTime occurredAt;

  const MarketEvent({
    required this.id,
    required this.sweetId,
    required this.type,
    required this.priceMultiplier,
    required this.occurredAt,
  });

  bool get isPriceIncrease => type == MarketEventType.shortage;
}
