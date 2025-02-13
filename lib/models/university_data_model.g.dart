// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UniversityDataModel _$UniversityDataModelFromJson(Map<String, dynamic> json) =>
    UniversityDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      website: json['website'] as String,
      logoUrl: json['logoUrl'] as String,
      programsOffered: (json['programsOffered'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      applicationDeadlineMillis:
          (json['applicationDeadlineMillis'] as num).toInt(),
      appliedStudents: (json['appliedStudents'] as num).toInt(),
    );

Map<String, dynamic> _$UniversityDataModelToJson(
        UniversityDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'website': instance.website,
      'logoUrl': instance.logoUrl,
      'programsOffered': instance.programsOffered,
      'description': instance.description,
      'applicationDeadlineMillis': instance.applicationDeadlineMillis,
      'appliedStudents': instance.appliedStudents,
    };
