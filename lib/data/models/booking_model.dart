import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BookingModel {
  final int id;
  final int memberId;
  final int? coachId;
  final int branchId;
  final String
  type; // 'group_class', 'private_session', 'sparring', 'assessment'
  final DateTime scheduledAt;
  final int durationMinutes;
  final int? maxParticipants;
  final int currentParticipants;
  final String
  status; // 'pending', 'confirmed', 'completed', 'cancelled', 'no_show'
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optionally loaded relations
  final String? coachName;
  final String? branchName;

  BookingModel({
    required this.id,
    required this.memberId,
    this.coachId,
    required this.branchId,
    required this.type,
    required this.scheduledAt,
    required this.durationMinutes,
    this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.coachName,
    this.branchName,
  });

  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());
  bool get isFull =>
      maxParticipants != null && currentParticipants >= maxParticipants!;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
