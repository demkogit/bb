import 'dart:convert';

import 'package:bb/Api.dart';
import 'package:bb/ProductCardWidget.dart';
import 'package:bb/ProductCounter.dart';
import 'package:bb/UserData.dart';
import 'package:bb/cart.dart';
import 'package:bb/cart_bloc.dart';
import 'package:bb/send_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PostBody.dart';
import '../ProductItem.dart';
import 'RegistrationPage.dart';

class ShoppingCartPage extends StatelessWidget {
  final GlobalKey navigatorKey;
  // ShoppingCartPage(this._globalKey);
  final ValueChanged<ProductItem> onPush;
  final ValueChanged<int> selectTab;
  ShoppingCartPage({this.onPush, this.navigatorKey, this.selectTab});

  final cartBloc = CartBloc();
  @override
  Widget build(BuildContext context) {
    List<ProductCardWidget> myWidgets = [];
    GridView myGrid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Закажи"),
        actions: <Widget>[
          FlatButton(
            child: Text('Tap'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => RegistrationPage(),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print('tap');
                cartBloc.delete.add(ActionType.clear);
                _savingCart();
              },
              child: Icon(
                Icons.delete,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<List<ProductItem>>(
            stream: cartBloc.productList,
            initialData: new List<ProductItem>(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  myWidgets =
                      snapshot.data.map((e) => ProductCardWidget(e)).toList();

                  myGrid = GridView.count(
                      padding: EdgeInsets.only(bottom: 60.0),
                      childAspectRatio: 3 / 4,
                      crossAxisCount: 2,
                      children: myWidgets);
                  return myGrid;
                } else {
                  return Center(
                      child: Text(
                    "В корзине пусто",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ));
                }
              } else {
                return Center(
                  child: SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                );
              }
            },
          ),
          SendOrderWidget(
            //pushRegistration: (name) => Navigator.pushNamed(context, name),
            stream: cartBloc.total,
            selectTab: selectTab,
          ),
        ],
      ),
    );
  }

  _savingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cart = CartBloc();
    var wtf = await cart.productList.first;
    //if (wtf.length > 0) {
    print(wtf.length.toString());
    await prefs.setString('products', json.encode(wtf));
    //}
  }
}
