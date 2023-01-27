import 'package:supercharged/supercharged.dart';

class CurrencyModel {
  String? id;
  String? nameEn;
  String? nameAr;
  double? dollar;
  DateTime? createdAt;
  DateTime? updatedAt;

  CurrencyModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.dollar,
    this.createdAt,
    this.updatedAt,
  });
  CurrencyModel.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    nameEn = json["name_en"]?.toString();
    nameAr = json["name_ar"]?.toString();
    dollar = json["dollar"]?.toString().toDouble();
    createdAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name_en"] = nameEn;
    data["name_ar"] = nameAr;
    data["dollar"] = dollar;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
