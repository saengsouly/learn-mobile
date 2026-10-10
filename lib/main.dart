import 'package:flutter/material.dart';

import 'package:learn_app/core/theme/app_theme.dart';
import 'package:learn_app/presentation/pages/splash/splash.dart';
import 'package:learn_app/presentation/providers/home/home_logic.dart';
import 'package:learn_app/presentation/providers/login/login_logic.dart';
=======
import 'package:learn_app/pages/dashboard/dashboard_page.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:learn_app/pages/login/login_page.dart';
import 'package:learn_app/pages/login/provider/login_logic.dart';
import 'package:learn_app/pages/splash/splash_page.dart';
>>>>>>> upstream/main
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeLogic()),
        ChangeNotifierProvider(create: (context) => LoginLogic()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learn App',
<<<<<<< HEAD
        theme: AppTheme.light,
        home: const Splashpage(),
=======
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashPage(),
        // home: DashboardPage(),
>>>>>>> upstream/main
      ),
    );
  }
}
