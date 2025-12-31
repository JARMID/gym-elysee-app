import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'coach_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CoachModel {
  final int id;
  final int userId;
  final int primaryBranchId;
  final List<String> certifications;
  final List<String> specializations;
  final String bio;
  final int experienceYears;
  final double rating;
  final int totalStudents;
  final Map<String, dynamic>? availability;
  final double? hourlyRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optionally loaded relations
  final UserModel? user;
  final String? branchName;

  CoachModel({
    required this.id,
    required this.userId,
    required this.primaryBranchId,
    required this.certifications,
    required this.specializations,
    required this.bio,
    required this.experienceYears,
    required this.rating,
    required this.totalStudents,
    this.availability,
    this.hourlyRate,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.branchName,
  });

  String get fullName => user?.fullName ?? 'Coach #$id';
  bool get offersPrivateSessions => hourlyRate != null && hourlyRate! > 0;

  factory CoachModel.fromJson(Map<String, dynamic> json) =>
      _$CoachModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoachModelToJson(this);
}
