import 'package:flutter/foundation.dart';
import 'package:student_application_tracking_app/models/application_model.dart';
import 'package:student_application_tracking_app/models/student_data_model.dart';
import 'package:student_application_tracking_app/services/firebase/firestore_class.dart';
import 'package:student_application_tracking_app/utils/enums.dart'; // Import enums

class StudentDataProvider extends ChangeNotifier {
  final FirestoreClass _firestoreService = FirestoreClass();
  StudentDataModel? _studentData;
  List<ApplicationModel>? _appliedApplicationList;
  bool _isLoadingStudentData = false;
  bool _isLoadingApplications = false;

  List<ApplicationModel> _ongoingApplications = [];
  List<ApplicationModel> _acceptedApplications = [];
  List<ApplicationModel> _rejectedApplications = [];


  StudentDataModel? get studentData => _studentData;
  List<ApplicationModel>? get appliedApplicationList => _appliedApplicationList;
  bool get isLoadingStudentData => _isLoadingStudentData;
  bool get isLoadingApplications => _isLoadingApplications;

  List<ApplicationModel> get ongoingApplications => _ongoingApplications;
  List<ApplicationModel> get acceptedApplications => _acceptedApplications;
  List<ApplicationModel> get rejectedApplications => _rejectedApplications;


  Future<void> loadStudentData({
    required String studentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    _isLoadingStudentData = true;
    notifyListeners();

    try {
      _firestoreService.getStudentById(
        studentId: studentId,
        onError: (error) {
          _isLoadingStudentData = false;
          notifyListeners();
          onError(error);
        },
      ).listen((doc) {
        _isLoadingStudentData = false;
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
      _isLoadingStudentData = false;
      notifyListeners();
      onError(e.toString());
    }
  }

  Future<void> loadStudentApplications({
    required String studentId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    _isLoadingApplications = true;
    notifyListeners();

    try {
      _firestoreService.getStudentApplicationList(
        studentId: studentId,
        onError: (error) {
          _isLoadingApplications = false;
          notifyListeners();
          onError(error);
        },
      ).listen((snapshot) {
        _isLoadingApplications = false;
        notifyListeners();

        _appliedApplicationList = snapshot.docs
            .map((doc) => ApplicationModel.fromJson(doc.data()))
            .toList();

        _filterApplicationsByStatus(); // Filter applications

        onSuccess();
        notifyListeners();
      });
    } catch (e) {
      _isLoadingApplications = false;
      notifyListeners();
      onError(e.toString());
    }
  }

  void _filterApplicationsByStatus() {
    if (_appliedApplicationList == null) return;

    _ongoingApplications = _appliedApplicationList!.where((app) =>
        app.applicationStatus != ApplicationStatus.accepted &&
        app.applicationStatus != ApplicationStatus.rejected).toList();

    _acceptedApplications = _appliedApplicationList!.where((app) =>
        app.applicationStatus == ApplicationStatus.accepted).toList();

    _rejectedApplications = _appliedApplicationList!.where((app) =>
        app.applicationStatus == ApplicationStatus.rejected).toList();

    notifyListeners();
  }
}