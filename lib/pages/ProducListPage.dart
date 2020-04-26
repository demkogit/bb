import 'dart:convert';

import 'package:bb/pages/ProductPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Api.dart';
import '../ProductCardWidget.dart';
import '../ProductCounter.dart';
import '../ProductItem.dart';
import '../cart_bloc.dart';
import '../category.dart';

// class ProductListPage extends StatelessWidget {
//   Category _currentCategory;
//   ProductListPage(this._currentCategory);
//   @override
//   Widget build(BuildContext context) {
//     List<ProductItem> data1 = [
//       ProductItem("Фарш свинной", 199, 3),
//       ProductItem("Сосиски", 100, 4)
//     ];
//     List<ProductItem> data2 = [
//       ProductItem("Гамбургер", 33, 0),
//       ProductItem("Не гамбургер", 100, 1),
//       ProductItem("Говяжий анус", 100, 2)
//     ];
//     List<ProductItem> data3 = [
//       ProductItem("Ничего", 33, 10),
//     ];

//     List<ProductCardWidget> myWidgets = [];
//     switch (_currentCategory.name) {
//       case "Свинина":
//         myWidgets = data1.map((e) => ProductCardWidget(e)).toList();
//         break;
//       case "Баранина":
//         myWidgets = data2.map((e) => ProductCardWidget(e)).toList();
//         break;
//       default:
//         myWidgets = data3.map((e) => ProductCardWidget(e)).toList();
//     }
//     GridView myGrid = GridView.count(
//         childAspectRatio: 3 / 4, crossAxisCount: 2, children: myWidgets);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_currentCategory.name),
//       ),
//       body: myGrid,
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   ProductItem _item;

//   ProductCard(this._item);
//   ProductItem get item => _item;
//   final cartBloc = CartBloc();

//   @override
//   Widget build(BuildContext context) {
//     final ProductCounter pc = Provider.of<ProductCounter>(context);
//     return Card(
//         elevation: 4,
//         child: Container(
//           height: 40,
//           child: Column(
//             children: <Widget>[
//               Text(item.name),
//               Text(item.price.toString() + " руб."),
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: RaisedButton(
//                       onPressed: () {
//                         cartBloc.addtition.add(item);
//                         //pc.increase(item);
//                       },
//                       color: Colors.green,
//                       child: Text("+"),
//                     ),
//                   ),
//                   Expanded(
//                       child: RaisedButton(
//                     onPressed: () {
//                       cartBloc.deletion.add(item);
//                       // pc.decrease(item);
//                       // print(pc.productList.length);
//                     },
//                     color: Colors.red,
//                     child: Text("-"),
//                   )),
//                 ],
//               ),
//               StreamBuilder(
//                   stream: cartBloc.itemCount,
//                   initialData: 0,
//                   builder: (context, snapshot) => Text('${snapshot.data}'))
//             ],
//           ),
//         ));
//   }
// }

class ProductListPage extends StatefulWidget {
  final Category currentCategory;
  final ValueChanged<ProductItem> onPush;
  ProductListPage({this.currentCategory,this.onPush});
  @override
  _ProductListPageState createState() =>
      _ProductListPageState(currentCategory);
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
          temp.add(ProductItem(item['name'], item['price'], item['id'], item['imageURL']));
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
            myGrid = GridView.count(
                childAspectRatio: 3 / 4, crossAxisCount: 2, children: widgets);
            page = myGrid;
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
