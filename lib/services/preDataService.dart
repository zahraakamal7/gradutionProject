import 'package:dartz/dartz.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/materialModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flight_booking_sys/model/semesterModel.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class PreDataService extends GetxService {
  RxBool isFetching = false.obs;
  RxList<MaterialModel> materials = RxList();
  RxList<SemesterModel> semesters = RxList();
  static PreDataService get servicesController => Get.find<PreDataService>();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  Future<PreDataService> init() async {
    isFetching.value = true;
    fetchApis();
    return this;
  }

  Future fetchMaterials() async {
    Either<ErrorModel?, ResponseModel?> res;
    materials.clear();
    res = await getMaterialsApi(skip: 0, limit: 20);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      materials.addAll(r!.materials!);
    });
    isFetching.value = false;
  }

  Future fetchSemesters() async {
    Either<ErrorModel?, ResponseModel?> res;
    semesters.clear();
    res = await getSemestersApi(skip: 0, limit: 20);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      semesters.addAll(r!.semesters!);
    });
    isFetching.value = false;
  }

  void fetchApis() {
    fetchMaterials();
    fetchSemesters();
  }
}
