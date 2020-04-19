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
  final _pageOptions = [HomePage(), ShoppingCartPage()];

  _readingCart() async {
    final cartBloc = CartBloc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('products');
    List list = json.decode(jsonString);
    List<ProductItem> products =
        list.map((e) => ProductItem.fromJson(e)).toList();
    cartBloc.readingCartController.add(products);
  }

  @override
  Widget build(BuildContext context) {
    _readingCart();
    return MaterialApp(
        title: "MyApp",
        theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            appBarTheme: AppBarTheme(color: Colors.white)),
        home: Scaffold(
          body: _pageOptions[_selectedPage],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                print(index);
                _selectedPage = index;
              });
            },
            items: [
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.account_balance_wallet),
              //     title: Text("Balance")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Выбрать")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_shopping_cart), title: Text("Корзина"))
            ],
          ),
        ));
  }
}
