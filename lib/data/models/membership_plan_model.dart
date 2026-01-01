import 'package:json_annotation/json_annotation.dart';

part 'membership_plan_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MembershipPlanModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int durationMonths; // 1, 3, 6, 12
  final List<String> features;
  final DateTime createdAt;

  MembershipPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMonths,
    required this.features,
    required this.createdAt,
  });

  String get durationLabel {
    if (durationMonths == 1) return '1 mois';
    return '$durationMonths mois';
  }

  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipPlanModelToJson(this);
}
