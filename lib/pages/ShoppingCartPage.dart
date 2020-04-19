import 'dart:convert';

import 'package:bb/Api.dart';
import 'package:bb/ProductCardWidget.dart';
import 'package:bb/ProductCounter.dart';
import 'package:bb/UserData.dart';
import 'package:bb/cart.dart';
import 'package:bb/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PostBody.dart';
import '../ProductItem.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartBloc();
    // final ProductCounter pc = Provider.of<ProductCounter>(context);
    //List<ProductCardWidget> myWidgets = new List<ProductCardWidget>();
    //.productList.map((item) => ProductCardWidget(item)).toList();

    // GridView myGrid = GridView.count(
    //     childAspectRatio: 3 / 4, crossAxisCount: 2, children: myWidgets);
    return Scaffold(
        appBar: AppBar(
          title: Text("Закажи"),
          actions: <Widget>[
            StreamBuilder<List<ProductItem>>(
              stream: cartBloc.productList,
              initialData: new List<ProductItem>(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    double sum = 0.0;
                    snapshot.data.forEach(
                      (e) => {sum += e.price * e.count},
                    );

                    return Row(
                      children: <Widget>[
                        Text(
                          'Сумма: $sum',
                          style: TextStyle(
                              backgroundColor: Colors.lightBlue[300],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                        GestureDetector(
                          onTap: () async => Api.order(
                            {
                              'shopId': 1,
                              'userId': UserData().id,
                              'productList': (await cartBloc.productList.first)
                                  .map((e) => e.toPOSTJson())
                                  .toList(),
                            },
                          ).then((e) {
                            var decoded = json.decode(e);
                            if (decoded['error']) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(decoded['errorDescription']),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }else{
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Заказ отправлен!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }),
                          child: Icon(
                            Icons.assignment_turned_in,
                            size: 26.0,
                          ),
                        ),
                        SizedBox(
                          width: 26.0,
                        ),
                      ],
                    );
                  } else {
                    return Text('');
                  }
                } else {
                  return Text('');
                }
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
            // Padding(
            //     padding: EdgeInsets.only(right: 20.0),
            //     child: GestureDetector(
            //       onTap: () {
            //         _savingCart();
            //       },
            //       child: Icon(
            //         Icons.save,
            //         size: 26.0,
            //       ),
            //     )),
            // Padding(
            //     padding: EdgeInsets.only(right: 20.0),
            //     child: GestureDetector(
            //       onTap: () {
            //         _readingCart();
            //       },
            //       child: Icon(
            //         Icons.chrome_reader_mode,
            //         size: 26.0,
            //       ),
            //     )),
          ],
        ),
        body: Stack(children: <Widget>[
          StreamBuilder<List<ProductItem>>(
              stream: cartBloc.productList,
              initialData: new List<ProductItem>(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    List<ProductCardWidget> myWidgets =
                        snapshot.data.map((e) => ProductCardWidget(e)).toList();
                    double sum = 0.0;
                    snapshot.data.forEach((e) => {sum += e.price * e.count});

                    GridView myGrid = GridView.count(
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
        ]));
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

// class ShoppingCartPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return ShoppingCartPageState();
//   }
// }

// class ShoppingCartPageState extends State<ShoppingCartPage> {
//   Widget content;
//   GridView myGrid;
//   @override
//   Widget build(BuildContext context) {
//     final cartBloc = CartBloc();
//     // final ProductCounter pc = Provider.of<ProductCounter>(context);
//     // List<ProductCardWidget> myWidgets = new List<ProductCardWidget>();
//     //.productList.map((item) => ProductCardWidget(item)).toList();
//     content = Center(
//         child: SpinKitFadingCircle(
//       color: Colors.blue,
//       size: 50.0,
//     ));
//     // GridView myGrid = GridView.count(
//     //     childAspectRatio: 3 / 4, crossAxisCount: 2, children: myWidgets);
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
//                 myGrid = GridView.count(
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
//           }),
//     );
//   }

// }
