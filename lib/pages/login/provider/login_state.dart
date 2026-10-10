import 'package:learn_app/models/signup_model.dart';

import '../../../models/login_model.dart';
import '../../../models/user_model.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState {
  LoginStatus loginStatus;
  LoginStatus userStatus;
  bool isShowpassword;
  SignUpModel? signUpModel;
  LoginModel? loginModel;
  UserModel? userModel;


  LoginState({
    this.loginStatus = LoginStatus.initial,
    this.userStatus = LoginStatus.initial,
    this.isShowpassword = false,
    this.signUpModel,
    this.loginModel,
    this.userModel,
  });

  factory LoginState.initial() => LoginState(
    loginStatus: LoginStatus.initial,
    isShowpassword: false,
    userStatus: LoginStatus.initial,
  );

  LoginState copyWith({
    LoginStatus? loginStatus,
    LoginStatus? userStatus,
    bool? isShowpassword,
    SignUpModel? signUpModel,
    LoginModel? loginModel,
    UserModel? userModel,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      userStatus: userStatus ?? this.userStatus,
      isShowpassword: isShowpassword ?? this.isShowpassword,
      signUpModel: signUpModel ?? this.signUpModel,
      loginModel: loginModel ?? this.loginModel,
      userModel: userModel ?? this.userModel,
    );
  }
}
