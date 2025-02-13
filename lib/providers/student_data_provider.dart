import 'package:flutter/foundation.dart';
import 'package:student_application_tracking_app/models/application_model.dart';
import 'package:student_application_tracking_app/models/student_data_model.dart';
import 'package:student_application_tracking_app/services/firebase/firestore_class.dart';

class StudentDataProvider extends ChangeNotifier{
  final FirestoreClass _firestoreService = FirestoreClass();
  StudentDataModel? _studentData;
  List<ApplicationModel>? _appliedApplicationList;

  StudentDataModel? get studentData => _studentData;
  List<ApplicationModel>? get appliedApplicationList => _appliedApplicationList;

  // Method to fetch student data by ID
  Future<void> loadStudentData({
    required String studentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      _firestoreService.getStudentById(
        studentId: studentId,
        onError: (error) => onError(error),
      ).listen((doc) {
        if (doc.exists) {
          _studentData = StudentDataModel.fromJson(doc.data()!);
          onSuccess(); // Call success callback after data is fetched
          notifyListeners();
        } else {
          _studentData = null; // Handle the case where the document doesn't exist
          onError("Student data not found");
          notifyListeners();
        }
      });
    } catch (e) {
      onError(e.toString());
      notifyListeners();
    }
  }

  // Method to fetch student's application list
  Future<void> loadStudentApplications({
    required String studentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      _firestoreService.getStudentApplicationList(
        studentId: studentId,
        onError: (error) => onError(error),
      ).listen((snapshot) {
        _appliedApplicationList = snapshot.docs
            .map((doc) => ApplicationModel.fromJson(doc.data()))
            .toList();
        onSuccess();
        notifyListeners();
      });
    } catch (e) {
      onError(e.toString());
      notifyListeners();
    }
  }

}