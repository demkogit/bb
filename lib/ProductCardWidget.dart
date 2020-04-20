import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //first element in the column is the white background (the Image.asset in your case)
                      // DecoratedBox(
                      //     decoration: BoxDecoration(
                      //       image: new DecorationImage(
                      //         image: new AssetImage('images/cat.jpg'),
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //     child: Container(
                      //       width: 140.0,
                      //       height: 90.0,
                      //     )),
                      //second item in the column is a transparent space of 20
                      CachedNetworkImage(
                        imageUrl: _product.imageURL,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 50,
                        ),
                        imageBuilder: (context, image) => CircleAvatar(
                          backgroundImage: image,
                          radius: 50,
                        ),
                      ),
                      Container(height: 10.0)
                    ],
                  ),
                  Column(children: <Widget>[
                    //first element in column is the transparent offset
                    Container(
                      height: 60.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            //pc.increase(_product);
                          },
                        )),
                        Expanded(
                            child: RaisedButton(
                          elevation: 5,
                          splashColor: Colors.green,
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Icon(Icons.remove),
                          onPressed: () {
                            cartBloc.deletion.add(_product);
                            _savingCart();
                            //pc.decrease(_product);
                          },
                        )),
                      ],
                    )
                  ]),
                ],
              ),
              Expanded(child: Text(_product.name)),
              // Text(
              //   _product.price.toString() + " ₽ / 1 " + _product.unit.toString(),
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              Text('${_product.price} руб./1 ${_product.unit}'),
              StreamBuilder<List<ProductItem>>(
                  stream: cartBloc.productList,
                  initialData: new List<ProductItem>(),
                  builder: (context, snapshot) {
                    int count = 0;
                    if (snapshot.data.length > 0) {
                      if (snapshot.data.singleWhere((e) => e.id == _product.id,
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
                  }),

              // Text(
              //   'Количество: ' + _product.count.toString(),//_product.count.toString(),
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
            ]),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Container(
        //         constraints: new BoxConstraints.expand(
        //           height: 100.0,
        //         ),
        //         // padding:
        //         //     new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
        //         decoration: new BoxDecoration(
        //           image: new DecorationImage(
        //             image: new AssetImage('images/cat.jpg'),
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //         ),
        //     Text(_product.name),
        //     Text(
        //       _product.price.toString() + " ₽ / 1 " + _product.unit.toString(),
        //       style: TextStyle(fontWeight: FontWeight.bold),
        //     ),
        //     Positioned(
        //       child: FlatButton(
        //         color: Colors.red,
        //         child: Text("Press Me"),
        //         onPressed: () {},
        //       ),
        //       right: 0,
        //       top: 0
        //     )
        //   ],
        // ),
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
