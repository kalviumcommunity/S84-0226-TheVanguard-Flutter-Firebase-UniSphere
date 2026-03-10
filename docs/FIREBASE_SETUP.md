# Firebase Setup Guide for UniSphere

This guide walks you through setting up Firebase for the UniSphere Flutter application.

## Prerequisites

- A Google account
- Flutter SDK installed
- UniSphere project cloned locally
- Basic understanding of Firebase console

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**
3. Enter project name: `UniSphere` (or your preferred name)
4. (Optional) Enable Google Analytics
5. Click **Create Project**
6. Wait for project creation to complete

## Step 2: Add Firebase to Flutter App

### Option A: Using FlutterFire CLI (Recommended)

1. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configure Firebase for your app**:
   ```bash
   flutterfire configure
   ```

3. **Select your Firebase project** from the list

4. **Select platforms** you want to support:
   - ☑️ android
   - ☑️ ios
   - ☑️ macos
   - ☑️ web
   - ☑️ windows

5. The CLI will generate `lib/firebase_options.dart` and platform-specific configuration files

### Option B: Manual Setup

#### For Android

1. In Firebase Console, click **Add app** → **Android**
2. Register app with package name: `com.example.unisphere`
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Add Firebase SDK to `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
6. Apply plugin in `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### For iOS

1. In Firebase Console, click **Add app** → **iOS**
2. Register app with Bundle ID: `com.example.unisphere`
3. Download `GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Drag `GoogleService-Info.plist` into the project
6. Ensure it's added to Runner target

#### For Web

1. In Firebase Console, click **Add app** → **Web**
2. Register app with nickname: `UniSphere Web`
3. Copy the Firebase configuration object
4. Add to `web/index.html` before `</body>`:
   ```html
   <script src="https://www.gstatic.com/firebasejs/10.0.0/firebase-app.js"></script>
   <script src="https://www.gstatic.com/firebasejs/10.0.0/firebase-firestore.js"></script>
   <script>
     const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_PROJECT.firebaseapp.com",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_PROJECT.firebasestorage.app",
       messagingSenderId: "YOUR_SENDER_ID",
       appId: "YOUR_APP_ID"
     };
     firebase.initializeApp(firebaseConfig);
   </script>
   ```

## Step 3: Enable Firebase Services

### Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable sign-in methods:
   - ✅ **Email/Password** (enable)
   - ✅ **Google** (optional, recommended)
4. Configure authorized domains if needed

### Cloud Firestore

1. Go to **Firestore Database**
2. Click **Create Database**
3. Select **Start in test mode** (for development)
4. Choose your region (closest to your users)
5. Click **Enable**

⚠️ **Important**: Update security rules before production!

### Firebase Storage (Optional)

1. Go to **Storage**
2. Click **Get Started**
3. Start in **test mode** for development
4. Choose storage location
5. Click **Done**

## Step 4: Configure Environment Variables

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Fill in your Firebase credentials in `.env`:
   ```env
   # Shared
   MESSAGING_SENDER_ID=123456789
   PROJECT_ID=unisphere-xxxxx
   STORAGE_BUCKET=unisphere-xxxxx.firebasestorage.app

   # Web
   WEB_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   WEB_APP_ID=1:123456789:web:abcdef123456
   WEB_AUTH_DOMAIN=unisphere-xxxxx.firebaseapp.com
   WEB_MEASUREMENT_ID=G-XXXXXXXXXX

   # Android
   ANDROID_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ANDROID_APP_ID=1:123456789:android:abcdef123456

   # iOS & macOS
   IOS_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   IOS_APP_ID=1:123456789:ios:abcdef123456
   IOS_BUNDLE_ID=com.example.unisphere

   # Windows
   WINDOWS_APP_ID=1:123456789:web:abcdef123456
   WINDOWS_MEASUREMENT_ID=G-XXXXXXXXXX
   ```

3. **Never commit `.env` file to version control!**

## Step 5: Update Firestore Security Rules

Replace default rules with production-ready rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId);
    }
    
    // Clubs collection
    match /clubs/{clubId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.ownerId);
    }
    
    // Events collection
    match /events/{eventId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.createdBy);
    }
    
    // Announcements collection
    match /announcements/{announcementId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.createdBy);
    }
    
    // Registrations collection
    match /registrations/{registrationId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.userId);
    }
  }
}
```

## Step 6: Test Firebase Connection

1. Run the app:
   ```bash
   flutter run -d chrome
   ```

2. Check console for Firebase initialization messages

3. Test authentication by creating a test user

4. Verify Firestore connection by fetching data

## Step 7: Create Firestore Indexes

For efficient queries, create indexes:

1. Go to **Firestore** → **Indexes**
2. Click **Add Index**
3. Create indexes for:
   - `events`: `clubId` (Ascending), `date` (Descending)
   - `announcements`: `clubId` (Ascending), `createdAt` (Descending)
   - `registrations`: `userId` (Ascending), `eventId` (Ascending)

## Troubleshooting

### Common Issues

#### "FirebaseException: No Firebase App"

**Solution**: Ensure `Firebase.initializeApp()` is called in `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

#### "google-services.json not found"

**Solution**: Ensure file is in `android/app/` directory and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

#### "Permission denied" on Firestore

**Solution**: Check security rules and ensure user is authenticated

#### Web app can't connect to Firebase

**Solution**: Verify `web/index.html` has correct Firebase config

## Production Checklist

Before deploying to production:

- [ ] Update Firestore security rules
- [ ] Update Storage security rules
- [ ] Enable App Check
- [ ] Set up Firebase Performance Monitoring
- [ ] Configure Firebase Crashlytics
- [ ] Set up backup and recovery
- [ ] Review Firebase quotas and limits
- [ ] Set up billing alerts
- [ ] Configure proper CORS policies
- [ ] Enable Firebase Security Rules testing

## Useful Commands

```bash
# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android
flutter run -d <device_id>

# Clean build
flutter clean && flutter pub get

# Check Firebase config
flutterfire configure

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Cloud Functions
firebase deploy --only functions
```

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)

## Support

If you encounter issues:
1. Check [Firebase Status](https://status.firebase.google.com/)
2. Review [FlutterFire Issues](https://github.com/firebase/flutterfire/issues)
3. Ask in project discussions
4. Contact team leads

---

**Last Updated**: March 2026
