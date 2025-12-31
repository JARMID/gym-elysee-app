// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      id: (json['id'] as num).toInt(),
      memberId: (json['member_id'] as num).toInt(),
      subscriptionId: (json['subscription_id'] as num?)?.toInt(),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      method: json['method'] as String,
      installmentPlan: json['installment_plan'] as Map<String, dynamic>?,
      proofFile: json['proof_file'] as String?,
      status: json['status'] as String,
      validatedBy: (json['validated_by'] as num?)?.toInt(),
      validatedAt: json['validated_at'] == null
          ? null
          : DateTime.parse(json['validated_at'] as String),
      adminNotes: json['admin_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'subscription_id': instance.subscriptionId,
      'amount': instance.amount,
      'currency': instance.currency,
      'method': instance.method,
      'installment_plan': instance.installmentPlan,
      'proof_file': instance.proofFile,
      'status': instance.status,
      'validated_by': instance.validatedBy,
      'validated_at': instance.validatedAt?.toIso8601String(),
      'admin_notes': instance.adminNotes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
