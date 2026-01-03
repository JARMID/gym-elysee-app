// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: (json['id'] as num).toInt(),
      memberId: (json['member_id'] as num).toInt(),
      coachId: (json['coach_id'] as num?)?.toInt(),
      branchId: (json['branch_id'] as num).toInt(),
      type: json['type'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      maxParticipants: (json['max_participants'] as num?)?.toInt(),
      currentParticipants: (json['current_participants'] as num).toInt(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      coachName: json['coach_name'] as String?,
      branchName: json['branch_name'] as String?,
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'coach_id': instance.coachId,
      'branch_id': instance.branchId,
      'type': instance.type,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'max_participants': instance.maxParticipants,
      'current_participants': instance.currentParticipants,
      'status': instance.status,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'coach_name': instance.coachName,
      'branch_name': instance.branchName,
    };
