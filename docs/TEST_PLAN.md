# SweetStall Test Plan

## Overview

Tests are organized into **unit tests** (models, game logic, services) and **widget tests** (screens and app shell). The goal is to keep business logic testable without the UI and to verify key screens render and respond correctly.

## Test Structure

```
test/
├── widget_test.dart          # App smoke test (replaces default counter test)
├── models/                   # Unit tests for data models
│   ├── player_test.dart
│   ├── sweet_test.dart
│   ├── leaderboard_entry_test.dart
│   ├── location_test.dart
│   ├── market_test.dart
│   └── price_range_test.dart
├── game/                     # Unit tests for game state and actions
│   ├── game_state_test.dart
│   └── game_actions_test.dart
├── services/
│   └── leaderboard_service_test.dart
└── screens/                  # Widget tests for screens
    ├── home_screen_test.dart
    ├── play_screen_test.dart
    └── game_over_screen_test.dart
```

## 1. Unit Tests

### Models

- **Player**: `copyWith`, `inventoryQuantity`, immutability of inventory in copy.
- **Sweet**: equality, hashCode, toString.
- **LeaderboardEntry**: `toJson` / `fromJson` round-trip, optional fields.
- **Location**: `priceRangeFor`, `availableSweetIds`, toString.
- **PriceRange**: `average`, `clamp`, assert min <= max.
- **Market**: `fromLocation` with seeded Random (deterministic prices), `priceFor` for buy/sell.

### Game

- **GameState** (with mock LeaderboardService and optional Random):
  - Initial state: player cash/days/location, market for first location.
  - `withDefaults` uses GameData.locations.
  - `resetGame` restores player, market, days; clears game over.
  - `rollMarket` returns new market for given location.
  - `markGameOver` sets flag, notifies, and calls leaderboardService.addScore once.
- **GameActions** (with GameState + mock leaderboard):
  - `setLocation`: rejects same location and invalid id; updates player and market on success.
  - `buy`: rejects when game over, quantity <= 0, or insufficient cash; updates cash and inventory.
  - `sell`: rejects when game over, quantity <= 0, or insufficient stock; updates cash and inventory.
  - `advanceTime`: decrements days; when days reach 0, marks game over and advances to game over.

### Services

- **LeaderboardService** (using `SharedPreferences.setMockInitialValues`):
  - `loadTopScores` returns empty when no data.
  - `addScore` persists and returns sorted list; respects `maxEntries`; ordering by score descending.

## 2. Widget Tests

- **App**: Pump `SweetStallApp` with a test LeaderboardService; find home title (e.g. "SweetStall" or "Sweet Trading Academy").
- **HomeScreen**: With provided GameState and LeaderboardService, expect cash, location, days, "Start trading" button, and leaderboard section (empty or list).
- **PlayScreen**: With GameState and GameActions, expect location, market, buy/sell buttons, "End day", "Return home".
- **GameOverScreen**: With game-over state, expect "Game Over", final score, leaderboard, "Back to home".

Screens are tested by providing `ChangeNotifierProvider`/`Provider` with test doubles or in-memory state so that no real SharedPreferences or navigation is required beyond what the test sets up.

## 3. Running Tests

```bash
# All tests
flutter test

# Only unit tests (faster, no widget pump)
flutter test test/models/ test/game/ test/services/

# Only widget tests
flutter test test/widget_test.dart test/screens/

# With coverage
flutter test --coverage
```

## 4. Dependencies

- `flutter_test`: already in `dev_dependencies`.
- `shared_preferences`: use `SharedPreferences.setMockInitialValues({})` in tests before `getInstance()` to avoid platform storage.

No extra test packages (e.g. mockito) are required for the current plan; manual mocks/fakes are used for LeaderboardService and Random where needed.
