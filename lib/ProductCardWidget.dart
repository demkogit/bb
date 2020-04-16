import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      DecoratedBox(
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage('images/cat.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            width: 140.0,
                            height: 90.0,
                          )),
                      //second item in the column is a transparent space of 20
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
                            //pc.decrease(_product);
                          },
                        )),
                      ],
                    )
                  ]),
                ],
              ),
              Expanded( child: Text(_product.name)),
              // Text(
              //   _product.price.toString() + " ₽ / 1 " + _product.unit.toString(),
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),

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
}
