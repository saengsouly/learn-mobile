import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn_app/constants/data_demo.dart';
import 'package:learn_app/pages/home/provider/home_state.dart';

import '../../../models/products_model.dart';

class HomeLogic extends ChangeNotifier {
  HomeState _homeState = HomeState.initial();

  HomeState get homeState => _homeState;
  // ຮູບເເບບການໃຊ້ function
  // void ການຂຽນ funciton ທີ່ບໍ່ມີ async ຫລື ບໍ່ມີການ return ຄ່າຫຍັງ
  // Future<void> ການຂຽນ function ທີ່ມີການໃຊ້ async ຫລື ໃຊ້ໃນກໍລະນີທີ່ມີການໃຊ້ເວລາ ຕົວຢ່າງ:ດຶງຂໍ້ມູນຈກາ API

  Future<void> getListProduct() async {
    _homeState = homeState.copyWith(homeStatus: HomeStatus.loading);
    List<Map<String, dynamic>> list = products;
    try {
      // jsonEncode ເເມ່ນການເເປງຂໍ້ມູນໃຫ້ເປັນ String
      // jsonDecode ເເມ່ນການເເປງຂໍ້ມູນໃຫ້ເປັນ Map
      List<ProductsModel> product = productsModelFromJson(jsonEncode(list));
      _homeState = homeState.copyWith(
        productList: product,
        homeStatus: HomeStatus.success,
      );
      print('product list ${product.length}');
      notifyListeners();
    } catch (e) {
      print('error ==>$e');
      _homeState = homeState.copyWith(homeStatus: HomeStatus.error);
       notifyListeners();
    }
  }
}
