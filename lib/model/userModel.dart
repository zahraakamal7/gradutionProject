import 'package:flight_booking_sys/model/schoolModel.dart';
import 'package:flight_booking_sys/model/stageMaterialModel.dart';
import 'package:flight_booking_sys/model/stageModel.dart';
import 'package:supercharged/supercharged.dart';

class UserModel {
  String? id;
  String? schoolId;
  String? fullName;
  String? userName;
  String? address;
  String? phoneNumber;
  int? gender;
  String? birthDay;
  String? discountValue;
  String? classId;
  String? parentJob;
  int? userType;
  bool? paid;
  int? salary;
  String? createdAt;
  String? updatedAt;
  SchoolModel? school;
  StageModel? studentStage;
  String? token;
  List<StageMaterialModel?>? materialsStages;

  UserModel({
    this.id,
    this.schoolId,
    this.fullName,
    this.userName,
    this.address,
    this.phoneNumber,
    this.gender,
    this.birthDay,
    this.discountValue,
    this.classId,
    this.parentJob,
    this.userType,
    this.paid,
    this.salary,
    this.createdAt,
    this.updatedAt,
    this.school,
    this.studentStage,
    this.token,
    this.materialsStages,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    schoolId = json['school_id']?.toString();
    fullName = json['full_name']?.toString();
    userName = json['user_name']?.toString();
    address = json['address']?.toString();
    phoneNumber = json['phone_number']?.toString();
    // gender = json['gender']?.toInt();
    birthDay = json['birth_day']?.toString();
    discountValue = json['discount_value']?.toString();
    classId = json['class_id']?.toString();
    parentJob = json['parent_job']?.toString();
    userType = json['user_type']?.toInt();
    paid = json['paid'];
    salary = (json['salary'] as String?)?.toInt();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    school =
        (json['school'] != null) ? SchoolModel.fromJson(json['school']) : null;
    studentStage =
        (json['stage'] != null) ? StageModel.fromJson(json['stage']) : null;
    if (json['materials_stages_teachers'] != null) {
      final v = json['materials_stages_teachers'];
      final arr0 = <StageMaterialModel>[];
      v.forEach((v) {
        arr0.add(StageMaterialModel.fromJson(v));
      });
      materialsStages = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['school_id'] = schoolId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['birth_day'] = birthDay;
    data['discount_value'] = discountValue;
    data['class_id'] = classId;
    data['parent_job'] = parentJob;
    data['user_type'] = userType;
    data['paid'] = paid;
    data['salary'] = salary;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (school != null) {
      data['school'] = school!.toJson();
    }
    if (studentStage != null) {
      data['stage'] = studentStage!.toJson();
    }
    if (materialsStages != null) {
      final v = materialsStages;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['materials_stages_teachers'] = arr0;
    }
    return data;
  }
}
