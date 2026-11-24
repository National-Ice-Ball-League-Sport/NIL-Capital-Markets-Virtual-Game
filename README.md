# NIL Capital Markets Virtual Game

Educational sports-finance simulator exploring how performance telemetry could inform virtual NIL-market instruments. The repository has two standalone HTML prototypes and a cross-platform **C++17 / Qt Quick** mobile-app starter for desktop, Android, and iOS.

> **Demo only:** Quotes, balances, telemetry examples, and orders are simulated. The app does not connect to a broker, execute real trades, or provide investment, medical, or legal advice. Never enter real financial credentials or health data.

## Applications

- **Native app (`mobile/`)** — Qt Quick/QML interface with C++ market model. The starter currently demonstrates sample quotes, virtual balances, paper buys, and bottom navigation. It does not have real account authentication, brokerage, or hardware telemetry.
- **Browser prototypes** — `NIL_Capital_Markets__Institutional_Scholastic_Terminal.html` and `Tech_Ball_Hub_Digital_Ecosystem_Specifications (4).html`. Both are standalone concept demos, not production services.

## Requirements

- Qt 6.5+ with Qt Quick and Qt Quick Controls.
- C++17 compiler and CMake 3.21+.
- Desktop builds: a Qt desktop kit.
- Android: Qt Android kit plus configured Android SDK/NDK and JDK.
- iOS: macOS, Xcode, Qt iOS kit, and signing configuration for device deployment.

## Build and run

Open `mobile/CMakeLists.txt` in Qt Creator, select a desktop kit, then build and run. Alternatively, with Qt available through `CMAKE_PREFIX_PATH`:

```sh
cmake -S mobile -B build -DCMAKE_PREFIX_PATH="$QT_PREFIX"
cmake --build build --parallel
```

For Android and iOS, use the matching Qt Creator kit and its configured platform toolchain to build and deploy to a device or emulator. Desktop CMake settings are not substitutes for platform-specific kits.

## Project layout

```text
mobile/
  CMakeLists.txt       Qt Quick / CMake application target
  qml/Main.qml         Mobile interface and navigation
  src/main.cpp         Qt application startup
  src/MarketModel.h    C++ app state and invokable API
  src/MarketModel.cpp  Sample market data and paper-buy logic
```

## Development roadmap

- Add unit tests and local persistence for the virtual portfolio.
- Expand paper-trading actions and portfolio history.
- Keep sensor access disabled until supported hardware, user consent, permissions, and data-retention/privacy controls are designed and tested.
- Add CI for desktop builds and tests; document platform-specific mobile build requirements.

No license has been specified; all rights are reserved unless the repository owner adds a license.
