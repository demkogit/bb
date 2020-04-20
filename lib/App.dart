import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductItem.dart';
import 'cart_bloc.dart';
import 'pages/BalancePage.dart';
import 'pages/HomePage.dart';
import 'pages/ShoppingCartPage.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedPage = 0;
  static GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  var _pageOptions = [HomePage(globalKey), ShoppingCartPage(globalKey)];

  _readingCart() async {
    final cartBloc = CartBloc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('products');
    List list = json.decode(jsonString);
    List<ProductItem> products =
        list.map((e) => ProductItem.fromJson(e)).toList();
    cartBloc.readingCartController.add(products);
    print('App -> _readingCart()');
  }

  @override
  void initState() {
    _readingCart();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          appBarTheme: AppBarTheme(color: Colors.white)),
      home: Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          key: globalKey,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              //print(index);
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text("Выбрать")),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart), title: Text("Корзина"))
          ],
        ),
      ),
    );
  }
}
