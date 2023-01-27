import 'package:flight_booking_sys/api/apiUtils.dart';

class Flightline {
  Flightline({
    required this.id,
    required this.name,
    required this.image,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String name;
  late final String image;
  late final int active;
  DateTime? createdAt;
  DateTime? updatedAt;

  Flightline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = url + json['image'];
    active = json['active'];
    createdAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['active'] = active;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
