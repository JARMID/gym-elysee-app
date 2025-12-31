// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramModel _$ProgramModelFromJson(Map<String, dynamic> json) => ProgramModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      coachId: (json['coach_id'] as num).toInt(),
      coachName: json['coach_name'] as String,
      coachPhoto: json['coach_photo'] as String?,
      branchId: (json['branch_id'] as num).toInt(),
      branchName: json['branch_name'] as String,
      type: json['type'] as String,
      level: json['level'] as String,
      durationWeeks: (json['duration_weeks'] as num).toInt(),
      sessionsPerWeek: (json['sessions_per_week'] as num).toInt(),
      coverImage: json['cover_image'] as String?,
      rating: (json['rating'] as num).toDouble(),
      enrolledCount: (json['enrolled_count'] as num).toInt(),
      isPublic: json['is_public'] as bool,
      price: (json['price'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProgramModelToJson(ProgramModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coach_id': instance.coachId,
      'coach_name': instance.coachName,
      'coach_photo': instance.coachPhoto,
      'branch_id': instance.branchId,
      'branch_name': instance.branchName,
      'type': instance.type,
      'level': instance.level,
      'duration_weeks': instance.durationWeeks,
      'sessions_per_week': instance.sessionsPerWeek,
      'cover_image': instance.coverImage,
      'rating': instance.rating,
      'enrolled_count': instance.enrolledCount,
      'is_public': instance.isPublic,
      'price': instance.price,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
