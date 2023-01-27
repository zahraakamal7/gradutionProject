class Airport {
  Airport({
    required this.id,
    required this.code,
    required this.geo,
    required this.nameAr,
    required this.nameEn,
    required this.cityName,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String code;
  late final String geo;
  late final String nameAr;
  late final String nameEn;
  late final String cityName;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Airport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    geo = json['geo'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    cityName = json['city_name'];
    deletedAt =
        json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at']);
    createdAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['code'] = code;
    _data['geo'] = geo;
    _data['name_ar'] = nameAr;
    _data['name_en'] = nameEn;
    _data['city_name'] = cityName;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
