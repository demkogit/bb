import 'package:flutter/material.dart';

class BalancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10.0), child: MyForm());
  }
}

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  double _width = 0.0;
  double _height = 0.0;
  double _area = 0.0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Form(
      key: _formKey,
      child: new Column(children: <Widget>[
        new Row(
          children: <Widget>[
            new Text(
              'Высота:',
            ),
            new Expanded(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new TextFormField(
                      initialValue: '123',
                      validator: (value) {
                        try {
                          _height = double.parse(value);
                        } catch (e) {
                          _height = 0.0;
                          return e.toString();
                        }
                      },
                    ))),
            new SizedBox(height: 20.0)
          ],
        ),
        new Row(
          children: <Widget>[
            new Text('Ширина:'),
            new Expanded(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: new TextFormField(
                      initialValue: _width.toString(),
                      validator: (value) {
                        try {
                          _width = double.parse(value);
                        } catch (e) {
                          _width = 0.0;
                          return e.toString();
                        }
                      },
                    )))
          ],
        ),
        new SizedBox(
          height: 25.0,
        ),
        new RaisedButton(
            child: Text("Посчитать"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  print(_width);
                  print(_height);
                  _area = _height * _width;
                });
              }
            }),
        new SizedBox(
          height: 20.0,
        ),
        new Text('$_area')
      ]),
    );
  }
}
