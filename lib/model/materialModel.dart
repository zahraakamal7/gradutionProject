class MaterialModel {
/*
{
  "id": "4fdf405e-8acc-4253-8b99-d124f886bb66",
  "name": "رياضيات",
  "school_id": "11330ebb-0dfd-4df3-8a3e-7dc3cc9ed34f",
  "created_at": "2021-11-07T16:10:25.000000Z",
  "updated_at": "2021-11-07T16:10:25.000000Z"
} 
*/

  String? id;
  String? name;
  String? schoolId;
  String? createdAt;
  String? updatedAt;

  MaterialModel({
    this.id,
    this.name,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });
  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    schoolId = json['school_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['school_id'] = schoolId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
