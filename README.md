# SweetStall
mobile game using flutter

## Dev container

- Reopen this repo inside the dev container via **VS Code > Remote Containers > Reopen in Container** so Flutter and Android tooling are already installed (see `.devcontainer/Dockerfile`).
- The container installs the Flutter SDK, Android command-line tools/platforms, and forwards ports `8080`/`3000` so you can run `flutter run -d web-server`/`flutter run -d chrome` or host backend previews from the same environment.
- `flutter doctor` runs automatically after the container is created, but rerun it (and `flutter precache` or `flutter pub get`) whenever you change SDKs or dependencies. Rebuild the container if the Dockerfile changes.
- iOS builds still require macOS host tooling (`flutter build ipa` or Xcode) because the container runs Linux; use a host Mac or CI to produce iOS binaries.
