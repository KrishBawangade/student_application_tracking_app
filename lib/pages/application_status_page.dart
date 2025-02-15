import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:student_application_tracking_app/models/application_model.dart';
import 'package:student_application_tracking_app/models/university_data_model.dart';
import 'package:student_application_tracking_app/providers/university_provider.dart';
import 'package:student_application_tracking_app/utils/constants.dart';
import 'package:student_application_tracking_app/utils/enums.dart';

class ApplicationStatusPage extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationStatusPage({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final universityProvider = Provider.of<UniversityProvider>(context);
    UniversityDataModel? university;
    try {
      university = universityProvider.universities?.firstWhere(
            (uni) => uni.id == application.universityId
      );
    } catch (e) {
      debugPrint("Error finding university: $e"); // Print the error for debugging
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (university != null) ...[
                Center(
                  child: CachedNetworkImage(
                    imageUrl: university.imageUrl ??
                        'https://via.placeholder.com/200',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    Image.asset(
                      AppConstants.placeHolderImagePath,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AppConstants.placeHolderImagePath,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    university.name ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    university.location ?? 'N/A',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Application Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Program Applied:', application.programApplied),
              _buildDetailRow(
                  'Applied On:',
                  DateFormat('dd MMM yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          application.appliedOnMillis))),
              _buildDetailRow('Status:', application.applicationStatus.name),
              const SizedBox(height: 16),
              Center(
                child: CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 10.0,
                  percent: _getProgressPercentage(application.applicationStatus),
                  center: Text(
                    '${(_getProgressPercentage(application.applicationStatus) * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 20),
                  ),
                  progressColor: _getProgressColor(application.applicationStatus),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  double _getProgressPercentage(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return 0.25;
      case ApplicationStatus.underReview:
        return 0.5;
      case ApplicationStatus.accepted:
        return 1.0;
      case ApplicationStatus.rejected:
        return 1.0;
      default:
        return 0.0;
    }
  }

  Color _getProgressColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.underReview:
        return Colors.orange;
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}