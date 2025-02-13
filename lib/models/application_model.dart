import 'package:json_annotation/json_annotation.dart';
import 'package:student_application_tracking_app/utils/enums.dart';

part 'application_model.g.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
@JsonSerializable()
class ApplicationModel {
  final String id;
  final String studentId; // ID of the student who applied
  final String universityId; // ID of the university applied to
  final String programApplied; // The program the student applied for
  final ApplicationStatus applicationStatus; // (e.g., "Applied," "Under Review," "Admitted," "Rejected")
  final int appliedOnMillis;

  ApplicationModel({
    required this.id,
    required this.studentId,
    required this.universityId,
    required this.programApplied,
    required this.applicationStatus,
    required this.appliedOnMillis,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);

}
