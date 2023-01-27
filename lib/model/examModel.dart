class ExamModel {
  String? id;
  String? day;
  String? materialId;
  String? classId;
  int? lessonNumber;
  DateTime? date;
  String? schoolId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  ExamModel({
    this.id,
    this.day,
    this.materialId,
    this.classId,
    this.lessonNumber,
    this.date,
    this.schoolId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });
  ExamModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    day = json['day']?.toString();
    materialId = json['material_id']?.toString();
    classId = json['class_id']?.toString();
    lessonNumber = json['lesson_number']?.toInt();
    date = json['date'] == null ? null : DateTime.parse(json['date']);
    schoolId = json['school_id']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['day'] = day;
    data['material_id'] = materialId;
    data['class_id'] = classId;
    data['lesson_number'] = lessonNumber;
    data['date'] = date;
    data['school_id'] = schoolId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
