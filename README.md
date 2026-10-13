# Task Tracker - Flutter Mobile App

A modern, robust Task Tracker Flutter application built with **MVVM Architecture**, **BLoC State Management**, **GetIt Dependency Injection**, and **Dio HTTP Client**. The app connects to a REST API backend (`/api/tasks`) to support full **CRUD** operations.

---

## 🚀 Key Features

- 📋 **List Tasks (Read)**: Fetches tasks from `GET /api/tasks` with loading indicators, error views with a **Retry** button, and pull-to-refresh support.
- ➕ **Add Task (Create)**: Modal dialog to submit tasks to `POST /api/tasks` with input validation (requires at least 3 characters).
- ☑️ **Toggle Status (Update)**: Interactive checkbox updating status (`todo` / `done`) via `PATCH /api/tasks/:id` with optimistic UI updates.
- 🗑️ **Delete Task (Delete)**: Task deletion with confirmation dialog via `DELETE /api/tasks/:id`.

---

## 🏗️ Architecture & Tech Stack

This project follows clean separation of concerns using **MVVM**:

```
lib/
├── bloc/                # BLoC / ViewModel layer
│   ├── task_bloc.dart   # Handles business logic & state transitions
│   ├── task_event.dart  # User actions (Load, Add, Toggle, Delete)
│   └── task_state.dart  # UI States (Initial, Loading, Loaded, Error)
├── di/                  # Service Locator / Dependency Injection
│   └── service_locator.dart # GetIt singleton & factory configuration
├── models/              # Data Layer
│   └── task.dart        # Immutable Task model
├── repositories/        # Repository Abstraction Layer
│   └── task_repository.dart # Connects API client to business logic & handles errors
├── services/            # Network Layer
│   └── task_api.dart    # Dio HTTP client setup
├── ui/                  # Presentation / Views
│   └── task_screen.dart # Main screen with BlocConsumer
├── widgets/             # Reusable UI Widgets
│   └── add_task_dialog.dart # Input dialog with validation
└── main.dart            # App entry point initializing DI
```

- **Framework**: Flutter 3.x (Null Safety)
- **State Management**: `flutter_bloc` / `bloc`
- **Dependency Injection**: `get_it`
- **HTTP Client**: `dio`
- **Equality Comparison**: `equatable`

---

## 🌐 Connecting to Local Backend

The backend server default port is `3000`. Depending on your execution environment, set the correct `baseUrl` in `lib/di/service_locator.dart`:

```dart
void setupServiceLocator({String baseUrl = 'http://10.0.2.2:3000'})
```

### 📱 Scenario 1: Android Emulator
Android emulators run in a virtual network. To access `localhost` on your machine, use `10.0.2.2`:
```dart
setupServiceLocator(baseUrl: 'http://10.0.2.2:3000');
```

---

### 🍏 Scenario 2: iOS Simulator / Desktop / Web
iOS Simulators share the host machine's network stack:
```dart
setupServiceLocator(baseUrl: 'http://localhost:3000');
```

---

### 📲 Scenario 3: Physical Mobile Device (Wi-Fi)
To connect a real physical mobile device (Android or iPhone) to your host computer running the Next.js API server:

#### Step 1: Connect to the Same Wi-Fi
Ensure your physical phone and development computer are connected to the **same Wi-Fi network**.

#### Step 2: Find Your Computer's Local IP (`inet`)
Open a terminal on your computer and run:

- **macOS / Linux**:
  ```bash
  ifconfig
  # or
  ip addr show
  ```
  Look for your active Wi-Fi interface (usually `en0` or `wlan0`) and find the `inet` address (e.g. `192.168.1.44` or `192.168.0.100`).

- **Windows**:
  ```cmd
  ipconfig
  ```
  Look for **IPv4 Address** under Wireless LAN adapter Wi-Fi (e.g. `192.168.1.44`).

#### Step 3: Configure `service_locator.dart`
Update `lib/di/service_locator.dart` with your machine's local IP address:
```dart
void setupServiceLocator({String baseUrl = 'http://192.168.1.44:3000'}) {
  getIt.registerLazySingleton<TaskApi>(
    () => TaskApi(baseUrl: baseUrl),
  );
  // ...
}
```

#### Step 4: Ensure Next.js Server Binds to All Interfaces
When running your Next.js API server, bind it to `0.0.0.0` so external devices on the local network can connect:
```bash
npx next dev -H 0.0.0.0 -p 3000
```

---

## 💻 How to Run the App

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Linter / Static Analysis**:
   ```bash
   flutter analyze
   ```

3. **Run Unit Tests**:
   ```bash
   flutter test
   ```

4. **Launch Application**:
   - Select target device (emulator, simulator, or connected device):
     ```bash
     flutter devices
     ```
   - Run:
     ```bash
     flutter run
     ```

---

## 📡 API Endpoints Reference

| HTTP Method | Route | Description | Payload |
|---|---|---|---|
| `GET` | `/api/tasks` | Returns all tasks | None |
| `POST` | `/api/tasks` | Creates a new task | `{"title": "Buy groceries"}` |
| `PATCH` | `/api/tasks/:id` | Updates task status | `{"status": "done"}` |
| `DELETE` | `/api/tasks/:id` | Deletes a task | None |
