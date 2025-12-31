import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'branch_model.dart';

part 'member_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MemberModel {
  final int id;
  final int userId;
  final int primaryBranchId;
  final List<int>? accessibleBranches; // IDs des branches accessibles
  final String? goal;
  final String level;
  final List<String>? specializations;
  final String subscriptionStatus;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final int loyaltyPoints;

  // Relations (optionnel, chargées séparément)
  final UserModel? user;
  final BranchModel? primaryBranch;

  MemberModel({
    required this.id,
    required this.userId,
    required this.primaryBranchId,
    this.accessibleBranches,
    this.goal,
    required this.level,
    this.specializations,
    required this.subscriptionStatus,
    this.subscriptionStart,
    this.subscriptionEnd,
    required this.loyaltyPoints,
    this.user,
    this.primaryBranch,
  });

  bool get hasActiveSubscription {
    if (subscriptionStatus != 'active') return false;
    if (subscriptionEnd == null) return false;
    return subscriptionEnd!.isAfter(DateTime.now());
  }

  bool canAccessBranch(int branchId) {
    // Si abonnement premium, accès à toutes les branches
    if (accessibleBranches == null) return true;
    // Sinon, vérifier si la branche est dans la liste
    return accessibleBranches!.contains(branchId);
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
