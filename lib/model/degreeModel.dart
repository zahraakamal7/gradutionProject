import 'package:flight_booking_sys/model/materialModel.dart';
import 'package:flight_booking_sys/model/semesterModel.dart';
import 'package:flight_booking_sys/model/stageModel.dart';
import 'package:flight_booking_sys/model/userModel.dart';

class DegreeModel {
  String? id;
  String? userId;
  String? materialId;
  String? classId;
  String? semesterId;
  int? degree;
  int? active;
  String? schoolId;
  String? createdAt;
  String? updatedAt;
  MaterialModel? material;
  SemesterModel? semester;
  UserModel? user;
  StageModel? stage;

  DegreeModel({
    this.id,
    this.userId,
    this.materialId,
    this.classId,
    this.semesterId,
    this.degree,
    this.active,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.material,
    this.semester,
    this.user,
    this.stage,
  });
  DegreeModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['user_id']?.toString();
    materialId = json['material_id']?.toString();
    classId = json['class_id']?.toString();
    semesterId = json['semester_id']?.toString();
    degree = json['degree']?.toInt();
    active = json['active']?.toInt();
    schoolId = json['school_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    material = (json['material'] != null)
        ? MaterialModel.fromJson(json['material'])
        : null;
    semester = (json['semester'] != null)
        ? SemesterModel.fromJson(json['semester'])
        : null;
    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
    stage = (json['stage'] != null) ? StageModel.fromJson(json['stage']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['material_id'] = materialId;
    data['class_id'] = classId;
    data['semester_id'] = semesterId;
    data['degree'] = degree;
    data['active'] = active;
    data['school_id'] = schoolId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (material != null) {
      data['material'] = material!.toJson();
    }
    if (semester != null) {
      data['semester'] = semester!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (stage != null) {
      data['stage'] = stage!.toJson();
    }
    return data;
  }
}
