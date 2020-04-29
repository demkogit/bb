import 'dart:convert';

import 'package:bb/PostBody.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../Api.dart';
import '../device.dart';
import 'LoginPage.dart';

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
  String _passRepeat = '';
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
    var textEditingController = TextEditingController();
    var maskTextInputFormatter = MaskTextInputFormatter(
        mask: "(###) ###-##-##", filter: {"#": RegExp(r'[0-9]')});

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: TextFormField(
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
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter some text';
                      if (textEditingController.text.length != 10)
                        return 'Неверный формат номера';
                      return null;
                    },
                    // controller: textEditingController,
                    inputFormatters: [maskTextInputFormatter],
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixText: "+7 ",
                      prefixStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      hintText: "(123) 123-45-67",
                      fillColor: Colors.white,
                    ),
                    // filled: true),
                  ),
                  // TextField(
                  //   controller: textEditingController,
                  //   inputFormatters: [maskTextInputFormatter],
                  //   autocorrect: false,
                  //   keyboardType: TextInputType.phone,
                  //   decoration: InputDecoration(
                  //       hintText: "+1 (123) 123-45-67",
                  //       fillColor: Colors.white,
                  //       filled: true),

                  //   onChanged: (value) {
                  //     setState(() {
                  //       _phone = value;
                  //     });
                  //   },
                  // ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter some text';
                      if (value != _passRepeat) return 'Пароли не совпадают';
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _pass = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Повтор пароля'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter some text';
                      if (value != _pass) return 'Пароли не совпадают';
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _passRepeat = value;
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
                                data: Api.makeData("8" + _phone, _token, _pass),
                                name: _name,
                                uid: device.deviceData['uid'],
                                deviceName: device.deviceData['deviceName'],
                                system: device.deviceData['system'],
                                systemVersion:
                                    device.deviceData['systemVersion']))
                            .then(
                          (value) {
                            //проверка ответа
                            if (json.decode(value)['error']) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    json.decode(value)['errorDescription']),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              // тут нужно сохранить данные о пользователе и возвращаться на страницу логина

                              Navigator.pop(context);
                            }
                          },
                        );
                      } else {}
                    },
                    child: Text('Зарегистрироваться'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage())),
                    color: Colors.transparent,
                    textColor: Colors.blue,
                    child: Text("Уже зарегистрированы? Войти"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
