import 'package:flutter/material.dart';
import 'package:learn_app/core/theme/app_theme.dart';
import 'package:learn_app/presentation/pages/splash/splash.dart';
import 'package:learn_app/presentation/providers/home/home_logic.dart';
import 'package:learn_app/presentation/providers/login/login_logic.dart';
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
        theme: AppTheme.light,
        home: const Splashpage(),
      ),
    );
  }
}
