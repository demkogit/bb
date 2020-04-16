import 'dart:convert';

import 'package:bb/ProductCardWidget.dart';
import 'package:bb/ProductCounter.dart';
import 'package:bb/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ProductItem.dart';

// class InfoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final cartBloc = CartBloc();
//     final ProductCounter pc = Provider.of<ProductCounter>(context);
//     List<ProductCardWidget> myWidgets = new List<ProductCardWidget>();
//     //.productList.map((item) => ProductCardWidget(item)).toList();

//     GridView myGrid = GridView.count(
//         childAspectRatio: 3 / 4, crossAxisCount: 2, children: myWidgets);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Закажи"),
//         actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {
//                   print('tap');
//                   cartBloc.delete.add(ActionType.clear);
//                 },
//                 child: Icon(
//                   Icons.delete,
//                   size: 26.0,
//                 ),
//               )),
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {
//                   _savingCart();
//                 },
//                 child: Icon(
//                   Icons.save,
//                   size: 26.0,
//                 ),
//               )),
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {
//                   _readingCart();
//                 },
//                 child: Icon(
//                   Icons.chrome_reader_mode,
//                   size: 26.0,
//                 ),
//               )),
//         ],
//       ),
//       body: StreamBuilder<List<ProductItem>>(
//           stream: cartBloc.productList,
//           initialData: new List<ProductItem>(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data.length > 0) {
//                 List<ProductCardWidget> myWidgets =
//                     snapshot.data.map((e) => ProductCardWidget(e)).toList();
//                 GridView myGrid = GridView.count(
//                     childAspectRatio: 3 / 4,
//                     crossAxisCount: 2,
//                     children: myWidgets);
//                 return myGrid;
//               } else {
//                 return Center(
//                     child: Text(
//                   "В корзине пусто",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ));
//               }
//             } else {
//               return Center(
//                   child: SpinKitFadingCircle(
//                 color: Colors.blue,
//                 size: 50.0,
//               ));
//             }
//           })
//       ,
//     );
//   }

class ShoppingCartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShoppingCartPageState();
  }
}

class ShoppingCartPageState extends State<ShoppingCartPage> {
  Widget content;
  GridView myGrid;
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartBloc();
    // final ProductCounter pc = Provider.of<ProductCounter>(context);
    // List<ProductCardWidget> myWidgets = new List<ProductCardWidget>();
    //.productList.map((item) => ProductCardWidget(item)).toList();
    content = Center(
        child: SpinKitFadingCircle(
      color: Colors.blue,
      size: 50.0,
    ));
    // GridView myGrid = GridView.count(
    //     childAspectRatio: 3 / 4, crossAxisCount: 2, children: myWidgets);
    return Scaffold(
      appBar: AppBar(
        title: Text("Закажи"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print('tap');
                  cartBloc.delete.add(ActionType.clear);
                },
                child: Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _savingCart();
                },
                child: Icon(
                  Icons.save,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _readingCart();
                },
                child: Icon(
                  Icons.chrome_reader_mode,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: StreamBuilder<List<ProductItem>>(
          stream: cartBloc.productList,
          initialData: new List<ProductItem>(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                List<ProductCardWidget> myWidgets =
                    snapshot.data.map((e) => ProductCardWidget(e)).toList();
                myGrid = GridView.count(
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
              ));
            }
          }),
    );
  }

  _readingCart() async {
    final cart = CartBloc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('products');
    List list = json.decode(jsonString);
    List<ProductItem> products =
        list.map((e) => ProductItem.fromJson(e)).toList();
    cart.readingCartController.add(products);
  }

  _savingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cart = CartBloc();
    var wtf = await cart.productList.first;
    if (wtf.length > 0) {
      print(wtf.length.toString());
      await prefs.setString('products', json.encode(wtf));
    }
  }
}
