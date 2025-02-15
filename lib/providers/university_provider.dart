import 'package:flutter/foundation.dart';
import 'package:student_application_tracking_app/models/university_data_model.dart';
import 'package:student_application_tracking_app/services/firebase/firestore_class.dart';

class UniversityProvider extends ChangeNotifier {
  final FirestoreClass _firestoreService = FirestoreClass();
  List<UniversityDataModel>? _universities;
  bool _isLoading = true; // Add loading state

  List<UniversityDataModel>? get universities => _universities;
  bool get isLoading => _isLoading; // Getter for loading state

  // Method to load the list of universities
  Future<void> loadUniversities({
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true; // Set loading to true before fetching
    notifyListeners();

    try {
      _firestoreService.getUniversityList(onError: (error) {
        _isLoading = false; // Set loading to false on error
        notifyListeners();
        onError(error);
      }).listen((snapshot) {
        _isLoading = false; // Set loading to false on success
        notifyListeners();

        _universities = snapshot.docs
            .map((doc) => UniversityDataModel.fromJson(doc.data()))
            .toList();
        onSuccess();
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false; // Set loading to false on error
      notifyListeners();
      onError(e.toString());
    }
  }
}