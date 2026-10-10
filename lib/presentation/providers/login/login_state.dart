import 'package:learn_app/data/models/login_model.dart';
import 'package:learn_app/data/models/signup_model.dart';
import 'package:learn_app/data/models/user_model.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState {
  LoginStatus loginStatus;
  bool isShowpassword;
  SignUpModel? signUpModel;
  LoginModel? loginModel;
  UserModel? userModel;

  var userStatus = LoginStatus.initial;

  LoginState({
    this.loginStatus = LoginStatus.initial,
    this.isShowpassword = false,
    this.signUpModel,
    this.loginModel,
    this.userModel,
    required this.userStatus,
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
