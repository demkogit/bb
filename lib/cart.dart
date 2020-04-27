import 'ProductItem.dart';

class Cart {
  List<ProductItem> _products;
  Cart() {
    _products = new List();
  }

  List<ProductItem> get productList => _products;

  void add(ProductItem product) {
    //_products.firstWhere((e) => e.count >1, orElse: () => 0);
    if (!_products.any((element) => element.id == product.id))
      _products.add(product);
    else
      product = _products.singleWhere((element) => element.id == product.id);

    product.increaseCount();

    print(product.name + " : " + product.count.toString());
  }

  void changeCount(ProductItem product) {
    print('${product.count}');
    if (product.count != 0 &&
        !_products.any((element) => element.id == product.id))
      _products.add(product);
    else {
      var tempProduct =
          _products.singleWhere((element) => element.id == product.id);
      if (product.count == 0)
        _products.remove(tempProduct);
      else
        tempProduct.count = product.count;
    }
  }

  void remove(ProductItem product) {
    if (_products.any((element) => element.id == product.id)) {
      if (!_products.contains(product)) {
        product.decreaseCount();
        product = _products.singleWhere((element) => element.id == product.id);
      }
      product.decreaseCount();
      if (product.count == 0) {
        _products.removeWhere((element) => element.id == product.id);
      }
    }
    print(product.name + " : " + product.count.toString());
  }

  int get itemCount => _products.length;

  void clearProductList() {
    productList.forEach((e) => e.count = 0);
    productList.clear();
  }
}
