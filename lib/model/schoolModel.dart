class SchoolModel {
  String? id;
  String? name;
  String? address;
  int? studentNumber;
  String? createdAt;
  String? updatedAt;

  SchoolModel({
    this.id,
    this.name,
    this.address,
    this.studentNumber,
    this.createdAt,
    this.updatedAt,
  });
  SchoolModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    address = json['address']?.toString();
    studentNumber = json['student_number']?.toInt();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['student_number'] = studentNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
