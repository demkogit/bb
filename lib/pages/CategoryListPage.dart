import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../category.dart';
import 'ProducListPage.dart';

class CategoryListPage extends StatelessWidget {
  final Category currentCategory;
  final ValueChanged<Category> onPush;
  CategoryListPage({this.currentCategory, this.onPush});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List<ListTile> myWidgets = currentCategory.children.map((item) {
      return new ListTile(
        trailing: Icon(Icons.keyboard_arrow_right),
        title: new Text(item.name),
        // onTap: () {
        //   if (item.noChildren) {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ProductListPage(item),
        //       ),
        //     );
        //   } else {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => CategoryListPage(item, onPush),
        //       ),
        //     );
        //   }
        onTap: () => onPush(item),
      );
    }).toList();

    ListView myList = new ListView(children: myWidgets);
    var parser = EmojiParser();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          parser.emojify(currentCategory.name),
        ),
      ),
      body: myList,
    );
  }
}
