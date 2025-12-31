import 'package:json_annotation/json_annotation.dart';
import 'member_model.dart';
import 'branch_model.dart';

part 'sparring_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SparringRequestModel {
  final int id;
  final int requesterId;
  final int requestedId;
  final int branchId;
  final String? discipline;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime? proposedTime;
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relations
  final MemberModel? requester;
  final MemberModel? requested;
  final BranchModel? branch;

  SparringRequestModel({
    required this.id,
    required this.requesterId,
    required this.requestedId,
    required this.branchId,
    this.discipline,
    required this.status,
    this.proposedTime,
    this.message,
    required this.createdAt,
    required this.updatedAt,
    this.requester,
    this.requested,
    this.branch,
  });

  factory SparringRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SparringRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SparringRequestModelToJson(this);
}
