import 'package:learn_app/models/products_model.dart';

import '../../../models/cart_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  HomeStatus homeStatus;
  List<ProductsModel> productList;
  List<CartModel>? cartList; // [CartModel,CartModel]
  int selectQty;

  HomeState({
    this.homeStatus = HomeStatus.initial,
    this.productList = const [],
    this.cartList,
    this.selectQty = 0,
  });

  factory HomeState.initial() => HomeState(homeStatus: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? homeStatus,
    List<ProductsModel>? productList,
    List<CartModel>? cartList,
    int? selectQty,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      productList: productList ?? this.productList,
      cartList: cartList ?? this.cartList,
      selectQty: selectQty ?? this.selectQty,
    );
  }
}
