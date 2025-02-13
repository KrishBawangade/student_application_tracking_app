// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentDataModel _$StudentDataModelFromJson(Map<String, dynamic> json) =>
    StudentDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String? ?? "",
      profileImageUrl: json['profileImageUrl'] as String? ?? "",
      appliedApplicationList: (json['appliedApplicationList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StudentDataModelToJson(StudentDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profileImageUrl': instance.profileImageUrl,
      'appliedApplicationList': instance.appliedApplicationList,
    };
