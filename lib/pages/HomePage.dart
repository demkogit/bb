import 'dart:convert';

import 'dart:convert' show utf8;

import 'package:bb/LocalDataBase/DBManager.dart';
import 'package:bb/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Api.dart';
import '../cart_bloc.dart';
import '../category.dart';
import '../device.dart';
import 'CategoryListPage.dart';

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
    // device.initPlatformState();
    // _loadData();
  }

  List<Category> toRemove = [];
  void _loadData() async {
    Api.getCatalogGroupList(1).then(
      (value) {
        var jsonVal = json.decode(value);
        var parser = EmojiParser();
        if (jsonVal['error']) {
        } else {
          List<Category> temp = new List();
          for (var item in jsonVal['result']) {
            temp.add(Category(
                parser.emojify(item['name']), item['id'], item['idParent']));
          }
          for (var item in temp.reversed) {
            if (item.idParent != -1 && item.idParent != null) {
              temp
                  .where((e) => e.id == item.idParent)
                  .forEach((e) => e.addChild(item));
              toRemove.add(item);
            }
          }

          temp.removeWhere((e) => toRemove.contains(e));

          setState(
            () {
              categoryList = temp.where((e) => !e.noChildren).toList();
              List<ListTile> myWidgets = categoryList.map(
                (item) {
                  //print(item.name);
                  return new ListTile(
                    trailing: Icon(Icons.chevron_right),
                    title: new Text(
                      item.name,
                    ),
                    onTap: () => onPush(item),
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
    device.initPlatformState();
    _loadData();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Выбрать'),
      ),
      // body: Container(padding: EdgeInsets.all(10.0), child: page),
      body: FutureBuilder<String>(
        future: Api.getCatalogGroupList(1),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> myWidgets = [];
          List<Category> temp = [];
          if (snapshot.hasData) {
            var jsonVal = json.decode(snapshot.data);
            var parser = EmojiParser();
            if (jsonVal['error']) {
            } else {
              for (var item in jsonVal['result']) {
                temp.add(Category(parser.emojify(item['name']), item['id'],
                    item['idParent']));
              }
              for (var item in temp.reversed) {
                if (item.idParent != -1 && item.idParent != null) {
                  temp
                      .where((e) => e.id == item.idParent)
                      .forEach((e) => e.addChild(item));
                  toRemove.add(item);
                }
              }
              temp.removeWhere((e) => toRemove.contains(e));
              temp = temp.where((e) => !e.noChildren).toList();
              // myWidgets.add(ListView(
              //     children: ListTile.divideTiles(
              //   context: context,
              //   tiles: temp.map(
              //     (item) {
              //       return new ListTile(
              //         trailing: Icon(Icons.chevron_right),
              //         title: new Text(
              //           item.name,
              //         ),
              //         onTap: () => onPush(item),
              //       );
              //     },
              //   ),
              // ).toList()));
              myWidgets = temp.map(
                (item) {
                  return new ListTile(
                    trailing: Icon(Icons.chevron_right),
                    title: new Text(
                      item.name,
                    ),
                    onTap: () => onPush(item),
                  );
                },
              ).toList();
              page = ListView(children: myWidgets);
            }
          } else if (snapshot.hasError) {
            myWidgets = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
            page = ListView(
              children: myWidgets,
            );
          } else {
            page = Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            );
          }

          return Center(
            child: page,
          );
        },
      ),
    );
  }
}
