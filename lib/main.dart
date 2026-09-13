import 'package:flutter/material.dart';
import 'package:learn_app/pages/dashboard/dashboard_page.dart';
import 'package:learn_app/pages/home/provider/home_logic.dart';
import 'package:learn_app/pages/login/login_page.dart';
import 'package:learn_app/pages/login/provider/login_logic.dart';
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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        // home: LoginPage(),
        home: DashboardPage(),
      ),
    );
  }
}
