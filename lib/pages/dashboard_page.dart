import 'package:cached_network_image/cached_network_image.dart';
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

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<ApplicationModel> _filteredOngoingApplications = [];
  List<ApplicationModel> _filteredAcceptedApplications = [];
  List<ApplicationModel> _filteredRejectedApplications = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
    StudentDataProvider studentDataProvider = Provider.of(context, listen: false);
    UniversityProvider universityProvider = Provider.of(context, listen: false);
    _tabController?.addListener((){
      setState(() {
        _filterApplications(studentDataProvider, universityProvider.universities??[]);
      });
    });
    Future.microtask(() => _loadData());
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    setState(() {});

    await _loadUniversityList();
    await _fetchApplications();

    _isLoading = false;
    setState(() {});
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
          _filteredOngoingApplications =
              studentDataProvider.ongoingApplications;
          _filteredAcceptedApplications =
              studentDataProvider.acceptedApplications;
          _filteredRejectedApplications =
              studentDataProvider.rejectedApplications;
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildApplicationSummary(applicationList),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by University Name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filterApplications(studentDataProvider, universityList);
                      });
                    },
                  ),
                  TabBar(
                    controller: _tabController, // Connect to the controller
                    onTap: (index) {
                      setState(() {}); // Important: Call setState here!
                    },
                    tabs: const [
                      Tab(text: "Ongoing"), // Define the tabs
                      Tab(text: "Accepted"),
                      Tab(text: "Rejected"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildApplicationList(
                        _filteredOngoingApplications, universityList),

                        _buildApplicationList(
                        _filteredAcceptedApplications, universityList),

                        _buildApplicationList(
                        _filteredRejectedApplications, universityList),
                    ])
                    
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

    return Card(
      // Wrap summary in a Card
      elevation: 4.0, // Add elevation
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem("Ongoing", ongoing, Colors.blue),
            _buildSummaryItem("Accepted", accepted, Colors.green),
            _buildSummaryItem("Rejected", rejected, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16)), // Increased font size
        Text(count.toString(),
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16)), // Increased font size
      ],
    );
  }

  void _filterApplications(
    StudentDataProvider studentDataProvider,
    List<UniversityDataModel> universityList) {

  List<ApplicationModel> applications = [];

  switch (_tabController?.index) {
    case 0:
      applications = List.from(studentDataProvider.ongoingApplications);
      break;
    case 1:
      applications = List.from(studentDataProvider.acceptedApplications);
      break;
    case 2:
      applications = List.from(studentDataProvider.rejectedApplications);
      break;
  }

  // Filter by search query (always applied):
  List<ApplicationModel> filteredApplications = applications.where((app) {
    if (_searchQuery.isEmpty) return true; // Include all if search is empty

    UniversityDataModel? university;
    try {
      university = universityList
          .firstWhere((u) => u.id == app.universityId);
    } catch (_) {}

    return (university?.name ?? "")
        .toLowerCase()
        .contains(_searchQuery.toLowerCase());
  }).toList();

  // Update the appropriate filtered list:
  switch (_tabController?.index) {
    case 0:
      _filteredOngoingApplications = filteredApplications;
      break;
    case 1:
      _filteredAcceptedApplications = filteredApplications;
      break;
    case 2:
      _filteredRejectedApplications = filteredApplications;
      break;
  }

  setState(() {});
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
          elevation: 2.0, // Add elevation to cards
          margin: const EdgeInsets.symmetric(vertical: 8.0), // Add margin
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: university?.imageUrl ?? "",
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  placeholder: (context, url) => Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.school,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  errorWidget: (context, url, error) => Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Icon(Icons.school,
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ),
            ),
            title: Text(university?.name ?? "N/A",
                style: const TextStyle(
                    fontWeight: FontWeight.w500)), // Style title
            subtitle: Text(application.programApplied),
            trailing: Text(application.applicationStatus.name),
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ApplicationStatusPage(
                    application: application,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
