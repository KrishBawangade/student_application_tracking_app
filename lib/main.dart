import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_application_tracking_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:student_application_tracking_app/pages/login_page.dart';
import 'package:student_application_tracking_app/providers/user_auth_provider.dart';
import 'package:student_application_tracking_app/utils/themes.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Set the background message handler *before* running the app
  FirebaseMessaging.onBackgroundMessage( _firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserAuthProvider()),
    ],
    child: const MainApp(),
  ),
);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      home: LoginPage(),
    );
  }
}
