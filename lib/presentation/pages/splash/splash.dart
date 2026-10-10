import 'package:flutter/material.dart';
import 'package:learn_app/core/constants/app_color.dart';
import 'package:learn_app/presentation/pages/dashboard/dashboard_page.dart';
import 'package:learn_app/presentation/providers/login/login_logic.dart';
import 'package:provider/provider.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      checkToken();
    });
  }

  Future<void> checkToken() async {
    final token = context.read<LoginLogic>().getToken();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => token == null ? loginPage() : DashboardPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash, size: 100, color: AppColors.whiteColor),
            Text(
              'ກຳລັງເຂົ້າສູ່ລະບົບ...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginPage() {}
}
