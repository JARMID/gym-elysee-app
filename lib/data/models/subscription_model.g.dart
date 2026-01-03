// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      planId: (json['plan_id'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      status: json['status'] as String,
      qrCode: json['qr_code'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      planName: json['plan_name'] as String?,
      planPrice: (json['plan_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'plan_id': instance.planId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'status': instance.status,
      'qr_code': instance.qrCode,
      'created_at': instance.createdAt.toIso8601String(),
      'plan_name': instance.planName,
      'plan_price': instance.planPrice,
    };
