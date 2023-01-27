import 'airport.dart';
import 'flightLine.dart';

class FlightOffer {
  FlightOffer({
    required this.id,
    required this.flightlineId,
    required this.details,
    required this.offerCode,
    required this.offerValue,
    required this.offerStatus,
    required this.offerType,
    required this.active,
    required this.maxPassengers,
    required this.minPassengers,
    required this.expairDate,
    required this.timeToGo,
    required this.returnTime,
    required this.from,
    required this.to,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.flightline,
  });
  late final String id;
  late final String flightlineId;
  late final String details;
  late final String offerCode;
  late final String offerValue;
  late final int offerStatus;
  late final int offerType;
  late final int active;
  late final int maxPassengers;
  late final int minPassengers;
  DateTime? expairDate;
  DateTime? timeToGo;
  DateTime? returnTime;
  late final Airport from;
  late final Airport to;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  late final Flightline flightline;

  FlightOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flightlineId = json['flightline_id'];
    details = json['details'];
    offerCode = json['offer_code'];
    offerValue = json['offer_value'];
    offerStatus = json['offer_status'];
    offerType = json['offer_type'];
    active = json['active'];
    maxPassengers = json['max_passengers'];
    minPassengers = json['min_passengers'];
    expairDate = json['expair_date'] == null
        ? null
        : DateTime.parse(json['expair_date']);
    timeToGo =
        json['time_to_go'] == null ? null : DateTime.parse(json['time_to_go']);
    returnTime = json['return_time'] == null
        ? null
        : DateTime.parse(json['return_time']);

    from = Airport.fromJson(json['from']);
    to = Airport.fromJson(json['to']);
    deletedAt =
        json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at']);
    createdAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
    flightline = Flightline.fromJson(json['flightline']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['flightline_id'] = flightlineId;
    _data['details'] = details;
    _data['offer_code'] = offerCode;
    _data['offer_value'] = offerValue;
    _data['offer_status'] = offerStatus;
    _data['offer_type'] = offerType;
    _data['active'] = active;
    _data['max_passengers'] = maxPassengers;
    _data['min_passengers'] = minPassengers;
    _data['expair_date'] = expairDate;
    _data['time_to_go'] = timeToGo;
    _data['return_time'] = returnTime;
    _data['from'] = from.toJson();
    _data['to'] = to.toJson();
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['flightline'] = flightline.toJson();
    return _data;
  }
}
