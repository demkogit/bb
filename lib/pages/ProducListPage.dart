import 'dart:convert';

import 'package:bb/pages/ProductPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Api.dart';
import '../ProductCardWidget.dart';
import '../ProductItem.dart';
import '../category.dart';


class ProductListPage extends StatefulWidget {
  final Category currentCategory;
  final ValueChanged<ProductItem> onPush;
  ProductListPage({this.currentCategory, this.onPush});
  @override
  _ProductListPageState createState() => _ProductListPageState(currentCategory);
}

class _ProductListPageState extends State<ProductListPage> {
  Category _currentCategory;
  List<ProductItem> _productList = new List();
  GridView myGrid;
  List<ProductCardWidget> myWidgets;
  List<Widget> widgets;

  Widget page = Scaffold(
    body: Center(
        child: SpinKitFadingCircle(
      color: Colors.blue,
      size: 50.0,
    )),
  );

  _ProductListPageState(this._currentCategory);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // Загрузка списка товаров
    Api.getCatalogList(_currentCategory.id).then((value) {
      var jsonVal = json.decode(value);
      print(jsonVal['result']);
      if (jsonVal['error']) {
      } else {
        List<ProductItem> temp = new List();
        for (var item in jsonVal['result']) {
          temp.add(ProductItem(
              item['name'], item['price'], item['id'], item['imageURL']));
        }

        setState(() {
          //print(_productList.length);
          if (temp.length > 0) {
            //myWidgets = temp.map((e) => ProductCardWidget(e)).toList();
            widgets = temp.map((e) {
              return GridTile(
                  child: InkResponse(
                child: ProductCardWidget(e),
                onTap: () => _onTileClicked(e),
              ));
            }).toList();

            var grid =
                SliverGrid.extent(maxCrossAxisExtent: 200.0, childAspectRatio: 3/4, children: widgets);

            page = CustomScrollView(slivers: [grid]);
          } else {
            page = Center(
              child: Text(
                "Пусто",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCategory.name),
      ),
      body: page,
    );
  }

  void _onTileClicked(ProductItem item) {
    print(item.toJson());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(item),
      ),
    );
  }
}
