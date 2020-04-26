import 'dart:convert';

import 'package:bb/LocalDataBase/DBManager.dart';
import 'package:bb/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Api.dart';
import '../cart_bloc.dart';
import '../category.dart';
import '../device.dart';
import 'CategoryListPage.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<String> data = <String>[
//       "🍖 Мясо",
//       "🍞 Хлеб",
//       "☕️ Напитки",
//       "🍭 Сладости",
//       "👩 Здоровье"
//     ];
//     UserData userData = UserData();
//     List<ListTile> myWidgets = data.map((item) {
//       return new ListTile(
//           trailing: Icon(Icons.keyboard_arrow_right),
//           title: new Text(item),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CategoryListPage(item),
//               ),
//             );
//           });
//     }).toList();

//     ListView myList = new ListView(children: myWidgets);
//     final DBManager dbManager = new DBManager();
//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text("Выбрать; " + userData.name),
//           actions: <Widget>[
//             Padding(
//                 padding: EdgeInsets.only(right: 20.0),
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: Icon(
//                     Icons.search,
//                     size: 26.0,
//                   ),
//                 )),
//             Padding(
//                 padding: EdgeInsets.only(right: 20.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     dbManager
//                         .delete('location')
//                         .then((value) => print("Deleted!"));
//                   },
//                   child: Icon(
//                     Icons.delete,
//                     size: 26.0,
//                   ),
//                 )),
//           ],
//         ),
//         body: Container(padding: EdgeInsets.all(10.0), child: myList));
//   }
// }

class HomePage extends StatefulWidget {
  final ValueChanged<Category> onPush;
  HomePage({this.onPush});

  @override
  _HomePageState createState() => _HomePageState(onPush);
}

class _HomePageState extends State<HomePage> {
  Device device = new Device();
  List<Category> categoryList = new List();
  final ValueChanged<Category> onPush;
  _HomePageState(this.onPush);

  Widget page = Scaffold(
    body: Center(
      child: SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    device.initPlatformState();
    _loadData();
  }

  void _loadData() async {
    Api.getCatalogGroupList(1).then(
      (value) {
        var jsonVal = json.decode(value);
        if (jsonVal['error']) {
        } else {
          List<Category> temp = new List();
          for (var item in jsonVal['result']) {
            temp.add(Category(item['name'], item['id'], item['idParent']));
          }
          for (var item in temp) {
            if (item.idParent != -1) {
              temp.firstWhere((e) => e.id == item.idParent).addChild(item);
            }
          }

          setState(
            () {
              categoryList = temp.where((e) => !e.noChildren).toList();
              List<ListTile> myWidgets = categoryList.map(
                (item) {
                  return new ListTile(
                    trailing: Icon(Icons.chevron_right),
                    title: new Text(item.name),
                    onTap: () => onPush(item),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => CategoryListPage(item),
                    //     ),
                    //   );
                    // },
                  );
                },
              ).toList();

              page = new ListView(children: myWidgets);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Выбрать"),
      ),
      body: Container(padding: EdgeInsets.all(10.0), child: page),
    );
  }
}
