# TripClip — mobile app

Flutter client for TripClip. Most day-to-day work happens in `lib/`.

## Prerequisites

- **Flutter** with a Dart SDK that satisfies `pubspec.yaml` (currently `sdk: ^3.11.1`). Run `flutter doctor` and resolve any reported issues before building.
- **Android**: Android SDK, a device or emulator, and **JDK 17** (matches `android/app/build.gradle.kts`).
- **iOS** (macOS only): Xcode, CocoaPods, and a simulator or device.

## First-time setup

From this directory:

```bash
flutter pub get
```

Configure **Google Maps** (the app uses `google_maps_flutter`; maps will not work correctly without a valid key).

### Android

`android/local.properties` is gitignored. Add your key there (or set the environment variable when building):

```properties
GOOGLE_MAPS_API_KEY=your_key_here
```

Alternatively, Gradle reads `GOOGLE_MAPS_API_KEY` from the environment. See `android/app/build.gradle.kts` for the exact resolution order.

### iOS

Edit `ios/Flutter/Keys.xcconfig` and set:

```text
GOOGLE_MAPS_API_KEY=your_key_here
```

`Debug.xcconfig` / `Release.xcconfig` include `Keys.xcconfig`, which feeds `Info.plist`. Do not commit real production keys to a public repository.

In Google Cloud Console, enable the Maps SDK for the platforms you use and restrict the key appropriately (Android package + SHA-1, iOS bundle id, etc.).

## Run the app

```bash
flutter run
```

Use `-d <device_id>` to target a specific device (`flutter devices` lists them).

## Analyze and test

```bash
dart analyze
flutter test
```

## Project layout (short)

- `lib/app/` — app shell, navigation, theme.
- `lib/screens/` — feature screens by area (account, home, parcels, trips, …).
- `lib/ui/` — shared widgets, sheets, maps helpers.

## Full stack (optional)

Backend, Docker, and root-level environment files are described in the repository **root** `README.md`. The mobile app can be developed and run on its own once Flutter and Maps are configured.
