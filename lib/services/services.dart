import 'package:dio/dio.dart';

class Services {
  Dio dio = Dio();

  // method GET
  Future<Response> get({required String path, String? token}) async {
    //url ====  https://api.com/login
    try {
      Response result = await dio.get(
        path, // ບ່ອນໃສ່ API
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: token == null
              ? null
              : {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                },
        ),
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // method POST
  Future<Response> post({
    required String path,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    //url ====  https://api.com/login
    try {
      Response result = await dio.post(
        path, // ບ່ອນໃສ່ API
        data: data,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: token == null
              ? null
              : {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                },
        ),
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // method UPDATE
  Future<Response> update({
    required String path,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    //url ====  https://api.com/login
    try {
      Response result = await dio.put(
        path, // ບ່ອນໃສ່ API
        data: data,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: token == null
              ? null
              : {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                },
        ),
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Mehtod Delete
  Future<Response> delete({
    required String path,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    //url ====  https://api.com/login
    try {
      Response result = await dio.delete(
        path, // ບ່ອນໃສ່ API
        data: data,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: token == null
              ? null
              : {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                },
        ),
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
