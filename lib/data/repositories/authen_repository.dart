import 'package:learn_app/core/constants/path_api.dart';
import 'package:learn_app/data/models/response_api.dart';
import 'package:learn_app/core/network/services.dart';

class AuthenRepository {
  final Services services;
  AuthenRepository({required this.services});

  // ການເຂົ້າລະບົບ
  Future<ResponseApi?> login({
    required String username,
    required String password,
  }) async {
    Map<String, dynamic> data = {'username': username, 'password': password};
    try {
      final response = await services.post(path: PathApi.login, data: data);
      print('path: ${PathApi.login}');
      print('Response  ${response.data}');
      return ResponseApi(message: "ເຂົ້າສູ່ລະບົບສຳເລັດ", data: response.data);
    } catch (e) {
      print('Error in login: $e.toString()');
      return ResponseApi(message: e.toString(), success: false, data: null);
    }
  }

  Future<ResponseApi> getuser({required String Token}) async {
    try {
      final response = await services.get(path: PathApi.users);
      print('path: ${PathApi.users}');
      print('Response  ${response.data}');
      return ResponseApi(message: "ດຶງຂໍ້ມູນຜູ້ໃຊ້ສຳເລັດ", data: response.data);
    } catch (e) {
      print('Error in Getuser: $e.toString()');
      return ResponseApi(message: e.toString(), success: false, data: null);
    }
  }
}
