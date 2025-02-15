// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'university_data_model.g.dart';

@JsonSerializable()
class UniversityDataModel {
  final String id;
  final String? name; // Made nullable
  final String? location;
  final String? website; // Made nullable
  final String? imageUrl; // Made nullable
  final List<String>? programs; // Made nullable
  final String? description; // Made nullable
  final int? applicationDeadlineMillis; // Made nullable
  final int? appliedStudents; // Made nullable

  UniversityDataModel({
    required this.id,
    this.name,
    this.location,
    this.website,
    this.imageUrl,
    this.programs,
    this.description,
    this.applicationDeadlineMillis,
    this.appliedStudents,
  });

  factory UniversityDataModel.fromJson(Map<String, dynamic> json) =>
      _$UniversityDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UniversityDataModelToJson(this);
}