import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final String id;
  @JsonKey(name: 'role')
  final String type; // 'member', 'coach', 'admin'
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final String? gender;
  @JsonKey(name: 'avatar_url')
  final String? photo;
  final String? qrCode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.birthDate,
    this.gender,
    this.photo,
    this.qrCode,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
