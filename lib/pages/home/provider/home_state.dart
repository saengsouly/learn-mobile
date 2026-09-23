import 'package:learn_app/models/cart_model.dart';
import 'package:learn_app/models/products_model.dart';

import '../../../models/cart_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  HomeStatus homeStatus;
  List<ProductsModel> productList;
<<<<<<< HEAD
  List<CartModel>? cartList;
=======
  List<CartModel>? cartList; // [CartModel,CartModel]

>>>>>>> upstream/main
  HomeState({
    this.homeStatus = HomeStatus.initial,
    this.productList = const [],
    this.cartList,
  });

  factory HomeState.initial() => HomeState(homeStatus: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? homeStatus,
    List<ProductsModel>? productList,
    List<CartModel>? cartList,
<<<<<<< HEAD
    required List<CartModel> cartlist,
=======
>>>>>>> upstream/main
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      productList: productList ?? this.productList,
      cartList: cartList ?? this.cartList,
    );
  }
}
