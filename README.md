# Student Application Tracking App

This Flutter application helps students track the status of their university applications.  It provides a dashboard to view ongoing, accepted, and rejected applications, along with detailed information about each application.

## Overview

This app simplifies the process of managing university applications for students.  It eliminates the need to manually check different university websites or email threads by providing a centralized dashboard with real-time application status updates.

## Features

*   **Application Dashboard:** View all applications in one place, categorized by status (Ongoing, Accepted, Rejected).
*   **Search and Filter:** Search for applications by university name and filter by application status.
*   **Application Details:** View detailed information about each application, including the program applied for, application date, and current status.
*   **University Information:** Access basic information about the universities to which you have applied (if available).
*   **Progress Tracking:** Visualize the progress of each application with a circular progress indicator.
*   **User Authentication:** (If implemented) Secure user authentication to protect application data.
*   **Push Notifications:** (If implemented) Receive push notifications for application status updates.

## Technologies Used

*   **Flutter:** The primary framework for building the cross-platform mobile application.
*   **Dart:** The programming language used for Flutter development.
*   **Firebase:** Cloud platform for backend services like authentication and data storage.
*   **Provider:** State management solution for Flutter.
*   **Cached Network Image:** For efficient image loading and caching.
*   **Intl:** For date formatting and localization.
*   **Percent Indicator:** For displaying progress visualization.
*   **Other Packages:** List any other Dart packages used (e.g., http, cloud_firestore, firebase_auth, etc.).

## Setup

1.  **Flutter Installation:** Ensure you have Flutter installed and configured on your development machine.  Refer to the official Flutter documentation for installation instructions: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

2.  **Project Setup:**
    *   Clone the repository: `git clone <repository_url>`
    *   Navigate to the project directory: `cd student_application_tracking_app`
    *   Install dependencies: `flutter pub get`

3.  **Firebase Configuration:**
    *   Create a Firebase project in the Firebase console ([https://console.firebase.google.com/](https://console.firebase.google.com/)).
    *   Register your app with Firebase.
    *   Add the Firebase configuration files (e.g., `google-services.json` for Android, `GoogleService-Info.plist` for iOS) to the appropriate platform directories in your Flutter project.

4.  **Android Setup (If building for Android):**
    *   Ensure you have the Android SDK, Android Studio (or just the SDK and command-line tools), and a JDK installed.
    *   Configure the `ANDROID_HOME` environment variable.
    *   Run `flutter config --android-sdk <path-to-android-sdk>` and `flutter config --enable-android`.

5.  **iOS Setup (If building for iOS):**
    *   Ensure you have Xcode installed on a macOS machine.

6.  **Run the App:**
    *   Connect a physical device or use an emulator.
    *   Run the app: `flutter run`

## App Functionality

1.  **Dashboard:** The dashboard displays a list of applications, categorized by status (Ongoing, Accepted, Rejected).
2.  **Search:** Users can search for applications by typing in the search field. The search is performed on the university name.
3.  **Filtering:** The applications displayed are also filtered by the selected tab (Ongoing, Accepted, Rejected).
4.  **Application Details:** Tapping on an application in the list will navigate to the Application Status Page, displaying details about the selected application.
5.  **Application Status Page:** This page shows the university logo (if available), university name and location, application details (program applied, applied on, status), and a circular progress indicator visualizing the application's progress.

## Future Improvements ()

*   Implement user authentication.
*   Add push notifications for application status updates.
*   Integrate with specific university APIs for more accurate and real-time data.
*   Improve UI/UX.


Contact: 
  Email: krishbawangade08@gmail.com
