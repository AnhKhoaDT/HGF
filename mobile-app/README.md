# TripWise Flutter Mobile Application

The cross-platform Android and iOS application for TripWise. Built with Flutter, Dart, and Redux.

## Features

- **Onboarding & Authentication**: Social logins (Google, Apple) and Email/Password flows.
- **Trip Generator**: Mobile-friendly inputs to generate, save, and modify travel plans.
- **Check-ins & Location Services**: View nearby places, check-in, and record GPS coordinates (Latitude/Longitude).
- **Responsive Layout**: Adapts smoothly across various device screens.

## Project Structure

- `lib/core/store/`: App Redux state management (Actions, Reducers, State Provider).
- `lib/core/theme/`: Theme tokens (Colors, Typography, Styling, Dimensions).
- `lib/features/`: Feature modules (Authentication, Dashboard/Home, Profile).
- `lib/shared/`: Shared components, custom buttons, cards, text fields, and overlays.

## Getting Started

### 1. Configure the Flutter SDK

Ensure you have the Flutter SDK installed and configure your emulator/device.

### 2. Configure Environment

Create a `.env` file in the root of the `mobile-app` directory:

```env
API_URL=http://localhost:8080/api
```

### 3. Fetch dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```
