import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/pages/dashboard/dashboard_page.dart';
import 'package:learn_app/pages/login/login_page.dart';
import 'package:learn_app/pages/login/provider/login_logic.dart';
import 'package:learn_app/widgets/my_text_style.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      checkToken();
    });
  }

  // ດຶງ token ອອກມາກວດສອບ
  Future<void> checkToken() async {
    final String? token = await context.read<LoginLogic>().getToken();
    if (token != null) {
     await context.read<LoginLogic>().getUser();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => token == null ? LoginPage() : DashboardPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flutter_dash, size: 40, color: AppColors.whiteColor),
            SizedBox(height: 10),
            Text(
              'ຍິນດີຕ້ອນຮັບເຂົ້າສູ່ລະບົບ',
              style: myTextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
