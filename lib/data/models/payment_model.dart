import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentModel {
  final int id;
  final int memberId;
  final int? subscriptionId;
  final double amount;
  final String currency;
  final String
  method; // 'edahabia', 'cib', 'baridimob', 'cash', 'bank_transfer'
  final Map<String, dynamic>? installmentPlan;
  final String? proofFile;
  final String status; // 'pending', 'validated', 'rejected', 'refunded'
  final int? validatedBy;
  final DateTime? validatedAt;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentModel({
    required this.id,
    required this.memberId,
    this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.method,
    this.installmentPlan,
    this.proofFile,
    required this.status,
    this.validatedBy,
    this.validatedAt,
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isValidated => status == 'validated';

  String get formattedAmount => '$amount $currency';

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
