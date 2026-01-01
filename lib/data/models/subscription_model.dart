import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SubscriptionModel {
  final int id;
  final String userId; // UUID from Supabase
  final int planId;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'inactive', 'pending', 'expired'
  final String? qrCode;
  final DateTime createdAt;

  // Relations (optional, populated from joins)
  final String? planName;
  final double? planPrice;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.qrCode,
    required this.createdAt,
    this.planName,
    this.planPrice,
  });

  bool get isActive => status == 'active' && endDate.isAfter(DateTime.now());

  int get daysRemaining {
    if (!isActive) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
