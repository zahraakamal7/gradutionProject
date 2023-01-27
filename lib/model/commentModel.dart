import 'package:flight_booking_sys/model/userModel.dart';

import 'imageModel.dart';

class CommentModel {
  String? id;
  String? reportId;
  String? parentId;
  String? userId;
  String? body;
  String? schoolId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<CommentModel>? children;
  List<ImageModel?>? images;
  UserModel? user;
  CommentModel? parent;

  CommentModel(
      {this.id,
      this.reportId,
      this.parentId,
      this.userId,
      this.body,
      this.schoolId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.children,
      this.images,
      this.user,
      this.parent});
  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    reportId = json['report_id']?.toString();
    parentId = json['parent_id']?.toString();
    userId = json['user_id']?.toString();
    body = json['body']?.toString();
    schoolId = json['school_id']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
    images = List<ImageModel>.empty(growable: true);
    if (json["images"] != null)
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
    parent =
        (json['parent'] != null) ? CommentModel.fromJson(json['parent']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['report_id'] = reportId;
    data['parent_id'] = parentId;
    data['user_id'] = userId;
    data['body'] = body;
    data['school_id'] = schoolId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
