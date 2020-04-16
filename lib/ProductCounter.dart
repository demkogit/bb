import 'package:flutter/cupertino.dart';

import 'LocalDataBase/DBManager.dart';
import 'ProductItem.dart';

class ProductCounter extends ChangeNotifier {
  List<ProductItem> productList = [];
  int _userID = -1;
  String _userName = '';


  set setUserID(int val) => _userID = val;
  set setUserName(String val) => _userName = val;

  void increase(ProductItem product) {
    final DBManager dbManager = new DBManager();
    if (!productList.any((element) => element.id == product.id))
      productList.add(product);
    else
      product = productList.singleWhere((element) => element.id == product.id);
    //product.increase();
    notifyListeners();
  }

  void decrease(ProductItem product) {
    if (productList.any((element) => element.id == product.id)) {
      if (!productList.contains(product)) {
        //product.decrease();
        product =
            productList.singleWhere((element) => element.id == product.id);
      }
      //product.decrease();
      if (product.count == 0) {
        productList.removeWhere((element) => element.id == product.id);
      }
    }
    notifyListeners();
  }

  String count(ProductItem product) {
    if (productList.any((element) => element.id == product.id))
      return productList
          .singleWhere((element) => element.id == product.id)
          .count
          .toString();
    else
      return product.count.toString();
  }
}
