import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_application_tracking_app/utils/constants.dart';

class FirestoreClass {
  final _db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot< Map<String, dynamic> >> getStudentById(
      {required String studentId,required Function(String) onError}) {
    try {
      return _db
          .collection(AppConstants.studentCollection)
          .doc(studentId)
          .snapshots();
    } catch (e) {
      onError(e.toString());
      return Stream.error(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentApplicationList(
      {required String studentId,
      required Function(String) onError}) {
    try {
      return _db
          .collection(AppConstants.applicationCollection)
          .where(AppConstants.studentIdField, isEqualTo: studentId)
          .snapshots();
    } catch (e) {
      onError(e.toString());
      return Stream.error(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUniversityList({required Function(String) onError}) {
    try {
      return _db
          .collection(AppConstants.universityCollection)
          .snapshots();
    } catch (e) {
      onError(e.toString());
      return Stream.error(e.toString());
    }
  }

}