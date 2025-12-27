# My Sivi Chat

A modern Flutter-based chat application with a clean and intuitive user interface.

## 📱 Features

- **Chat Interface**: Clean and responsive chat interface
- **User List**: View and interact with other users
- **Navigation**: Easy navigation between different sections
- **Responsive Design**: Works on both mobile and tablet devices
- **Material Design**: Follows Material Design guidelines for a polished look

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for emulator/simulator)
- VS Code or Android Studio (recommended IDEs)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/safedore/sivi-chat.git
   cd sivi-chat
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🛠️ Dependencies

- `http`: ^1.2.2 - For making HTTP requests
- `intl`: ^0.20.2 - For internationalization and localization
- `provider`: ^6.0.5 - For state management
- `flutter_lints`: ^5.0.0 - For code quality and linting

## 🏗️ Project Structure

```
lib/
├── app/
│   └── app.dart          # Main application widget
├── src/
│   ├── models/           # Data models
│   ├── screens/          # Application screens
│   │   ├── main_nav_screen.dart  # Main navigation
│   │   ├── home_screen.dart      # Home screen
│   │   └── tabs/                 # Tab screens
│   │       ├── chat_history_tab.dart
│   │       └── user_list_tab.dart
│   └── services/         # Business logic and services
```

## 🧪 Testing

Run the following command to execute the integration tests:
```bash
flutter test integration_test/
```
