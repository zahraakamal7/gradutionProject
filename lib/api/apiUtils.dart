import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../model/errorModel.dart';
import '../model/responseModel.dart';

String url = "http://3.74.16.10:8000"; //TODO:: add api url
final apiUrl = "$url/api";
Dio get dio {
  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  if (storage.hasData("token"))
    headers["authorization"] = "Bearer ${storage.read("token")}";
  final baseOptions = BaseOptions(
      sendTimeout: 10000,
      receiveDataWhenStatusError: true,
      receiveTimeout: 10000,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      baseUrl: apiUrl,
      headers: headers);
  return Dio(baseOptions);
}

final storage = GetStorage();

Future<ResponseModel> dioGet(String endPoint, dynamic data,
    {String? type, CancelToken? cancelToken}) async {
  if (data is Map) {
    Map<String, dynamic> newdata = new Map();
    data.forEach((key, value) {
      if (value != null) newdata[key] = value;
    });
    data = newdata;
  }

  try {
    var response = await dio.get(
      "$apiUrl/$endPoint",
      cancelToken: cancelToken,
      queryParameters: data,
    );

    return response.data is String
        ? ResponseModel(error: ErrorModel(code: 600))
        : response.data is List
            ? response.data
            : ResponseModel.fromJson(response.data, type: type);
  } on DioError catch (e) {
    return ResponseModel(
        error: ErrorModel(code: 600, errors: ["${e.message}"]));
  } on Exception catch (er) {
    return ResponseModel(error: ErrorModel(code: 600, errors: ["$er"]));
  }
}

Future<dynamic> dioPost(String endPoint, dynamic data, {String? type}) async {
  if (data is Map) {
    Map newdata = new Map();
    data.forEach((key, value) {
      if (value != null) newdata[key] = value;
    });
    data = newdata;
  }

  // if (!(data is FormData)) headers['Content-Type'] = 'application/json';
  try {
    var response = await dio.post(
      "$apiUrl/$endPoint",
      data: data,
    );

    return response.data is String
        ? ResponseModel(error: ErrorModel(code: 600))
        : response.data is List
            ? response.data
            : ResponseModel.fromJson(response.data, type: type);
  } on DioError catch (e) {
    return ResponseModel(
        error: ErrorModel(code: 600, errors: ["${e.message}"]));
  } on Exception catch (er) {
    return ResponseModel(error: ErrorModel(code: 600, errors: ["$er"]));
  }
}

Future<dynamic> dioPut(String endPoint, dynamic data, {String? type}) async {
  if (data is Map) {
    Map newdata = new Map();
    data.forEach((key, value) {
      newdata[key] = value;
    });
    data = newdata;
  }

  try {
    var response = await dio.put(
      "$apiUrl/$endPoint",
      data: data,
    );

    return response.data is String
        ? ResponseModel(error: ErrorModel(code: 600))
        : response.data is List
            ? response.data
            : ResponseModel.fromJson(response.data, type: type);
  } on DioError catch (e) {
    return ResponseModel(
        error: ErrorModel(code: 600, errors: ["${e.message}"]));
  } on Exception catch (er) {
    return ResponseModel(error: ErrorModel(code: 600, errors: ["$er"]));
  }
}

Future<ResponseModel> dioDelete(String endPoint, dynamic data,
    {String? type}) async {
  if (data is Map) {
    Map newdata = new Map();
    data.forEach((key, value) {
      if (value != null) newdata[key] = value;
    });
    data = newdata;
  }

  try {
    var response = await dio.delete(
      "$apiUrl/$endPoint",
      data: data,
    );

    return ResponseModel.fromJson(response.data, type: type);
  } on DioError catch (e) {
    return ResponseModel(
        error: ErrorModel(code: 600, errors: ["${e.message}"]));
  } on Exception catch (er) {
    return ResponseModel(error: ErrorModel(code: 600, errors: ["$er"]));
  }
}
