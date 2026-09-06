# TPV Project

This repository contains a Flutter point-of-sale (TPV) application under active development.

## Description

TPV Project is a Flutter application for managing a point-of-sale terminal (TPV). It includes interfaces for sales, inventory management, and basic configuration. This README describes how to set up, run, and contribute to the project.

## Requirements

- Flutter SDK (stable) — https://docs.flutter.dev/get-started/install
- Dart (included with Flutter)
- Android Studio or Visual Studio Code (optional, recommended)
- Physical device or Android/iOS emulator for testing

Verify Flutter installation with:

```bash
flutter --version
```

## Installation and Execution

1. Clone the repository:

```bash
git clone https://github.com/gabrielramos02/tpv_proyect.git
cd tpv_proyect
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application on an emulator or connected device:

```bash
flutter run
```

4. To run tests:

```bash
flutter test
```

5. To create a production APK (Android):

```bash
flutter build apk --release
```

For complete deployment guides, see:
- Android: https://docs.flutter.dev/deployment/android
- iOS: https://docs.flutter.dev/deployment/ios

## Project Structure (Overview)

- android/ — Android native configuration and code
- ios/ — iOS native configuration and code
- lib/ — Dart source code (logic and UI)
  - main.dart — entry point
- test/ — unit and widget tests
- assets/ — images, fonts, and other resources

## Useful Commands

- Get dependencies: `flutter pub get`
- Run in debug mode: `flutter run`
- Run tests: `flutter test`
- Analyze code: `flutter analyze`
- Format code: `dart format .`

## Best Practices

- Do not commit credentials or keys to the repository. Use environment variables or a secrets manager.
- Work on separate branches and open Pull Requests for significant changes.
- Add tests for critical logic (payments, inventory, calculations).
- Keep dependencies updated and review breaking changes before upgrading.

## Contributing

1. Create a new branch from `main`: `git checkout -b feat/new-feature`
2. Make changes and add tests when applicable.
3. Open a Pull Request describing the changes and tests performed.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## Contact

If you have questions or want to collaborate, open an issue or contact the repository maintainer.

