# IsKopi

IsKopi is a Flutter mobile app developed for **CMSC 156 - Mobile Development**. It provides a curated directory of coffee shops within and near UP Visayas, allowing users to browse cafes, view key details (hours, price range, amenities), and quickly search or filter options through a simple, student-friendly interface.

## Developers

- Rei Jansen Buerom
- John Romson Erazo

## Table of Contents

- [Project Goals](#project-goals)
- [Core Features](#core-features)
- [Tech Stack](#tech-stack)
- [Application Architecture](#application-architecture)
- [Project Structure](#project-structure)
- [Data Source and Format](#data-source-and-format)
- [Getting Started](#getting-started)
- [Run and Build Commands](#run-and-build-commands)
- [Testing and Quality Checks](#testing-and-quality-checks)
- [Coding and Documentation Conventions](#coding-and-documentation-conventions)
- [Known Notes](#known-notes)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Project Goals

- Help students quickly discover coffee shops near campus.
- Surface practical decision info: location, hours, price range, and amenities.
- Keep navigation simple enough for daily use.
- Add a fun decision helper through a random spin picker.

## Core Features

1. Home page for quick access to app sections.
2. Coffee shop directory with card-based browsing.
3. Search and filter behavior through keyword matching.
4. Shop details view showing key operational information.
5. Spin-a-wheel feature for random coffee shop selection.
6. Persistent spin pool selections using local storage.
7. About page with project context.

## Tech Stack

- Flutter (Material 3 UI)
- Dart SDK `^3.11.1`
- `shared_preferences` for local persistence
- `google_fonts` for typography

## Application Architecture

The app follows a lightweight layered structure:

- `core`: shared constants and utility helpers
- `data`: models, repository, and storage service
- `features`: UI pages and feature-specific logic
- `shared`: reusable widgets used across features

### Routing

Routing is configured in `lib/app.dart` using named routes:

- `/` and `/home`
- `/directory`
- `/spin`
- `/shop-details`
- `/about`

### State and Data Flow

- Directory and spin features load data from `assets/data/coffee_shops.json` via `CoffeeShopRepository`.
- Spin feature state is managed by `SpinProvider`.
- Selected spin pool items are saved using `LocalStorageService` (`shared_preferences`).

## Project Structure

```text
lib/
  app.dart
  main.dart
  core/
    constants/
    utils/
  data/
    models/
    repositories/
    services/
  features/
    about/
    directory/
    home/
    shop_details/
    spin/
  shared/
    widgets/

assets/
  data/
    coffee_shops.json
  images/
```

## Data Source and Format

Coffee shop records are stored in:

- `assets/data/coffee_shops.json`

`CoffeeShop` fields:

- `id`
- `name`
- `image`
- `shortTags`
- `shortDescription`
- `location`
- `hours`
- `priceRange`
- `directions`
- `otherInfo`

When adding new entries, keep field names and value types consistent with `lib/data/models/coffee_shop.dart`.

## Getting Started

### Prerequisites

Install the following:

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code with Flutter and Dart extensions
- Android SDK for Android builds
- Xcode (macOS only) for iOS builds

Verify your environment:

```bash
flutter doctor
flutter --version
```

### Installation

1. Clone the repository.
2. Open the project root.
3. Install dependencies:

```bash
flutter pub get
```

## Run and Build Commands

### Development Run

```bash
flutter devices
flutter run -d <device_id>
```

### Static Analysis and Tests

```bash
flutter analyze
flutter test
```

### Production Builds

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# Web
flutter build web
```

## Testing and Quality Checks

Before submitting changes:

1. Run `flutter analyze`.
2. Run `flutter test`.
3. Manually test affected user flows (home, directory, details, spin).
4. Check that route navigation still works for all named routes.

## Coding and Documentation Conventions

- Keep feature code inside `lib/features/<feature_name>`.
- Reuse common widgets from `lib/shared/widgets`.
- Keep data parsing and persistence in `lib/data`.
- Use clear and small commits with descriptive messages.
- Add comments only where logic is non-obvious.
- Prefer comments that explain intent or constraints, not line-by-line behavior.

## Known Notes

- The current JSON dataset may contain placeholder sample entries. Update `assets/data/coffee_shops.json` with final UP Visayas and nearby cafes before release/demo.
- No backend is required; this app currently uses local assets and local persistence.

## Troubleshooting

### Dependencies or package resolution issues

```bash
flutter clean
flutter pub get
```

### Build or cache inconsistencies

```bash
flutter clean
flutter run
```

### Device not detected

- Re-run `flutter devices`.
- Recheck platform setup with `flutter doctor`.
- Ensure USB debugging (Android) or simulator availability is enabled.

## License

No `LICENSE` file is currently included. Add one if this project will be distributed publicly.
