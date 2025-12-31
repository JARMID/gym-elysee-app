import 'package:json_annotation/json_annotation.dart';
import 'coach_model.dart';
import 'program_model.dart';

part 'branch_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BranchModel {
  final int id;
  final String name;
  final String type; // 'flagship', 'boxing', 'mma', etc.
  final String description;
  final String address;
  final String city;
  final String wilaya;
  final double? latitude;
  final double? longitude;
  final String phone;
  final Map<String, String> openingHours;
  // ramadan_hours is a nested structure: {day: {open: time, close: time}}
  @JsonKey(fromJson: _ramadanHoursFromJson, toJson: _ramadanHoursToJson)
  final Map<String, Map<String, String>>? ramadanHours;
  final int capacity;
  final List<String> equipment;
  final List<String> photos;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Appended / Relations
  final List<String>? tags;
  final List<CoachModel>? coaches;
  final List<ProgramModel>? programs;

  BranchModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.address,
    required this.city,
    required this.wilaya,
    this.latitude,
    this.longitude,
    required this.phone,
    required this.openingHours,
    this.ramadanHours,
    required this.capacity,
    required this.equipment,
    required this.photos,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.tags,
    this.coaches,
    this.programs,
  });

  String get fullAddress => '$address, $city, $wilaya';

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}

// Custom converter for ramadan_hours nested structure
Map<String, Map<String, String>>? _ramadanHoursFromJson(dynamic json) {
  if (json == null) return null;
  if (json is! Map) return null;

  final result = <String, Map<String, String>>{};
  for (final entry in (json as Map<String, dynamic>).entries) {
    if (entry.value is Map) {
      result[entry.key] = (entry.value as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v.toString()),
      );
    }
  }
  return result.isEmpty ? null : result;
}

dynamic _ramadanHoursToJson(Map<String, Map<String, String>>? hours) => hours;
