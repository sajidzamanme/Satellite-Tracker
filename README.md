# Satellite Tracker Map

A premium, modern Flutter application that tracks the International Space Station (ISS) in real-time on an interactive, high-fidelity satellite map. Featuring custom-designed onboarding, automated user location tracking, anonymous authentication, and proximity alerts when the space station is passing nearby.

---

## Features

- **Real-Time ISS Tracking**: Periodically fetches the precise latitude and longitude coordinates of the International Space Station and renders its position using a custom satellite icon.
- **Automatic Countdown**: Features an elegant 60-second periodic reload timer with an active visual countdown stream.
- **Interactive Satellite Map**: Powered by **MapLibre GL** with high-resolution satellite imagery tiles provided by **MapTiler**.
- **Geocoding & Overhead Regions**: Reverse-geocodes the coordinates of the ISS in real-time to display the exact country, region, or ocean it is currently passing over.
- **Device Location Integration**: Seamlessly requests and tracks the user's GPS coordinates using `permission_handler` to display the user's real-time position.
- **Proximity Alerts**: Automatically calculates the distance between the user and the ISS using the **Haversine formula**. Displays a visually striking alert in the map header when the ISS is within a **1,000 km** radius.
- **Premium UI & Onboarding**:
  - Interactive onboarding/login screen featuring a pulsing glowing satellite logo and Monospace typography.
  - Glassmorphism overlays with real-time blur filters (`BackdropFilter`) for status cards and controls.
  - Interactive map controls (zoom in, zoom out, center-to-user, and track ISS).
  - High-quality custom snackbars and error handlers.
- **Clean Architecture & State Management**: Divided into core configurations and feature domains (`auth` and `map`), powered by Riverpod state management.

---

## Tech Stack & Dependencies

- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Interactive Maps**: [maplibre_gl](https://pub.dev/packages/maplibre_gl)
- **API Client**: [dio](https://pub.dev/packages/dio)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Permissions**: [permission_handler](https://pub.dev/packages/permission_handler)
- **Backend Services**: [firebase_core](https://pub.dev/packages/firebase_core) & [firebase_auth](https://pub.dev/packages/firebase_auth)

---

## Project Architecture

The application is structured following Clean Architecture principles:
```text
lib/
├── core/
│   ├── navigation/        # GoRouter navigation routing
│   ├── theme/             # Premium dark and light theme definitions
│   └── utils/             # Helper classes
├── features/
│   ├── auth/              # Authentication module
│   └── map/               # Map and Tracking module
│       ├── data/          # Models and API Remote Data Sources
│       ├── domain/        # Use cases and domain entities
│       └── presentation/  # MapScreen, Providers, and UI components
├── firebase_options.dart  # Firebase configuration options
└── main.dart              # Application entry point
```

---

## Setup & Installation

### 1. Prerequisites
- **Flutter SDK** (`^3.12.1` or higher) installed on your system.
- An Android Emulator or physical device connected in developer mode.

### 2. Configure Secrets (MapTiler API Key)
MapTiler is utilized to render the satellite style map and perform reverse geocoding. To configure your MapTiler API Key securely:
1. Create a `secrets.json` file in the **root** directory of the project (this file is ignored by git to keep your key safe):
   ```json
   {
     "MAPTILER_API_KEY": "YOUR_MAPTILER_API_KEY"
   }
   ```
2. Replace `"YOUR_MAPTILER_API_KEY"` with your valid MapTiler key from the [MapTiler Cloud Console](https://cloud.maptiler.com/).
*(Note: A valid API key is already configured in the local `secrets.json` file).*

### 3. Android Platform Configuration
- **Permissions**: The application is configured to request location services. The following permissions are defined in `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  ```
- **Firebase Auth**: Ensure that **Anonymous Sign-In** is enabled under **Authentication > Sign-in method** in your Firebase project console.

---

## Running the Application

1. Get all Dart dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application passing the secrets configuration file:
   ```bash
   flutter run --dart-define-from-file=secrets.json
   ```

*(Note: If you run using Android Studio or VS Code, add `--dart-define-from-file=secrets.json` to your launch configuration parameters).*

