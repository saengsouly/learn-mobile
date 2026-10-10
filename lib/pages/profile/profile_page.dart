import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/login_page.dart';
import '../login/provider/login_logic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.read<LoginLogic>().clearToken();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        },
        child: Text('ອອກຈາກລະບົບ'),
      ),
    );
  }
}
