# 🍳 Makeit Recipes (Flutter App)

Makeit Recipes is a simple yet elegant Flutter mobile app designed to help users **store, view, edit, and manage their favorite recipes** locally using `sqflite` for offline storage.  
This project demonstrates clean UI design, Flutter navigation, and state management — perfect for anyone learning mobile app development.

---

## 🚀 Features
- 🏠 **Home Page** – Displays your added recipes with titles, descriptions, and quick actions.  
- ❤️ **Favorites Page** – View and manage recipes marked as favorites.  
- ⚙️ **Settings Page** – Manage app preferences.  
- 🧠 **Local Database (sqflite)** – All recipes are saved locally, no internet needed.  
- ✏️ **CRUD Functionality** – Add, view, edit, and delete recipes easily.  

---

## 🛠️ Getting Started

Follow these steps carefully to set up and run the project on your device.

---

### 1. 📦 Prerequisites

Before you begin, make sure your system has these installed:

| Tool | Version | Description |
|------|----------|-------------|
| [Flutter SDK](https://flutter.dev/docs/get-started/install) | Latest stable | Framework for building the app |
| [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) | Latest | IDE for running/debugging Flutter |
| [Dart SDK](https://dart.dev/get-dart) | Included with Flutter | Programming language used |
| Android Emulator or Physical Device | Any | To test the app |
| Git | Any | To clone the repository |

---

### 2. 🧭 Clone the Repository

Open your terminal or command prompt and run:

```bash
git clone https://github.com/raz-gean/Flutter_MakeIt.git
cd Flutter_MakeIt
```
---

### 3. ⚙️ Install Dependencies

Install all required Flutter packages:
```
flutter pub get
```
This will fetch all dependencies listed in your pubspec.yaml.
---

### 4. 📱 Set Up an Emulator or Connect a Device
- Option 1: Use an Android Emulator (via Android Studio)

Open Android Studio → Tools → Device Manager

Click Create Device

Choose a model (e.g., Pixel 6)

Select a system image (e.g., Android 13)

Click Finish

Start the emulator by clicking the ▶️ Play button

- Option 2: Use a Physical Android Device

Enable Developer Options and USB Debugging on your phone

Connect your phone via USB

Run flutter devices to confirm it’s detected
---

### 5. ▶️ Run the App

Once your device/emulator is ready, run:
```
flutter run
```
Flutter will build and launch the app on your connected device.
---

### 6. 🔁 Hot Reload / Hot Restart

While the app is running:

- Press r in the terminal for Hot Reload (refreshes UI changes instantly)
- Press R for Hot Restart (restarts the app state)
---

### 7. 🧹 Common Flutter Commands

Command	Description
```
flutter doctor	#Checks Flutter setup and dependencies
flutter pub get	#Installs dependencies
flutter clean	#Clears build cache (use if errors occur)
flutter run	#Runs the app
flutter build apk	#Builds the release APK file for Android
```
---

### 8. 🧾 Project Structure
```
lib/
 ┣ main.dart              # Entry point of the app
 ┣ pages/
 ┃ ┣ home.dart            # Home page UI
 ┃ ┣ favorites.dart       # Favorites page UI
 ┃ ┗ settings.dart        # Settings and preferences
 ┣ models/                # Data models (e.g. Recipe)
 ┣ db/                    # Local database helpers (sqflite)
 ┗ widgets/               # Reusable UI components
```
