// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      primaryBranchId: (json['primary_branch_id'] as num).toInt(),
      accessibleBranches: (json['accessible_branches'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      goal: json['goal'] as String?,
      level: json['level'] as String,
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      subscriptionStatus: json['subscription_status'] as String,
      subscriptionStart: json['subscription_start'] == null
          ? null
          : DateTime.parse(json['subscription_start'] as String),
      subscriptionEnd: json['subscription_end'] == null
          ? null
          : DateTime.parse(json['subscription_end'] as String),
      loyaltyPoints: (json['loyalty_points'] as num).toInt(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      primaryBranch: json['primary_branch'] == null
          ? null
          : BranchModel.fromJson(
              json['primary_branch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'primary_branch_id': instance.primaryBranchId,
      'accessible_branches': instance.accessibleBranches,
      'goal': instance.goal,
      'level': instance.level,
      'specializations': instance.specializations,
      'subscription_status': instance.subscriptionStatus,
      'subscription_start': instance.subscriptionStart?.toIso8601String(),
      'subscription_end': instance.subscriptionEnd?.toIso8601String(),
      'loyalty_points': instance.loyaltyPoints,
      'user': instance.user,
      'primary_branch': instance.primaryBranch,
    };
