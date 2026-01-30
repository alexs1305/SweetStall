import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../game/game_state.dart';

class InGameSummary extends SliverPersistentHeaderDelegate {
  InGameSummary(this.gameState);

  final GameState gameState;

  static const double _expandedHeight = 150;
  static const double _collapsedHeight = 68;

  @override
  double get maxExtent => _expandedHeight;

  @override
  double get minExtent => _collapsedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double progress =
        ((shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0) as double);
    final double expandedOpacity =
        ((1 - progress).clamp(0.0, 1.0) as double);
    final double collapsedOpacity =
        (progress.clamp(0.0, 1.0) as double);
    final horizontalPadding = lerpDouble(16.0, 12.0, progress)!;
    final verticalPadding = lerpDouble(16.0, 10.0, progress)!;

    final location = gameState.currentLocation.name;
    final daysText = 'Days left: ${gameState.daysLeft}';
    final cashText = 'Cash: \$${gameState.player.cash.toStringAsFixed(2)}';

    final daysTextSimple = 'Days:${gameState.daysLeft}';
    final cashTextSimple = '\$${gameState.player.cash.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Stack(
            children: [
              Opacity(
                opacity: expandedOpacity,
                child: _ExpandedSummary(
                  location: location,
                  daysText: daysText,
                  cashText: cashText,
                ),
              ),
              Opacity(
                opacity: collapsedOpacity,
                child: _CollapsedSummary(
                  location: location,
                  daysText: daysTextSimple,
                  cashText: cashTextSimple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant InGameSummary oldDelegate) => true;
}

class _ExpandedSummary extends StatelessWidget {
  const _ExpandedSummary({
    required this.location,
    required this.daysText,
    required this.cashText,
  });

  final String location;
  final String daysText;
  final String cashText;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current location: $location', style: textStyle),
        const SizedBox(height: 6),
        Text(daysText, style: textStyle),
        const SizedBox(height: 6),
        Text(cashText, style: textStyle),
      ],
    );
  }
}

class _CollapsedSummary extends StatelessWidget {
  const _CollapsedSummary({
    required this.location,
    required this.daysText,
    required this.cashText,
  });

  final String location;
  final String daysText;
  final String cashText;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$location • $daysText • $cashText',
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}