// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'student_data_model.g.dart';

@JsonSerializable()
class StudentDataModel {
  final String id; 
  final String name;
  final String email;
  final String phoneNumber;
  final String profileImageUrl;
  final List<String> appliedApplicationList;
  final String fcmToken;

  StudentDataModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber = "",
    this.profileImageUrl = "",
    required this.appliedApplicationList,
    this.fcmToken = "",
  });

  factory StudentDataModel.fromJson(Map<String, dynamic> json) => _$StudentDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDataModelToJson(this);
}
