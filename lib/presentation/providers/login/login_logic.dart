import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_app/data/models/login_model.dart';
import 'package:learn_app/data/models/signup_model.dart';
import 'package:learn_app/data/models/user_model.dart';
import 'package:learn_app/presentation/pages/dashboard/dashboard_page.dart';
import 'package:learn_app/presentation/providers/login/login_state.dart';
import 'package:learn_app/data/repositories/authen_repository.dart';
import 'package:learn_app/core/network/services.dart';
import 'package:learn_app/core/storage/secure_storage.dart';
import 'package:learn_app/shared/widgets/alert_loading.dart';

class LoginLogic extends ChangeNotifier {
  LoginState _loginState = LoginState.initial();

  LoginState get loginState => _loginState;

  AuthenRepository authenRepository = AuthenRepository(services: Services());
  SecureStorage secureStorage = SecureStorage();
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

  Future<void> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
    alertLoading(context, message: 'ກຳລັງເຂົ້າສູ່ລະບົບ...');
    try {
      final resulf = await authenRepository.login(
        username: username,
        password: password,
      );
      if (resulf != null && resulf.success == true) {
        final loginData = loginModelFromJson(jsonEncode(resulf.data));
        _loginState = loginState.copyWith(
          loginStatus: LoginStatus.success,
          loginModel: loginData,
        );
        await secureStorage.saveToken(loginData.accessToken ?? "");
        await getUser(Token: loginData.accessToken ?? "");
        Navigator.pop(context); // Close the loading dialog
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false,
        );
      } else {
        _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
        Navigator.pop(context);
      }
      notifyListeners();
    } catch (e) {
      _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> getUser({required String Token}) async {
    _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
    try {
      final resulf = await authenRepository.getuser(Token: Token);
      if (resulf.success == true) {
        final userData = userModelFromJson(jsonEncode(resulf.data));
        print('User data: $userData');
        _loginState = loginState.copyWith(
          loginStatus: LoginStatus.success,
          userModel: userData,
        );
      } else {
        _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
        print('Error in getUser: ${resulf.message}');
      }
      notifyListeners();
    } catch (e) {
      _loginState = loginState.copyWith(loginStatus: LoginStatus.error);
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    return await secureStorage.getToken();
  }

  Future<void> deleteToken() async {
    await secureStorage.deleteToken();
  }
}
