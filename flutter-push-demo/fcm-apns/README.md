# Agora Chat Push Demo flutter 

[![Watch the video](https://img.youtube.com/vi/AtUhDZROifE/0.jpg)](https://www.youtube.com/watch?v=AtUhDZROifE)

## Introduction
This repository demonstrates how to send push notifications on Android via the FCM service and directly to iOS devices using Apple Push Notification Service (APNs), without relying on the FCM service for iOS.

## Requirements
* Flutter 3.16.0 or later
* Dart 3.3.0 or later
* FlutterFire CLI   
  Install the FlutterFire CLI `dart pub global activate flutterfire_cli`

Before you begin, make sure that:
- You have [updated fcm certificate and apns certificate to agora console](https://docs.agora.io/en/agora-chat/develop/offline-push?platform=flutter#2-upload-fcm-certificate-to-)
  <img width="1277" alt="image" src="https://github.com/user-attachments/assets/68af8623-fa72-4fcc-ae13-009aa5e60b0b">


## Getting Started
1. Clone the repository.
2. Navigate to the project directory with `cd agora-chat-push-demo-flutter/fcm-apns`.
3. Initialize Firebase with `flutterfire configure`.
4. Update `lib/consts.dart` with your Firebase and Agora Chat credentials.
5. Install dependencies with `flutter pub get`.
6. Run the app using `flutter run --verbose`.

After running the app, you can test whether the push notification credentials and notification services work properly via Agora Chat [Notification management RESTful API](https://github.com/ycj3/agora-chat-push-demo-flutter/wiki/Testing-if-Push-Notifications-are-Setup-Correctly)

## Need Help?
If you encounter any issues or have questions, feel free to [file an issue](https://github.com/ycj3/agora-chat-push-demo-flutter/issues/new/choose) on the repository. We’re here to help!
