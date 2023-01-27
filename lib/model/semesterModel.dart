import 'package:flight_booking_sys/model/degreeModel.dart';
import 'package:supercharged/supercharged.dart';

class SemesterModel {
  String? id;
  String? name;
  int? maxDegree;
  String? classId;
  String? schoolId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<DegreeModel?>? degrees;

  SemesterModel({
    this.id,
    this.name,
    this.maxDegree,
    this.classId,
    this.schoolId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.degrees,
  });
  SemesterModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    maxDegree = (json['max_degree'] as String?)?.toInt();
    classId = json['class_id']?.toString();
    schoolId = json['school_id']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    degrees = List<DegreeModel>.empty(growable: true);
    if (json["degrees"] != null)
      json['degrees'].forEach((v) {
        degrees!.add(DegreeModel.fromJson(v));
      });
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['max_degree'] = maxDegree;
    data['class_id'] = classId;
    data['school_id'] = schoolId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}
