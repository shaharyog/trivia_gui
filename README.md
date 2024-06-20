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
13. Music sound in game screen
14. Config file (`config.json` to set ip and port, the default is `0.0.0.0, 8826`)

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
    - `flutter build <os> --release`, Replace `<os>` with windows, linux, etc...
7. Run the executable provided by the build command.

### Installation

#### We have released each version of our gui in the releases tab in GitHub, so you can download directly from there, for specific installation instructions refer to this [guide](INSTALLATION_INSTRUCTIONS.md)

### Known Bugs

#### There aren't any known bugs, but there are some things that are good to know:

1. sometimes when moving from rooms page to lobby, the timer that requests the rooms list, may get in the request rooms
   function right on the time when moving to lobby, when the user joined the room, so maybe there will be a request not
   relevant error in the logs, but it does not bother us because it's not critical, also the exception cannot be caught,
   because where the exception usually gets caught is not the current page.
2. sometimes there is an error, again only in the logs, the functionality is perfectly stable, the error is related to
   the rust_flutter_bridge and the disposal of the session object, we did not investigate it deeply, as again it is not
   critical, and does not affect the functionality.

## Authors

- Shahar Yogev
- Yuval Bar

