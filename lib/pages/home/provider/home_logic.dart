import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn_app/constants/data_demo.dart';
import 'package:learn_app/models/cart_model.dart';
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

  // ເພີ່ມເຂົ້າກະຕ່າ
  void addToCart(int index) {
    ProductsModel item = _homeState.productList[index];
    if (_homeState.cartList?.isNotEmpty ?? false) {
      for (var i = 0; i < (_homeState.cartList ?? []).length; i++) {
        // ກວດວ່າ id ເທົ່າກນບໍ
        if (item.id == _homeState.cartList?[i].product?.id) {
          // print('qty ===>${_homeState.cartList?[i].qty}');
          int newQty = (_homeState.cartList?[i].qty ?? 0) + 1;
          print('new qty ==>$newQty');
          // cartList = [ProductModel,ProductModel,ProductModel];
          // [1,2,3,4,5]
           _homeState = _homeState.copyWith(cartList: _homeState.cartList);
        } else {
          // ເພີ່ມໃໝ່ເຂົ້າກະຕ່າ ຊື່ cartList.
          List<CartModel> cart = _homeState.cartList ?? [];
          cart.add(CartModel(qty: 1, product: item));
          _homeState = homeState.copyWith(cartList: cart);
          notifyListeners();
        }
      }
    } else {
      // ເພີ່ມເຂົ້າໃໝ່ຄັ້ງທຳອິດທີ່ຍັງບໍ່ທັນມີ data
      List<CartModel> cart = _homeState.cartList ?? [];
      cart.add(CartModel(qty: 1, product: item));
      _homeState = homeState.copyWith(cartList: cart);
      notifyListeners();
    }
  }
}
