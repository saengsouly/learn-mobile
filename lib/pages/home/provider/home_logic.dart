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
    _homeState = homeState.copyWith(
      homeStatus: HomeStatus.loading,
      cartlist: [],
    );
    List<Map<String, dynamic>> list = products;
    try {
      // jsonEncode ເເມ່ນການເເປງຂໍ້ມູນໃຫ້ເປັນ String
      // jsonDecode ເເມ່ນການເເປງຂໍ້ມູນໃຫ້ເປັນ Map
      List<ProductsModel> product = productsModelFromJson(jsonEncode(list));
      _homeState = homeState.copyWith(
        productList: product,
        homeStatus: HomeStatus.success,
        cartlist: [],
      );
      print('product list ${product.length}');
      notifyListeners();
    } catch (e) {
      print('error ==>$e');
      _homeState = homeState.copyWith(
        homeStatus: HomeStatus.error,
        cartlist: [],
      );
      notifyListeners();
    }
  }

  void addToCart(int id) {
    ProductsModel item = _homeState.productList[id];
    // ສຳເນົາ List ເກົ່າອອກມາສ້າງເປັນ List ໃໝ່
    List<CartModel> newCopyCart = List<CartModel>.from(
      _homeState.cartList ?? [],
    );
    // [CartModel,]
    //ຫາຕຳເເໜ່ງ index ຂອງສິນຄ້າທີ່ມີຢູ່ໃນກະຕ່າ,ຖ້າບໍ່ເຫັນມັນຈະໄດ້ເປັນ -1
    int indexItem = newCopyCart.indexWhere((e) => e.product?.id == id);
    if (indexItem != -1) {
      // ຖ້າວ່າມີເເລ້ວ ເເມ່ນໃຫ້ບວກ 1 ເຂົ້າໄປ
      newCopyCart[indexItem].qty = newCopyCart[indexItem].qty + 1;
      print('qty ==${newCopyCart[indexItem].qty}');
    } else {
      // ຖ້າວ່າຍັງບໍ່ມີ ເເມ່ນໃຫ້ເພີ່ມເປັນລາຍການໃໝ່
      newCopyCart.add(CartModel(qty: 1, product: item));
    }
    List<CartModel> cart = _homeState.cartList ?? [];
    homeState.copyWith(cartlist: cart, cartList: []);
    notifyListeners();
  }

  // ເພີ່ມເຂົ້າກະຕ່າ
  // ລົບຈຳນວນອອກຈາກກະຕ່າ
  // ລົບຈຳນວນອອກຈາກກະຕ່າ
  void removeCart(int index) {
    ProductsModel item = _homeState.productList[index];
    // ສຳເນົາ List ເກົ່າອອກມາສ້າງເປັນ List ໃໝ່
    List<CartModel> newCopyCart = List<CartModel>.from(
      _homeState.cartList ?? [],
    );
    //ຫາຕຳເເໜ່ງ index ຂອງສິນຄ້າທີ່ມີຢູ່ໃນກະຕ່າ,ຖ້າບໍ່ເຫັນມັນຈະໄດ້ເປັນ -1
    int indexItem = newCopyCart.indexWhere((e) => e.product?.id == item.id);

    if (indexItem == -1)
      return; // ຖ້າວ່າຫາຕຳເເໜ່ງໃນ list ບໍ່ພົບເຫັນບອກໃຫ້ program ຢຸດເຮັດວຽກທັນທີ
    if (newCopyCart[indexItem].qty > 1) {
      // ກວດສອບວ່າ ຖ້າຈຳນວນໃນ index ນັ້ນໃຫ່ຍກວ່າ 1 ເເມ່ນໃຫ້ລົບ
      newCopyCart[indexItem].qty = newCopyCart[indexItem].qty - 1;
    } else {
      // ຖ້າຈຳນວນນ້ອຍກວ່າ 1 ເເມ່ນໃຫ້ລົບອອກຈາກ list ເລີຍ
      newCopyCart.removeAt(indexItem);
    }
    // ເອົາຂໍ້ມູນກ້ອນໃໝ່ໄປເເທນຂໍ້ມູນເກົ່າທີ່ມີຢູ່ໃນ cartList ນັ້ນ
    _homeState = homeState.copyWith(cartlist: newCopyCart);
    notifyListeners();
  }
}
