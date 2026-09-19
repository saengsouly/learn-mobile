import 'package:flutter/material.dart';
import 'package:learn_app/constants/app_color.dart';
import 'package:learn_app/widgets/my_text_style.dart';

import '../../models/products_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductsModel data;
  const ProductDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print('data === >${data.title}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'ລາຍລະອຽດຂອງສິນຄ້າ',
          style: myTextStyle(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      body: Column(children: [Image.network(data.thumbnail ?? "")]),
    );
  }
}
