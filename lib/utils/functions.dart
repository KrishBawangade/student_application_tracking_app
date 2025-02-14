import 'package:flutter/material.dart';

class AppFunctions{
  static void showDismissibleSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating, // Makes it float above other content
      duration: const Duration(seconds: 3), // Adjust duration as needed
      dismissDirection: DismissDirection.horizontal, // Enables horizontal swipe to dismiss
    ),
  );
}
}