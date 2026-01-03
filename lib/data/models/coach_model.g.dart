// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoachModel _$CoachModelFromJson(Map<String, dynamic> json) => CoachModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      primaryBranchId: (json['primary_branch_id'] as num).toInt(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bio: json['bio'] as String,
      experienceYears: (json['experience_years'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      totalStudents: (json['total_students'] as num).toInt(),
      availability: json['availability'] as Map<String, dynamic>?,
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      branchName: json['branch_name'] as String?,
    );

Map<String, dynamic> _$CoachModelToJson(CoachModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'primary_branch_id': instance.primaryBranchId,
      'certifications': instance.certifications,
      'specializations': instance.specializations,
      'bio': instance.bio,
      'experience_years': instance.experienceYears,
      'rating': instance.rating,
      'total_students': instance.totalStudents,
      'availability': instance.availability,
      'hourly_rate': instance.hourlyRate,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'branch_name': instance.branchName,
    };
