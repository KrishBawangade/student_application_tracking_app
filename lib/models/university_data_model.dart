
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'university_data_model.g.dart';

@JsonSerializable()
class UniversityDataModel {
   final String id; // Unique ID for the university (from Firestore or other database)
  final String name;
  final String location; // Could be a more complex object for detailed location info
  final String website;
  final String logoUrl; // URL to the university's logo
  final List<String> programsOffered; // List of programs/majors offered
  final String description; // A brief description of the university
  final int applicationDeadlineMillis; 
  final int appliedStudents;

  UniversityDataModel({
    required this.id,
    required this.name,
    required this.location,
    required this.website,
    required this.logoUrl,
    required this.programsOffered,
    required this.description,
    required this.applicationDeadlineMillis,
    required this.appliedStudents,
  });

  factory UniversityDataModel.fromJson(Map<String, dynamic> json) => _$UniversityDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UniversityDataModelToJson(this);

}
