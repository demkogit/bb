import 'package:bb/pages/LoginPage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginPage(),
              ),
            ),
            child: GestureDetector(
              child: Image.asset('images/door.png'),
            ),
          ),
        ],
      ),
      //body: Image.asset('images/img.jpg'),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Card(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text('asd'),
              ),
              Expanded(
                child: TextField(
                  enableInteractiveSelection: false,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
