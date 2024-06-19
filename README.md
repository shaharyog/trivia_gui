# Trivia Game By Shahar Yogev & Yuval Bar

This is the frontend for the Trivia Game developed by Shahar Yogev and Yuval Bar. The frontend is built using Flutter
and integrates with the game's backend through the `flutter_rust_bridge` library.


## Bonuses

1. Email Verification
2. Password Email Recovery
3. Regex User Data Validation + date validation
4. Dynamic Questions Fetching whenever more questions are needed
5. Update User Data Request
6. Player Avatar Colors Support
7. Cross Platform Support
8. CMake build system
9. Vcpkg package manager and manifest file
10. SQLITE_ORM to manage the database
11. Pretty Logging using the fmt library
12. CI/CD to release executables to multiple platforms including:
   - windows (exe and msix installers)
   - linux (deb, rpm and AppImage)
   - android (apk)

## Getting Started

These instructions will help you set up the frontend development environment on your local machine.

### Prerequisites

- Flutter SDK
- Rust
- cargo

### Building
1. Clone the repository `git clone https://github.com/Shahar-Yogev/trivia_gui`
2. Navigate to the project `cd trivia_gui` 
3. Setup flutter_rust_bridge:
    - install using cargo `cargo install 'flutter_rust_bridge_codegen@2.0.0-dev.34'`
4. Setup flutter, run:
    - `flutter clean`
    - `flutter pub get`
5. Generate code from rust, run:
    - `flutter_rust_bridge_codegen generate`
6. Build flutter project:
    - `flutter build <os> --release`, Replace <os> with windows, linux, etc...
7. Run the executable provided by the build command.

## Authors
- Shahar Yogev
- Yuval Bar

