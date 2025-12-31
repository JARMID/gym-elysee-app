import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'post_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PostModel {
  final int id;
  final int userId;
  final String content;
  final List<String>? media;
  final String type; // 'achievement', 'progress', 'motivation', 'question'
  final int likesCount;
  final int commentsCount;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optionally loaded relations
  final UserModel? user;
  final bool? isLikedByMe;

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    this.media,
    required this.type,
    required this.likesCount,
    required this.commentsCount,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.isLikedByMe,
  });

  String get authorName => user?.fullName ?? 'Membre';
  bool get hasMedia => media != null && media!.isNotEmpty;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CommentModel {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final DateTime createdAt;
  final UserModel? user;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
