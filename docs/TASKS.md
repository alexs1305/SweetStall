# SweetStall – Implementation tasks

Tasks are ordered by dependency. Agents: pick an unchecked task, implement it, then check it off.

## 1. Project bootstrap

- [x] Run `flutter create` with org and project name; set min iOS/Android versions in pubspec.
- [x] Add dependencies in pubspec.yaml: `provider` or `riverpod`, `shared_preferences`.

## 2. Dev container

- [ ] Add `.devcontainer/Dockerfile` with Flutter SDK + Android SDK (and optional emulator).
- [ ] Add `.devcontainer/devcontainer.json` (forward ports, install Dart/Flutter extensions).
- [ ] Document in README: how to run in dev container; that iOS must be built on host Mac or CI.

## 3. Models and static data

- [x] Create `lib/models/sweet.dart` (id, name).
- [x] Create `lib/models/location.dart` (id, name, per-sweet buy/sell price ranges).
- [x] Create `lib/models/player.dart` (cash, inventory map, currentLocationId).
- [x] Create `lib/models/market.dart` (current buy/sell prices per sweet for current location).
- [x] Create `lib/models/leaderboard_entry.dart` (score, optional name, optional date).
- [x] Create `lib/data/game_data.dart` with 2–3 locations and 3–5 sweets and example price ranges.

## 4. Leaderboard persistence

- [x] Create `lib/services/leaderboard_service.dart`: load/save top N from shared_preferences (or file), add score, get sorted list.

## 5. Game state and actions

- [x] Create `lib/game/game_state.dart`: single source of truth (e.g. ChangeNotifier) for player, time left, market, locations; game-over flag.
- [x] Create `lib/game/game_actions.dart`: setLocation (roll prices), buy, sell, advance time; call leaderboard when time = 0.

## 6. App shell and navigation

- [x] Create `lib/app.dart`: MaterialApp and routes (home, play, game_over).
- [x] Wire `lib/main.dart` to app and state (e.g. Provider/Riverpod at root).

## 7. Screens and UI

- [x] Create `lib/screens/home_screen.dart`: Start game button + high scores list (from leaderboard service).
- [x] Create `lib/screens/play_screen.dart`: current location, days left, cash; market (buy/sell prices + buttons); inventory; travel button.
- [x] Create `lib/screens/game_over_screen.dart`: final score, submit to leaderboard if qualifying, show leaderboard, back to home.

## 8. Polish and docs

- [ ] Tune starting cash, time limit, and price ranges for balance.
- [ ] Update README with run instructions, dev container usage, and iOS note.
- [ ] Assign deterministic, distinct card colors for each sweet in the market.
