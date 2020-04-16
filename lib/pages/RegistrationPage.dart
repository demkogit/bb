import 'dart:convert';

import 'package:bb/PostBody.dart';
import 'package:flutter/material.dart';

import '../Api.dart';
import '../device.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Device device = new Device();
  String _name = '';
  String _phone = '';
  String _pass = '';
  String _token = '3ac61eab-d819-4d4f-b024-6584187d8437';
  Map<String, dynamic> _selectedLocation;
  List shopList = new List();
  @override
  void initState() {
    super.initState();
    device.initPlatformState();
    _loadData();
  }

  void _loadData() async {
    Api.getShopList().then((value) {
      var jsonVal = json.decode(value);
      if (jsonVal['error']) {
      } else {
        setState(() {
          shopList = jsonVal['result'];

          _selectedLocation = shopList.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Имя'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Номер телефона'),
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
                  decoration: InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
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
                DropdownButton<Map<String, dynamic>>(
                  value: _selectedLocation,
                  items: shopList.map((value) {
                    return new DropdownMenuItem<Map<String, dynamic>>(
                      value: value,
                      child: new Text(value['name']),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    _selectedLocation = newVal;
                   print(_selectedLocation);
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //Отправка данных
                      Api.registration(PostBody(
                              data: Api.makeData(_phone, _token, _pass),
                              name: _name,
                              uid: device.deviceData['uid'],
                              deviceName: device.deviceData['deviceName'],
                              system: device.deviceData['system'],
                              systemVersion:
                                  device.deviceData['systemVersion']))
                          .then((value) {
                        //проверка ответа
                        if (json.decode(value)['error']) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text(json.decode(value)['errorDescription']),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          // тут нужно сохранить данные о пользователе и возвращаться на страницу логина

                          Navigator.pop(context);
                        }
                      });
                    } else {}
                  },
                  child: Text('Зарегистрироваться'),
                ),
              ]),
        ),
      ),
    );
  }
}
