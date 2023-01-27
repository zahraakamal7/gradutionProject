import 'package:flight_booking_sys/model/stageModel.dart';

class DailyMaterialModel {
  String? id;
  String? classId;
  List<String?>? materials;
  String? day;
  String? schoolId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  StageModel? stage;

  DailyMaterialModel({
    this.id,
    this.classId,
    this.materials,
    this.day,
    this.schoolId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.stage,
  });
  DailyMaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    classId = json['class_id']?.toString();
    if (json['materials'] != null) {
      final v = json['materials'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      materials = arr0;
    }
    day = json['day']?.toString();
    schoolId = json['school_id']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    stage = (json['stage'] != null) ? StageModel.fromJson(json['stage']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['class_id'] = classId;
    if (materials != null) {
      final v = materials;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['materials'] = arr0;
    }
    data['day'] = day;
    data['school_id'] = schoolId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (stage != null) {
      data['stage'] = stage!.toJson();
    }
    return data;
  }
}
