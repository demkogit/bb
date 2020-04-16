import 'dart:convert';

import 'package:bb/UserData.dart';
import 'package:flutter/material.dart';

import '../Api.dart';
import '../PostBody.dart';
import '../device.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Device device = new Device();
  String _phone = '';
  String _token = '3ac61eab-d819-4d4f-b024-6584187d8437';
  String _pass = '';

  @override
  void initState() {
    device.initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Логин'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Пароль'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _pass = value;
                    });
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Api.authorization(PostBody(
                              data: Api.makeData(_phone, _token, _pass),
                              name: '',
                              uid: device.deviceData['uid'],
                              deviceName: device.deviceData['deviceName'],
                              system: device.deviceData['system'],
                              systemVersion:
                                  device.deviceData['systemVersion']))
                          .then((value) {
                        var jsonVal = json.decode(value);
                        if (jsonVal['error']) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(jsonVal['errorDescription']),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          UserData data = UserData();
                          data.setId(jsonVal['result']['id']);
                          data.setName(jsonVal['result']['name']);
                          Navigator.pushReplacementNamed(context, '/Home');
                        }
                      });
                    }
                  },
                  child: Text('Войти'),
                ),
                RaisedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/Registration'),
                  child: Text('Регистрация'),
                ),
                FlatButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/Home'),
                    color: Colors.transparent,
                    textColor: Colors.blue,
                    child: Text("Войти как гость")),
              ]),
        ),
      ),
    );
  }
}
