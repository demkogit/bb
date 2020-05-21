import 'package:bb/ProductItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../cart_bloc.dart';

class ProductPage extends StatelessWidget {
  final ProductItem _product;

  ProductPage(this._product);

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartBloc();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(''),
    //   ),
    //   body: Padding(
    //     padding: EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         _sizedContainer(
    //           CachedNetworkImage(
    //             imageUrl: _productItem.imageURL,
    //             progressIndicatorBuilder: (context, url, progress) =>
    //                 CircularProgressIndicator(
    //               value: progress.progress,
    //             ),
    //             placeholder: (context, url) =>
    //                 const CircularProgressIndicator(),
    //             errorWidget: (context, url, error) =>
    //                 const Icon(Icons.broken_image),
    //           ),
    //         ),
    //         Text(
    //           '${_productItem.name}',
    //           style: TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         Text('Цена: ${_productItem.price}/1 ${_productItem.unit}'),
    //         Divider(),
    //         StreamBuilder<List<ProductItem>>(
    //             stream: cartBloc.productList,
    //             initialData: new List<ProductItem>(),
    //             builder: (context, snapshot) {
    //               int count = 0;
    //               if (snapshot.data.length > 0) {
    //                 if (snapshot.data.singleWhere(
    //                         (e) => e.id == _productItem.id,
    //                         orElse: () => null) !=
    //                     null) {
    //                   count = snapshot.data
    //                       .singleWhere((e) => e.id == _productItem.id)
    //                       .count;
    //                 }
    //               }
    //               return Text(
    //                 'Количество: ' + '$count',
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               );
    //             }),
    //         Divider(),
    //         Text('Описание товара: Описание'),
    //         Row(
    //           children: <Widget>[
    //             Expanded(
    //                 child: RaisedButton(
    //               elevation: 5,
    //               splashColor: Colors.green,
    //               color: Colors.white,
    //               shape: CircleBorder(),
    //               child: Icon(Icons.add),
    //               onPressed: () {
    //                 cartBloc.addtition.add(_productItem);
    //                 //pc.decrease(_product);
    //               },
    //             )),
    //             Expanded(
    //               child: RaisedButton(
    //                 elevation: 5,
    //                 splashColor: Colors.green,
    //                 color: Colors.white,
    //                 shape: CircleBorder(),
    //                 child: Icon(Icons.remove),
    //                 onPressed: () {
    //                   cartBloc.deletion.add(_productItem);
    //                   //pc.decrease(_product);
    //                 },
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          20.0,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
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
                /*Image*/
                // Expanded(
                //   child: Row(
                //     children: <Widget>[
                //       Expanded(
                //         child: RaisedButton(
                //           onPressed: () => print('+'),
                //           child: Text('+'),
                //         ),
                //       ),
                //       Expanded(
                //         child: TextField(),
                //       ),
                //       Expanded(
                //         child: RaisedButton(
                //           onPressed: () => print('-'),
                //           child: Text('-'),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        _product.name,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text(
                            'Цена: ${_product.price}р./${_product.unit}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('20р/1шт'),
                        ],
                      ),
                      Divider(),
                      Text(
                        'Описание',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '<описание>'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sizedContainer(Widget child) {
    return SizedBox(
      width: 300.0,
      height: 150.0,
      child: Center(child: child),
    );
  }
}
