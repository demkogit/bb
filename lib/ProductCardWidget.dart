import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductCounter.dart';
import 'ProductItem.dart';
import 'cart_bloc.dart';

class ProductCardWidget extends StatelessWidget {
  ProductItem _product;
  ProductCardWidget(this._product);

  @override
  Widget build(BuildContext context) {
    //final ProductCounter pc = Provider.of<ProductCounter>(context);
    final cartBloc = CartBloc();

    // return Card(
    //   child: Padding(
    //     padding: EdgeInsets.all(10.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         Stack(
    //           children: <Widget>[
    //             Column(
    //               children: <Widget>[
    //                 Container(
    //                   width: 100,
    //                   height: 100,
    //                   child: CachedNetworkImage(
    //                     fit: BoxFit.contain,
    //                     imageUrl: _product.imageURL,
    //                     placeholder: (context, url) =>
    //                         const CircularProgressIndicator(),
    //                     errorWidget: (context, url, error) =>
    //                         const Icon(Icons.error),
    //                   ),
    //                 ),

    //                 // CachedNetworkImage(
    //                 //   fit: BoxFit.fill,
    //                 //   imageUrl: _product.imageURL,
    //                 //   placeholder: (context, url) => CircleAvatar(
    //                 //     backgroundColor: Colors.grey[300],
    //                 //     radius: 50,
    //                 //   ),
    //                 //   imageBuilder: (context, image) => CircleAvatar(
    //                 //     backgroundImage: image,
    //                 //     radius: 50,
    //                 //   ),
    //                 // ),
    //                 Container(height: 10.0)
    //               ],
    //             ),
    //             Column(
    //               children: <Widget>[
    //                 //first element in column is the transparent offset
    //                 Container(
    //                   height: 60.0,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: <Widget>[
    //                     Expanded(
    //                       child: RaisedButton(
    //                         elevation: 5,
    //                         splashColor: Colors.green,
    //                         color: Colors.white,
    //                         shape: CircleBorder(),
    //                         child: Icon(Icons.add),
    //                         onPressed: () {
    //                           cartBloc.addtition.add(_product);
    //                           _savingCart();
    //                         },
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: RaisedButton(
    //                         elevation: 5,
    //                         splashColor: Colors.green,
    //                         color: Colors.white,
    //                         shape: CircleBorder(),
    //                         child: Icon(Icons.remove),
    //                         onPressed: () {
    //                           cartBloc.deletion.add(_product);
    //                           _savingCart();
    //                         },
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ],
    //         ),
    //         Expanded(child: Text(_product.name)),
    //         Text('${_product.price} руб./1 ${_product.unit}'),
    //         StreamBuilder<List<ProductItem>>(
    //           stream: cartBloc.productList,
    //           initialData: new List<ProductItem>(),
    //           builder: (context, snapshot) {
    //             int count = 0;
    //             if (snapshot.data.length > 0) {
    //               if (snapshot.data.singleWhere((e) => e.id == _product.id,
    //                       orElse: () => null) !=
    //                   null) {
    //                 count = snapshot.data
    //                     .singleWhere((e) => e.id == _product.id)
    //                     .count;
    //               }
    //             }
    //             return Text(
    //               'Количество: ' + '$count',
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: Center(
                      child: CachedNetworkImage(
                        //fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                          child: const CircularProgressIndicator(),
                        ),
                        imageUrl: _product.imageURL,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            elevation: 5,
                            splashColor: Colors.green,
                            color: Colors.white,
                            shape: CircleBorder(),
                            child: Icon(Icons.add),
                            onPressed: () {
                              cartBloc.addtition.add(_product);
                              _savingCart();
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            elevation: 5,
                            splashColor: Colors.red,
                            color: Colors.white,
                            shape: CircleBorder(),
                            child: Icon(Icons.remove),
                            onPressed: () {
                              cartBloc.deletion.add(_product);
                              _savingCart();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              flex: 2,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.topLeft,
                        // child: Text(
                        //   _product.name,
                        //   overflow: TextOverflow.fade,
                        //   style: TextStyle(fontWeight: FontWeight.bold,),
                        // ),
                        child: Marquee(
                          text: _product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          pauseAfterRound: Duration(seconds: 2),
                          startPadding: 10.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        child: Text('${_product.price}р/1${_product.unit}'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: StreamBuilder<List<ProductItem>>(
                        stream: cartBloc.productList,
                        initialData: new List<ProductItem>(),
                        builder: (context, snapshot) {
                          int count = 0;
                          if (snapshot.data.length > 0) {
                            if (snapshot.data.singleWhere(
                                    (e) => e.id == _product.id,
                                    orElse: () => null) !=
                                null) {
                              count = snapshot.data
                                  .singleWhere((e) => e.id == _product.id)
                                  .count;
                            }
                          }
                          return Text(
                            'Количество: ' + '$count',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 300.0,
      height: 150.0,
      child: Center(child: child),
    );
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
