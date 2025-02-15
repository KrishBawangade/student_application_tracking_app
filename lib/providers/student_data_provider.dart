import 'package:flutter/foundation.dart';
import 'package:student_application_tracking_app/models/application_model.dart';
import 'package:student_application_tracking_app/models/student_data_model.dart';
import 'package:student_application_tracking_app/services/firebase/firestore_class.dart';

class StudentDataProvider extends ChangeNotifier {
  final FirestoreClass _firestoreService = FirestoreClass();
  StudentDataModel? _studentData;
  List<ApplicationModel>? _appliedApplicationList;
  bool _isLoadingStudentData = false; // Loading state for student data
  bool _isLoadingApplications = false; // Loading state for applications

  StudentDataModel? get studentData => _studentData;
  List<ApplicationModel>? get appliedApplicationList => _appliedApplicationList;
  bool get isLoadingStudentData => _isLoadingStudentData;
  bool get isLoadingApplications => _isLoadingApplications;


  // Method to fetch student data by ID
  Future<void> loadStudentData({
    required String studentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {

    _isLoadingStudentData = true; // Set loading to true before fetching
    notifyListeners();

    try {
      _firestoreService.getStudentById(
        studentId: studentId,
        onError: (error) {
          _isLoadingStudentData = false; // Set loading to false on error
          notifyListeners();
          onError(error);
        },
      ).listen((doc) {
        _isLoadingStudentData = false; // Set loading to false on success
        notifyListeners();

        if (doc.exists) {
          _studentData = StudentDataModel.fromJson(doc.data()!);
          onSuccess(); 
          notifyListeners();
        } else {
          _studentData = null;
          onError("Student data not found");
          notifyListeners();
        }
      });
    } catch (e) {
      _isLoadingStudentData = false; // Set loading to false on error
      notifyListeners();
      onError(e.toString());
    }
  }

  // Method to fetch student's application list
  Future<void> loadStudentApplications({
    required String studentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    _isLoadingApplications = true; // Set loading to true before fetching
    notifyListeners();

    try {
      _firestoreService.getStudentApplicationList(
        studentId: studentId,
        onError: (error) {
          _isLoadingApplications = false; // Set loading to false on error
          notifyListeners();
          onError(error);
        },
      ).listen((snapshot) {
        _isLoadingApplications = false; // Set loading to false on success
        notifyListeners();

        _appliedApplicationList = snapshot.docs
            .map((doc) => ApplicationModel.fromJson(doc.data()))
            .toList();
        onSuccess();
        notifyListeners();
      });
    } catch (e) {
      _isLoadingApplications = false; // Set loading to false on error
      notifyListeners();
      onError(e.toString());
    }
  }
}