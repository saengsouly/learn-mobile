import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_image.dart';
import 'package:learn_app/pages/dashboard/dashboard_page.dart';
import 'package:learn_app/pages/login/provider/login_logic.dart';
import 'package:learn_app/pages/register/register_page.dart';
import 'package:provider/provider.dart';

import '../../constants/app_color.dart';
import '../../widgets/my_text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool _isShowPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build UI');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(AppImage.logo, width: 130, height: 130),
                  ),
                  Center(
                    child: Text(
                      "ຍິນດີຕ້ອນຮັບ",
                      style: myTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "ຂ້ອຍກຳລັງຮຽນ Flutter",
                      style: myTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'ອີເມວ',
                    style: myTextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: AppColors.primaryColor,
                    decoration: InputDecoration(
                      hintText: 'ປ້ອນອີເມວ',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.textColor,
                          width: 0.5,
                        ),

                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ກະລຸນາປ້ອນອີເມວ';
                      }
                      if (!value.contains('@')) {
                        return 'ອີເມວບໍ່ຖືກຕ້ອງ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ລະຫັດຜ່ານ',
                    style: myTextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  Consumer<LoginLogic>(
                    builder: (context, loginState, child) {
                      final state = loginState.loginState;
                      print('1234 => ${state.signUpModel?.email}');
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: state.isShowpassword,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.primaryColor,
                        decoration: InputDecoration(
                          hintText: 'ປ້ອນລະຫັດຜ່ານ',
                          prefixIcon: Icon(Icons.lock_clock_sharp),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   isShowpassword = !(isShowpassword);
                              //   // if (_isShowPassword == true) {
                              //   //   _isShowPassword = false;
                              //   // } else {
                              //   //   _isShowPassword = true;
                              //   // }
                              //   print('Show password $isShowpassword');
                              // });
                              loginState.changePassword(
                                isShowPassword: state.isShowpassword
                                    ? false
                                    : true,
                              );
                            },
                            child: Icon(
                              // isShowpassword ? Icons.visibility : Icons.visibility_off,
                              state.isShowpassword == true
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.textColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນລະຫັດຜ່ານ';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text('ລືມລະຫັດຜ່ານ?', style: myTextStyle())],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        //   if (_emailController.text.isNotEmpty ||
                        //       _passwordController.text.isNotEmpty) {
                        //     print('ກະລຸນາປ້ອນຂໍ້ມູນ');
                        //   } else {
                        //     print('ມີຂໍ້ມູນເເລ້ວ');
                        //   }
                        if (_formKey.currentState!.validate()) {
                          print('ມີຂໍ້ມູນເເລ້ວ');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        "ເຂົ້າສູ່ລະບົບ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: AppColors.grayColor),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ຍັງບໍ່ມີບັນຊີ? ', style: myTextStyle()),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const RegisterPage(),
                          //   ),
                          // );
                        },
                        child: Text(
                          'ລົງທະບຽນ',
                          style: myTextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // TextButton.icon(onPressed: onPressed, label: label,icon: ,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
