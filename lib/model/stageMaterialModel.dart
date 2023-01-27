import 'package:flight_booking_sys/model/materialModel.dart';
import 'package:flight_booking_sys/model/stageModel.dart';

class StageMaterialModel {
/*
{
  "id": "",
  "material_id": "4fdf405e-8acc-4253-8b99-d124f886bb66",
  "class_id": "66bc4e9f-4f23-474b-89de-adcd04a2e661",
  "teacher_id": "151b586a-0ce0-4add-b683-898338ed1501",
  "school_id": "11330ebb-0dfd-4df3-8a3e-7dc3cc9ed34f",
  "created_at": null,
  "updated_at": null,
  "stage": {
    "id": "66bc4e9f-4f23-474b-89de-adcd04a2e661",
    "name": "الصف الخامس",
    "fee": 1500000,
    "school_id": "11330ebb-0dfd-4df3-8a3e-7dc3cc9ed34f",
    "created_at": "2021-11-07T15:33:56.000000Z",
    "updated_at": "2021-11-07T15:33:56.000000Z"
  },
  "material": {
    "id": "4fdf405e-8acc-4253-8b99-d124f886bb66",
    "name": "رياضيات",
    "school_id": "11330ebb-0dfd-4df3-8a3e-7dc3cc9ed34f",
    "created_at": "2021-11-07T16:10:25.000000Z",
    "updated_at": "2021-11-07T16:10:25.000000Z"
  }
} 
*/

  String? id;
  String? materialId;
  String? classId;
  String? teacherId;
  String? schoolId;
  String? createdAt;
  String? updatedAt;
  StageModel? stage;
  MaterialModel? material;

  StageMaterialModel({
    this.id,
    this.materialId,
    this.classId,
    this.teacherId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.stage,
    this.material,
  });
  StageMaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    materialId = json['material_id']?.toString();
    classId = json['class_id']?.toString();
    teacherId = json['teacher_id']?.toString();
    schoolId = json['school_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    stage = (json['stage'] != null) ? StageModel.fromJson(json['stage']) : null;
    material = (json['material'] != null)
        ? MaterialModel.fromJson(json['material'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['material_id'] = materialId;
    data['class_id'] = classId;
    data['teacher_id'] = teacherId;
    data['school_id'] = schoolId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (stage != null) {
      data['stage'] = stage!.toJson();
    }
    if (material != null) {
      data['material'] = material!.toJson();
    }
    return data;
  }
}
