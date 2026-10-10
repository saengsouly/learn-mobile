import 'package:flutter/material.dart';
import 'package:learn_app/presentation/providers/login/login_logic.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  get token => null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          context.read<LoginLogic>().deleteToken();
          if (token != null) {
            await context.read<LoginLogic>().getUser(Token: '');
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => loginPage()),
            (route) => false,
          );
        },
        child: Text('ອອກລະແມ້'),
      ),
    );
  }

  loginPage() {}
}
