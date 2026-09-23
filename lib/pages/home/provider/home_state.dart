import 'package:learn_app/models/cart_model.dart';
import 'package:learn_app/models/products_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  HomeStatus homeStatus;
  List<ProductsModel> productList;
  List<CartModel>? cartList;
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
    required List<CartModel> cartlist,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      productList: productList ?? this.productList,
      cartList: cartList ?? this.cartList,
    );
  }
}
