import 'package:flutter/foundation.dart';
import 'package:student_application_tracking_app/models/university_data_model.dart';
import 'package:student_application_tracking_app/services/firebase/firestore_class.dart';

class UniversityProvider extends ChangeNotifier{
  final FirestoreClass _firestoreService = FirestoreClass();
  List<UniversityDataModel>? _universities;

  List<UniversityDataModel>? get universities => _universities;

  // Method to load the list of universities
  Future<void> loadUniversities({
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      _firestoreService.getUniversityList(onError: (error) => onError(error)).listen((snapshot) {
        _universities = snapshot.docs
            .map((doc) => UniversityDataModel.fromJson(doc.data()))
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