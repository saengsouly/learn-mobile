import 'package:learn_app/models/products_model.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  HomeStatus homeStatus;
  List<ProductsModel> productList;

  HomeState({
    this.homeStatus = HomeStatus.initial,
    this.productList = const [],
  });

  factory HomeState.initial() => HomeState(homeStatus: HomeStatus.initial);

  HomeState copyWith({
    HomeStatus? homeStatus,
    List<ProductsModel>? productList,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      productList: productList ?? this.productList,
    );
  }
}
