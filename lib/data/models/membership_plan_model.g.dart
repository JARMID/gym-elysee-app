// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipPlanModel _$MembershipPlanModelFromJson(Map<String, dynamic> json) =>
    MembershipPlanModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      durationMonths: (json['duration_months'] as num).toInt(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MembershipPlanModelToJson(
        MembershipPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'duration_months': instance.durationMonths,
      'features': instance.features,
      'created_at': instance.createdAt.toIso8601String(),
    };
