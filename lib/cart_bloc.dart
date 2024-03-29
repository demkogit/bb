import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'ProductItem.dart';
import 'cart.dart';

enum ActionType { clear, getTotal }

class CartBloc {
  final _cart = new Cart();

  static final CartBloc _singleton = CartBloc._internal();
  factory CartBloc() => _singleton;
  CartBloc._internal() {
    _additionController.stream.listen(_additionHandle);
    _deletionController.stream.listen(_deletionHandle);
    _actionController.stream.listen(_actionHandle);
    _readingCartController.stream.listen(_readingCart);

    _changeCountController.stream.listen(_changeCountHandler);
    //_productController.stream.listen(_productHandle);
  }

  final _additionController = StreamController<ProductItem>();
  Sink<ProductItem> get addtition => _additionController.sink;

  final _deletionController = StreamController<ProductItem>();
  Sink<ProductItem> get deletion => _deletionController.sink;

  final _readingCartController = StreamController<List<ProductItem>>();
  Sink<List<ProductItem>> get readingCartController =>
      _readingCartController.sink;

  final _itemCountSubject = BehaviorSubject<int>();
  Stream<int> get itemCount => _itemCountSubject.stream;

  final _productsSubject = BehaviorSubject<List<ProductItem>>();
  Stream<List<ProductItem>> get productList => _productsSubject.stream;

  final _actionController = StreamController<ActionType>();
  Sink<ActionType> get delete => _actionController.sink;

  final _changeCountController = StreamController<ProductItem>();
  Sink<ProductItem> get changeCount => _changeCountController.sink;

  final _totalSubject = BehaviorSubject<double>();
  Stream<double> get total => _totalSubject.stream;

  void _additionHandle(ProductItem product) {
    _cart.add(product);
    _itemCountSubject.add(_cart.itemCount);
    _productsSubject.add(_cart.productList);
    _totalSubject.add(_cart.total);
  }

  void _deletionHandle(ProductItem product) {
    _cart.remove(product);
    _itemCountSubject.add(_cart.itemCount);
    _productsSubject.add(_cart.productList);
    _totalSubject.add(_cart.total);
  }

  void _readingCart(List<ProductItem> products) {
    _cart.productList.clear();
    _cart.setProductList(products);
    _productsSubject.add(_cart.productList);
    _itemCountSubject.add(_cart.itemCount);
    _totalSubject.add(_cart.total);
  }

  void _changeCountHandler(ProductItem product) {
    _cart.changeCount(product);
    _itemCountSubject.add(_cart.itemCount);
    _productsSubject.add(_cart.productList);
    _totalSubject.add(_cart.total);
  }

  void _actionHandle(ActionType type) {
    switch (type) {
      case ActionType.clear:
        _cart.clearProductList();
        _itemCountSubject.add(_cart.itemCount);
        _productsSubject.add(_cart.productList);
        _totalSubject.add(_cart.total);
        break;
      default:
    }
  }
}
