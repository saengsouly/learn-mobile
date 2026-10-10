import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_app/models/login_model.dart';
import 'package:learn_app/models/signup_model.dart';
import 'package:learn_app/models/user_model.dart';
import 'package:learn_app/pages/login/provider/login_state.dart';
import 'package:learn_app/repository/authen_repository.dart';
import 'package:learn_app/services/services.dart';
import 'package:learn_app/utils/secure_storage.dart';
import 'package:learn_app/widgets/alert_loading.dart';

import '../../dashboard/dashboard_page.dart';

class LoginLogic extends ChangeNotifier {
  LoginState _loginState = LoginState.initial();

  AuthenRepository authenRepo = AuthenRepository(services: Services());
  SecureStorage secureStorage = SecureStorage();

  LoginState get loginState => _loginState;

  void changePassword({required bool isShowPassword}) {
    _loginState = loginState.copyWith(isShowpassword: isShowPassword);
    notifyListeners();
  }

  void addUser({
    required int id,
    required String fullName,
    required String email,
    required String password,
  }) {
    SignUpModel data = SignUpModel(
      email: email,
      password: password,
      fullName: fullName,
      id: id,
    );
    _loginState = loginState.copyWith(signUpModel: data);
  }

  // ເຂົ້າສູ່ລະບົບ API
  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    _loginState = loginState.copyWith(loginStatus: LoginStatus.loading);
    alertLoading(context, message: 'ກຳລັງເຂົ້າສູ່ລະບົບ...');
    try {
      final result = await authenRepo.login(
        username: username,
        password: password,
      );
      if (result.success == true) {
        final loginData = loginModelFromJson(jsonEncode(result.data));
        _loginState = loginState.copyWith(
          loginStatus: LoginStatus.success,
          loginModel: loginData,
        );
        await secureStorage.saveToken(loginData.accessToken ?? "");
        await getUser();
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false,
        );
      } else {
        // ຖ້າບໍ່ສຳເລັດ
        _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
        Navigator.pop(context);
      }
      notifyListeners();
    } catch (e) {
      print("error logic : ${e.toString()}");
      // ຖ້າບໍ່ສຳເລັດ
      _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
      Navigator.pop(context);
      notifyListeners();
    }
  }

  // ດຶງຂໍ້ມູນຜູ້ໃຊ້
  Future<void> getUser() async {
    _loginState = loginState.copyWith(userStatus: LoginStatus.loading);
    try {
      final String? token = await getToken();
      if (token != null) {
        final result = await authenRepo.getUser(token: token);
        if (result.success == true) {
          final user = userModelFromJson(jsonEncode(result.data));
          print('map data to model ==$user');
          _loginState = loginState.copyWith(
            userModel: user,
            loginStatus: LoginStatus.success,
          );
        } else {
          _loginState = loginState.copyWith(userStatus: LoginStatus.error);
        }
      }
      notifyListeners();
    } catch (e) {
      _loginState = loginState.copyWith(userStatus: LoginStatus.error);
      notifyListeners();
    }
  }

  // ດຶງ token ມາຈາກ local storage ເພື່ອກວດສອບ
  Future<String?> getToken() async {
    return await secureStorage.readToken();
  }

  // clear token
  Future<void> clearToken() async {
    await secureStorage.clearToken();
  }
}
