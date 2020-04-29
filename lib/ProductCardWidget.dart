import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductItem.dart';
import 'cart_bloc.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductItem _product;
  ProductCardWidget(this._product);

  @override
  Widget build(BuildContext context) {
    //final ProductCounter pc = Provider.of<ProductCounter>(context);
    final cartBloc = CartBloc();
    var controller = TextEditingController();

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
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Marquee(
                          text: _product.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 40.0,
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
                    // Expanded(
                    //   flex: 1,
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //         flex: 2,
                    //         child: Text(
                    //           'Количество:',
                    //           style: TextStyle(fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 1,
                    //         child: TextField(
                    //           controller: controller,
                    //           decoration: InputDecoration(
                    //             border: InputBorder.none,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                          controller.text = '$count';
                          return Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Количество:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) async {
                                    if (text.length > 3) {
                                      //controller.clear();
                                      controller.text = text.substring(0, 3);
                                      controller.selection =
                                          TextSelection.collapsed(
                                              offset: controller.text.length);
                                    }
                                    //text = text.substring(0, 2);
                                  },
                                  onEditingComplete: () {
                                    if (controller.text.isEmpty) {
                                      controller.text = '0';
                                      _product.count = 0;
                                    } else
                                      _product.count =
                                          int.parse(controller.text);
                                    print('productcount: ${_product.count}');
                                    cartBloc.changeCount.add(_product);
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                            ],
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
