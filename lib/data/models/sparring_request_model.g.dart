// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sparring_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SparringRequestModel _$SparringRequestModelFromJson(
        Map<String, dynamic> json) =>
    SparringRequestModel(
      id: (json['id'] as num).toInt(),
      requesterId: (json['requester_id'] as num).toInt(),
      requestedId: (json['requested_id'] as num).toInt(),
      branchId: (json['branch_id'] as num).toInt(),
      discipline: json['discipline'] as String?,
      status: json['status'] as String,
      proposedTime: json['proposed_time'] == null
          ? null
          : DateTime.parse(json['proposed_time'] as String),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      requester: json['requester'] == null
          ? null
          : MemberModel.fromJson(json['requester'] as Map<String, dynamic>),
      requested: json['requested'] == null
          ? null
          : MemberModel.fromJson(json['requested'] as Map<String, dynamic>),
      branch: json['branch'] == null
          ? null
          : BranchModel.fromJson(json['branch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SparringRequestModelToJson(
        SparringRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requester_id': instance.requesterId,
      'requested_id': instance.requestedId,
      'branch_id': instance.branchId,
      'discipline': instance.discipline,
      'status': instance.status,
      'proposed_time': instance.proposedTime?.toIso8601String(),
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'requester': instance.requester,
      'requested': instance.requested,
      'branch': instance.branch,
    };
