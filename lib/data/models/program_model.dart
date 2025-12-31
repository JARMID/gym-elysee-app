import 'package:json_annotation/json_annotation.dart';

part 'program_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProgramModel {
  final int id;
  final String name;
  final String description;
  final int coachId;
  final String coachName;
  final String? coachPhoto;
  final int branchId;
  final String branchName;
  final String type;
  final String level;
  final int durationWeeks;
  final int sessionsPerWeek;
  final String? coverImage;
  final double rating;
  final int enrolledCount;
  final bool isPublic;
  final double? price;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coachId,
    required this.coachName,
    this.coachPhoto,
    required this.branchId,
    required this.branchName,
    required this.type,
    required this.level,
    required this.durationWeeks,
    required this.sessionsPerWeek,
    this.coverImage,
    required this.rating,
    required this.enrolledCount,
    required this.isPublic,
    this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramModelToJson(this);
}
