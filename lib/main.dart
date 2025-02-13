import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_application_tracking_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:student_application_tracking_app/providers/user_auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
