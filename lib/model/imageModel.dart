class ImageModel {
  String? id;
  String? image;
  String? reportId;
  String? schoolId;
  String? createdAt;
  String? updatedAt;

  ImageModel({
    this.id,
    this.image,
    this.reportId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });
  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    image = "http://3.74.16.10:8009" + "${json['image']?.toString()}";
    reportId = json['report_id']?.toString();
    schoolId = json['school_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['report_id'] = reportId;
    data['school_id'] = schoolId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
