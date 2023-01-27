import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import '../model/errorModel.dart';
import '../model/responseModel.dart';
import 'apiUtils.dart';

Future<Either<ErrorModel?, ResponseModel?>> loginUserApi(
    String userName, String password) async {
  ResponseModel response = await dioPost(
    "login",
    {
      "user_name": userName,
      'password': password,
      'token': GetStorage().read("fireToken")
    },
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> registerGuestApi(
    String? firebaseToken) async {
  ResponseModel response = await dioPost(
    "register_guest",
    {
      'token': firebaseToken,
    },
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> registerUserApi(
    {required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String birthDate}) async {
  ResponseModel response = await dioPost(
    "register",
    {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_name': userName,
      'password': password,
      'phone_number': phoneNumber,
      'birth_day': birthDate
    },
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> getUserApi() async {
  ResponseModel response = await dioGet(
    "auth_info",
    {},
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

// get flightline offer
Future<Either<ErrorModel?, ResponseModel?>> getFlightOfferApi(
    {int skip: 0, int limit: 10}) async {
  ResponseModel response = await dioGet(
    "get_offers",
    {"skip": skip, "limit": limit},
    type: "offer",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

// get currency offer
Future<Either<ErrorModel?, ResponseModel?>> getCurrencyTodayApi(
    {int skip: 0, int limit: 10}) async {
  ResponseModel response = await dioGet(
    "get_coins",
    {"skip": skip, "limit": limit},
    type: "currency",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_reports
Future<Either<ErrorModel?, ResponseModel?>> getReportsApi(
    {int skip: 0, int limit: 10, Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_reports",
    {"skip": skip, "limit": limit, ...data},
    type: "reports",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> addReportsApi(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioPost(
    "add_report",
    {...data},
    type: "reports",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_materials
Future<Either<ErrorModel?, ResponseModel?>> getMaterialsApi(
    {int skip: 0, int limit: 10, Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_materials",
    {"skip": skip, "limit": limit, ...data},
    type: "materials",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_daily_materials
Future<Either<ErrorModel?, ResponseModel?>> getDailyMaterialsApi(
    {Map? data}) async {
  ResponseModel response = await dioGet(
    "get_daily_materials",
    data,
    type: "daily_materials",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_exams
Future<Either<ErrorModel?, ResponseModel?>> getExaminationTable(
    {Map? data}) async {
  ResponseModel response = await dioGet(
    "get_exams",
    data,
    type: "exams",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_semesters
Future<Either<ErrorModel?, ResponseModel?>> getSemestersApi(
    {int skip: 0, int limit: 10, Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_semesters",
    {"skip": skip, "limit": limit, ...data},
    type: "semesters",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_degree
Future<Either<ErrorModel?, ResponseModel?>> getCertificateApi(
    {int skip: 0, int limit: 10, Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_degrees",
    {"skip": skip, "limit": limit, ...data},
    type: "degrees",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

//get_degree
Future<Either<ErrorModel?, ResponseModel?>> getUsersApi(
    {int skip: 0, int limit: 50, Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_users",
    {"skip": skip, "limit": limit, ...data},
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> editReportApi(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioPut(
    "edit_report",
    {...data},
    type: "editReport",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> getCommentToReportApi(
    {int skip: 0, int limit: 50, Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_comments",
    {"skip": skip, "limit": limit, ...data},
    type: "comment",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> addCommentApi(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioPost(
    "add_comment",
    {...data},
    type: "comment",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> deleteCommentApi(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioDelete(
    "delete_comment",
    {...data},
    type: "comment",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> getNotificationsApi(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioGet(
    "get_notification",
    {...data},
    type: "notification",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> deleteReportApi(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioDelete(
    "delete_report",
    {...data},
    type: "report",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> markSeenNotification(
    {Map<String, dynamic> data: const {}}) async {
  ResponseModel response = await dioPut(
    "seen",
    {...data},
    type: "notification",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> logoutUserApi() async {
  ResponseModel response = await dioPost(
    "logout",
    {},
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> replaceTokenApi(
    String oldToken, String newToken) async {
  ResponseModel response = await dioPost(
    "replace_token_firebase",
    {"old_token": oldToken, "new_token": newToken},
    type: "user",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}

Future<Either<ErrorModel?, ResponseModel?>> postFeedApi(String text) async {
  ResponseModel response = await dioPost(
    "add_feedback",
    {"text": text},
    type: "unknown",
  );
  if (!(response.error!.code! > 299)) {
    return right(response);
  } else {
    return left(response.error);
  }
}
