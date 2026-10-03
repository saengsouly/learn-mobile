import 'package:dio/dio.dart';

class Services {
  Services({String baseUrl = 'https://api.com'})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
        ),
      );

  final Dio dio;

  // method ກາງ ທີ່ທຸກ method ເອີ້ນໃຊ້
  Future<Response> _request(
    String method,
    String path, {
    String? token,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isForm = false, // true = form-urlencoded, false = JSON
  }) async {
    try {
      return await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          contentType: isForm
              ? Headers.formUrlEncodedContentType
              : Headers.jsonContentType,
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> get({
    required String path,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) => _request('GET', path, token: token, queryParameters: queryParameters);

  Future<Response> post({
    required String path,
    String? token,
    Map<String, dynamic>? data,
    bool isForm = false,
  }) => _request('POST', path, token: token, data: data, isForm: isForm);

  Future<Response> update({
    required String path,
    String? token,
    Map<String, dynamic>? data,
    bool isForm = false,
  }) => _request('PUT', path, token: token, data: data, isForm: isForm);

  Future<Response> delete({
    required String path,
    String? token,
    Map<String, dynamic>? data,
  }) => _request('DELETE', path, token: token, data: data);

  // ແປງ error ເປັນຂໍ້ຄວາມທີ່ເຂົ້າໃຈງ່າຍ
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('ການເຊື່ອມຕໍ່ໝົດເວລາ, ກະລຸນາລອງໃໝ່');
      case DioExceptionType.connectionError:
        return Exception('ບໍ່ມີອິນເຕີເນັດ ຫຼື ເຊື່ອມຕໍ່ server ບໍ່ໄດ້');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return Exception('ໝົດອາຍຸການເຂົ້າສູ່ລະບົບ');
        return Exception('Server ຜິດພາດ ($code)');
      default:
        return Exception('ເກີດຂໍ້ຜິດພາດ: ${e.message}');
    }
  }
}
