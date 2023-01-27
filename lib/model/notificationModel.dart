import 'package:flight_booking_sys/model/commentModel.dart';
import 'package:flight_booking_sys/model/userModel.dart';

class NotificationModel {
  String? id;
  String? title;
  String? body;
  String? from;
  int? type;
  String? targetId;
  String? schoolId;
  bool? seen;
  String? createdAt;
  String? updatedAt;
  UserModel? issuer;
  CommentModel? comment;
  String? dailyMaterial;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.from,
    this.type,
    this.targetId,
    this.schoolId,
    this.seen,
    this.createdAt,
    this.updatedAt,
    this.issuer,
    this.comment,
    this.dailyMaterial,
  });
  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    body = json['body']?.toString();
    from = json['from']?.toString();
    type = json['type']?.toInt();
    targetId = json['target_id']?.toString();
    schoolId = json['school_id']?.toString();
    seen = (json['seen'] as bool?);
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    issuer =
        (json['issuer'] != null) ? UserModel.fromJson(json['issuer']) : null;
    comment = (json['comment'] != null)
        ? CommentModel.fromJson(json['comment'])
        : null;
    dailyMaterial = json['daily_material']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['from'] = from;
    data['type'] = type;
    data['target_id'] = targetId;
    data['school_id'] = schoolId;
    data['seen'] = seen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (issuer != null) {
      data['issuer'] = issuer!.toJson();
    }
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    data['daily_material'] = dailyMaterial;
    return data;
  }
}
