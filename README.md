# 📱 UniSphere  
### Centralized Platform for College Clubs & Student Communities  

---

## 📌 Overview  

**UniSphere** is a cross-platform mobile application designed to simplify how college clubs and student communities manage events, communication, and participation.

Built using **Flutter** and **Firebase**, the platform centralizes registrations, announcements, and attendance tracking into one unified system.

---

## 🚩 Problem Statement  

College clubs and student communities currently manage:

- 📢 Announcements across scattered platforms  
- 📝 Event registrations through multiple forms  
- 📊 Attendance tracking manually or separately  

This fragmented approach makes coordination inefficient, confusing, and frustrating.

### ❓ How might we centralize event registrations, announcements, and attendance in one place?

---

## ✅ Solution  

UniSphere provides a **single digital platform** where:

- 📢 Clubs can post announcements  
- 📝 Students can register for events  
- 📊 Attendance can be tracked digitally  
- 🔔 Real-time updates keep everyone informed  

By combining cross-platform access with real-time backend services, UniSphere simplifies coordination and improves engagement.

---

## 🛠 Tech Stack  

### 🎨 Frontend
- Flutter  
- Dart  

### 🔥 Backend
- Firebase Authentication  
- Cloud Firestore  
- Firebase Storage  
- Cloud Functions  

### ☁️ Infrastructure & DevOps
- Google Cloud  
- Firebase Hosting  
- GitHub Actions (CI/CD)

---

## 🚀 Getting Started  

### Prerequisites

Before running the application, ensure you have:

- **Flutter SDK** (3.11.0 or higher) installed
- **Dart SDK** (comes with Flutter)
- **Git** for version control
- An IDE: **VS Code** or **Android Studio**
- A device/emulator for testing (Chrome, Android, iOS, etc.)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/kalviumcommunity/S84-0226-TheVanguard-Flutter-Firebase-UniSphere.git
   cd S84-0226-TheVanguard-Flutter-Firebase-UniSphere
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```

4. **Configure your `.env` file** with Firebase credentials:
   ```bash
   # Shared
   MESSAGING_SENDER_ID=your_messaging_sender_id
   PROJECT_ID=your_project_id
   STORAGE_BUCKET=your_project_id.firebasestorage.app

   # Web
   WEB_API_KEY=your_web_api_key
   WEB_APP_ID=your_web_app_id
   WEB_AUTH_DOMAIN=your_project_id.firebaseapp.com
   WEB_MEASUREMENT_ID=your_web_measurement_id

   # Android
   ANDROID_API_KEY=your_android_api_key
   ANDROID_APP_ID=your_android_app_id

   # iOS & macOS
   IOS_API_KEY=your_ios_api_key
   IOS_APP_ID=your_ios_app_id
   IOS_BUNDLE_ID=com.example.yourapp

   # Windows
   WINDOWS_APP_ID=your_windows_app_id
   WINDOWS_MEASUREMENT_ID=your_windows_measurement_id
   ```

5. **Configure Firebase** (See detailed guide in `docs/FIREBASE_SETUP.md`):
   - Add `google-services.json` for Android
   - Add `GoogleService-Info.plist` for iOS
   - Ensure Firebase is properly initialized

6. **Run the application**:
   ```bash
   # For web
   flutter run -d chrome

   # For mobile (with connected device/emulator)
   flutter run

   # For specific device
   flutter run -d <device_id>
   ```

### Verify Installation

```bash
# Check Flutter environment
flutter doctor

# Run analyzer to check for issues
flutter analyze

# Run tests
flutter test
```

---

## 📚 Documentation  

- [Contributing Guidelines](CONTRIBUTING.md)
- [Firebase Setup Guide](docs/FIREBASE_SETUP.md)
- [Architecture Documentation](ARCHITECTURE.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

---

## 🤝 Contributing  

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting a pull request.

---

## 📄 License  

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team  

**TheVanguard**  
Kalvium Community Project  

---

## 📧 Contact  

For questions or support, please open an issue in the repository.
- GitHub Actions (CI/CD)