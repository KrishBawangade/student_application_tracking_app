import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:student_application_tracking_app/services/firebase/firebase_auth_class.dart';

class UserAuthProvider extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthClass _authService = FirebaseAuthClass();
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  UserAuthProvider() {
    _firebaseAuth.userChanges().listen((user) async{
      _user = user;
      notifyListeners();
    });
  }

  Future<void> createUserUsingEmailAndPassword({
    required String email,
    required String password,
    required VoidCallback onSuccess, // Callback for success
    required Function(String) onError, // Callback for error
  }) async {
    try {
      await _authService.createUserUsingEmailAndPassword(
        email: email,
        password: password,
        onSuccess: () {
          notifyListeners();
          onSuccess(); // Call the success callback
        },
        onError: (error) {
          onError(error); // Call the error callback
        },
      );
    } catch (e) {
      onError(e.toString()); // Call the error callback for other exceptions
    }
  }

  Future<void> signInUserUsingEmailAndPassword({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await _authService.signInUserUsingEmailAndPassword(
        email: email,
        password: password,
        onSuccess: () {
          notifyListeners();
          onSuccess();
        },
        onError: (error) {
          onError(error);
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> logoutUser({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await _authService.logoutUser(
        onSuccess: () {
          _user = null;
          notifyListeners();
          onSuccess();
        },
        onError: (error) {
          onError(error);
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }
}