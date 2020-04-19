import 'package:flutter/material.dart';

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
