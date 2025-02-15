import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_application_tracking_app/models/application_model.dart';
import 'package:student_application_tracking_app/models/university_data_model.dart';
import 'package:student_application_tracking_app/pages/application_status_page.dart';
import 'package:student_application_tracking_app/providers/student_data_provider.dart';
import 'package:student_application_tracking_app/providers/university_provider.dart';
import 'package:student_application_tracking_app/utils/enums.dart';
import 'package:student_application_tracking_app/widgets/main_app_bar.dart';
import 'package:student_application_tracking_app/widgets/main_app_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<ApplicationModel> _filteredApplications = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    _isLoading = true;
    setState(() {}); // Show loading indicator

    await _loadUniversityList();
    await _fetchApplications();

    _isLoading = false;
    setState(() {}); // Refresh UI after data loads
  }

  Future<void> _loadUniversityList() async {
    final universityProvider =
        Provider.of<UniversityProvider>(context, listen: false);

    debugPrint("Fetching university list...");
    await universityProvider.loadUniversities(
        onSuccess: () => debugPrint(
            "Universities Loaded: ${universityProvider.universities?.length}"),
        onError: (e) => debugPrint("Error Loading Universities: $e"));
  }

  Future<void> _fetchApplications() async {
    final studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: false);

    String studentId = studentDataProvider.studentData?.id ??
        FirebaseAuth.instance.currentUser?.uid ??
        "";
    debugPrint("Fetching applications for student ID: $studentId");

    await studentDataProvider.loadStudentApplications(
        studentId: studentId,
        onSuccess: () {
          debugPrint(
              "Applications Loaded: ${studentDataProvider.appliedApplicationList?.length}");
          _filteredApplications =
              studentDataProvider.appliedApplicationList ?? [];
        },
        onError: (e) => debugPrint("Error Loading Applications: $e"));
  }

  @override
  Widget build(BuildContext context) {
    StudentDataProvider studentDataProvider = Provider.of(context);
    UniversityProvider universityProvider = Provider.of(context);

    List<ApplicationModel> applicationList =
        studentDataProvider.appliedApplicationList ?? [];
    List<UniversityDataModel> universityList =
        universityProvider.universities ?? [];

    return Scaffold(
      appBar: const MainAppBar(title: "Dashboard"),
      drawer: MainAppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildApplicationSummary(applicationList),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by University Name',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filterApplications(applicationList, universityList);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildApplicationList(
                        _filteredApplications, universityList),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildApplicationSummary(List<ApplicationModel> applications) {
    int ongoing = applications
        .where((app) =>
            app.applicationStatus != ApplicationStatus.accepted &&
            app.applicationStatus != ApplicationStatus.rejected)
        .length;
    int accepted = applications
        .where((app) => app.applicationStatus == ApplicationStatus.accepted)
        .length;
    int rejected = applications
        .where((app) => app.applicationStatus == ApplicationStatus.rejected)
        .length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem("Ongoing", ongoing, Colors.blue),
            _buildSummaryItem("Accepted", accepted, Colors.green),
            _buildSummaryItem("Rejected", rejected, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(count.toString(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _filterApplications(List<ApplicationModel> applications,
      List<UniversityDataModel> universityList) {
    if (_searchQuery.isEmpty) {
      _filteredApplications = List.from(applications);
    } else {
      _filteredApplications = applications.where((app) {
        UniversityDataModel? university;
        try {
          university = universityList
              .firstWhere((university) => university.id == app.universityId);
        } catch (_) {}

        return (university?.name ?? "")
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
    setState(() {}); // Refresh the UI with filtered data
  }

  Widget _buildApplicationList(List<ApplicationModel> applications,
      List<UniversityDataModel> universityList) {
    if (applications.isEmpty) {
      return Center(
        child: Text("No applications found.",
            style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor)),
      );
    }

    return ListView.builder(
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];

        UniversityDataModel? university;
        try {
          university = universityList.firstWhere(
              (university) => university.id == application.universityId);
        } catch (_) {
          debugPrint(
              "No matching university found for application: ${application.id}");
        }

        return Card(
          child: ListTile(
            title: Text(university?.name ?? "N/A"),
            subtitle: Text(application.programApplied),
            trailing: Text(application.applicationStatus.name),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ApplicationStatusPage(application: application),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
