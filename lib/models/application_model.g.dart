// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    ApplicationModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      universityId: json['universityId'] as String,
      programApplied: json['programApplied'] as String,
      applicationStatus:
          $enumDecode(_$ApplicationStatusEnumMap, json['applicationStatus']),
      appliedOnMillis: (json['appliedOnMillis'] as num).toInt(),
    );

Map<String, dynamic> _$ApplicationModelToJson(ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'universityId': instance.universityId,
      'programApplied': instance.programApplied,
      'applicationStatus':
          _$ApplicationStatusEnumMap[instance.applicationStatus]!,
      'appliedOnMillis': instance.appliedOnMillis,
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.applied: 'applied',
  ApplicationStatus.applicationReceived: 'applicationReceived',
  ApplicationStatus.underReview: 'underReview',
  ApplicationStatus.interviewScheduled: 'interviewScheduled',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.accepted: 'accepted',
};
