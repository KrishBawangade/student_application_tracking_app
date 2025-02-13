import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthClass {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUserUsingEmailAndPassword(
      {required String email,
      required String password,
      required Function() onSuccess,
      required Function(String) onError}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      onSuccess();
    } on Exception catch (e) {
      onError(e.toString());
    }
  }

  Future<void> signInUserUsingEmailAndPassword({required String email, required String password, required Function() onSuccess, required Function(String) onError}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
    }catch(e){
      onError(e.toString());
    }
  }

  Future<void> logoutUser({required Function() onSuccess, required Function(String) onError})async{
    try{
      await _firebaseAuth.signOut();
      onSuccess();
    }catch(e){
      onError(e.toString());
    }
  }
}
