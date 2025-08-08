# Task_Management_app

This is a simple task/note management mobile app built with Flutter, created as part of a technical interview challenge.

---

## 📱 Features

- Create, edit, delete tasks
- Add task title, content, category, and due date
- View tasks on a dashboard with filtering:
  - Search by title/content/category
  - Filter by date
  - Filter by category
- Store data locally using SharedPreferences
- Basic error handling and smooth UI

---

## 🛠️ Tech Stack

- **Flutter**
- **SharedPreferences** (for local storage)
- **setState** (for state management)
- **Intl** (for date formatting)

---

## 📦 Setup Instructions

1. **Clone repo / extract ZIP**
2. Run `flutter pub get`
3. Run with `flutter run` on any emulator or real device

> If you face issues with dependencies, try:
```bash
flutter clean
flutter pub get
