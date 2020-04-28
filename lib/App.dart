import 'dart:convert';

import 'package:bb/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductItem.dart';
import 'bottom_navigation.dart';
import 'cart_bloc.dart';
import 'pages/BalancePage.dart';
import 'pages/HomePage.dart';
import 'pages/ShoppingCartPage.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  //int _selectedPage = 0;
  //static GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  //var _pageOptions = [HomePage(globalKey), ShoppingCartPage(globalKey)];
  int _currentTab = 2;
  Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(), // HomePage()
    1: GlobalKey<NavigatorState>(), // CartPage()
    2: GlobalKey<NavigatorState>(), // MainPage()
  };
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _readingCart();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != 0) {
            _selectTab(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          // _buildOffstageNavigator(TabItem.blue),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  void _selectTab(int tabItem, {bool buy: false}) {
    int temp = tabItem;
    if (tabItem == -1) tabItem = 0;
    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
    if (temp == -1) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Заказ отправлен!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildOffstageNavigator(int tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabIndex: tabItem,
        selectTab: _selectTab,
        // tabItem: tabItem,
      ),
    );
  }

  _readingCart() async {
    final cartBloc = CartBloc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('products');
    if (jsonString != null) {
      List list = json.decode(jsonString);
      List<ProductItem> products =
          list.map((e) => ProductItem.fromJson(e)).toList();
      cartBloc.readingCartController.add(products);
      print('App -> _readingCart()');
    }
  }
}
