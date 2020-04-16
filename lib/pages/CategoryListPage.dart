import 'package:flutter/material.dart';

import '../category.dart';
import 'ProducListPage.dart';

class CategoryListPage extends StatelessWidget {
  Category _currentCategory;
  CategoryListPage(this._currentCategory);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List<ListTile> myWidgets = _currentCategory.children.map((item) {
      return new ListTile(
          trailing: Icon(Icons.keyboard_arrow_right),
          title: new Text(item.name),
          onTap: () {
            if (item.noChildren) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListPage(item),
                ),
              );
            }else{
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryListPage(item),
                ),
              );
            }
          });
    }).toList();

    ListView myList = new ListView(children: myWidgets);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_currentCategory.name),
      ),
      body: myList,
    );
  }
}
