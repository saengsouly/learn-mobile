import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/pages/category/category_page.dart';
import 'package:learn_app/pages/home/home_page.dart';
import 'package:learn_app/pages/order/order_page.dart';
import 'package:learn_app/pages/profile/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectIndex = 0;
  List<Widget> _widget = [];

  @override
  void initState() {
    _widget = [
      HomePage(),
      CategoryPage(),
      OrderPage(),
      ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widget[selectIndex],
      // body:  selectIndex == 0 ? HomePage(): selectIndex,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textColor,
        unselectedLabelStyle: TextStyle(color: AppColors.textColor),
        selectedLabelStyle: TextStyle(color: AppColors.primaryColor),
        onTap: (index) {
          // index == 1
          setState(() {
            selectIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "ໜ້າຫຼັກ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: "ປະເພດ",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "ອໍເດີ",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "ໂປຣໄພ"),
        ],
      ),
    );
  }
}
