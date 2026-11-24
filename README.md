# NIL Capital Markets Virtual Game

An educational sports-finance simulator exploring how performance telemetry could inform virtual NIL-market instruments. The repository includes two browser prototypes and a cross-platform **C++/Qt Quick** mobile application foundation for iOS and Android.

> **Simulation only:** Quotes, balances, telemetry, orders, settlement figures, partner connections, and account data are sample/demo values. Nothing here connects to a broker, processes real payments, stores real athlete biometrics, or provides investment, medical, or legal advice. Do not enter real credentials, API keys, health data, or financial information.

## Applications

### Native mobile app (C++ with Qt Quick)

The `mobile/` application uses a C++/Qt backend for typed market and virtual-order logic, with Qt Quick/QML for the adaptive mobile interface. It is intended as a shared iOS and Android codebase; use a Qt installation with the relevant mobile toolchains to build device packages.

Current mobile starter features:

- Mobile-first market dashboard with virtual quotes and readiness indicators.
- Virtual cash balance, portfolio equity, and simple long-position tracking.
- Simulated quote ticks and paper-buy actions.
- Bottom navigation for Markets, Portfolio, Telemetry, and Profile.
- No live brokerage, account authentication, or hardware telemetry integration.

### Browser prototypes

- `NIL_Capital_Markets__Institutional_Scholastic_Terminal.html` — institutional terminal prototype with trading, telemetry, index marketplace, XR, quant, and CRM concepts.
- `Tech_Ball_Hub_Digital_Ecosystem_Specifications (4).html` — hardware-powered simulator prototype with portfolio, trading, research, index store, XR, and CRM concepts.

These standalone HTML files are concept prototypes. They include simulated/demo interactions and are not connected to production services.

## Requirements

- Qt 6.5 or later with **Qt Quick**, **Qt Quick Controls**, and CMake support.
- A C++17-capable compiler.
- For iOS builds: macOS, Xcode, and the iOS components/toolchain installed through Qt.
- For Android builds: Android SDK/NDK and JDK configured in Qt Creator or the Qt toolchain environment.

## Build and run

Open `mobile/CMakeLists.txt` in Qt Creator, select a desktop kit to try the UI locally, or select an iOS/Android kit to build for a device or emulator. Alternatively, with Qt and CMake available:

```sh
cmake -S mobile -B mobile/build
cmake --build mobile/build
```

Run the generated `NilMarketsMobile` executable on desktop. For iOS and Android, configure the corresponding Qt kit and deploy through Qt Creator; mobile packaging requires the platform toolchains and signing configuration.

## Project layout

```text
mobile/
  CMakeLists.txt       Qt Quick / CMake application target
  qml/Main.qml         Adaptive mobile screens and navigation
  src/main.cpp         Qt application startup and QML context setup
  src/MarketModel.h    C++ app state and invokable interface
  src/MarketModel.cpp  Sample market data and paper-trading logic
NIL_Capital_Markets__Institutional_Scholastic_Terminal.html
Tech_Ball_Hub_Digital_Ecosystem_Specifications (4).html
```

## Next steps

1. Install Qt 6 and build/deploy the starter on iOS and Android devices.
2. Add automated C++ tests and persistence for virtual portfolios.
3. Design any real telemetry/API integration with explicit consent, privacy safeguards, and threat modeling before implementation.
4. Keep financial and biometric behavior clearly labeled as simulated until reviewed and backed by real, compliant services.

## License

No license has been specified yet. All rights are reserved unless the repository owner adds a license.
