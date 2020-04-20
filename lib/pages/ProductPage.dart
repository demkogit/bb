import 'package:bb/ProductItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../cart_bloc.dart';

class ProductPage extends StatelessWidget {
  final ProductItem _productItem;

  ProductPage(this._productItem);

  @override
  Widget build(BuildContext context) {
    final cartBloc = CartBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _sizedContainer(
              CachedNetworkImage(
                imageUrl: _productItem.imageURL,
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(
                  value: progress.progress,
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              ),
            ),
            Text(
              '${_productItem.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Цена: ${_productItem.price}/1 ${_productItem.unit}'),
            Divider(),
            StreamBuilder<List<ProductItem>>(
                stream: cartBloc.productList,
                initialData: new List<ProductItem>(),
                builder: (context, snapshot) {
                  int count = 0;
                  if (snapshot.data.length > 0) {
                    if (snapshot.data.singleWhere(
                            (e) => e.id == _productItem.id,
                            orElse: () => null) !=
                        null) {
                      count = snapshot.data
                          .singleWhere((e) => e.id == _productItem.id)
                          .count;
                    }
                  }
                  return Text(
                    'Количество: ' + '$count',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
            Divider(),
            Text('Описание товара: Описание'),
            Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                  elevation: 5,
                  splashColor: Colors.green,
                  color: Colors.white,
                  shape: CircleBorder(),
                  child: Icon(Icons.add),
                  onPressed: () {
                    cartBloc.addtition.add(_productItem);
                    //pc.decrease(_product);
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
                      cartBloc.deletion.add(_productItem);
                      //pc.decrease(_product);
                    },
                  ),
                ),
              ],
            )
          ],
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
