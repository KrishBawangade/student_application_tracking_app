import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingClass {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Request permission for push notifications
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission for notifications.');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission for notifications.');
    } else {
      debugPrint('User declined or has not yet requested permission.');
    }
  }

  // Get the FCM token for the device
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
      return null;
    }
  }

  // Subscribe to a topic (for group notifications)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }

  // Handle incoming messages (when the app is in the foreground)
  void handleForegroundMessage(
      {required Function(RemoteMessage) onMessage}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessage(message);
    });
  }

  // Get initial message (when the app is opened from a terminated state)
  Future<RemoteMessage?> getInitialMessage() async {
    try {
      RemoteMessage? initialMessage =
          await _firebaseMessaging.getInitialMessage();
      return initialMessage;
    } catch (e) {
      debugPrint("Error getting initial message: $e");
      return null;
    }
  }

}