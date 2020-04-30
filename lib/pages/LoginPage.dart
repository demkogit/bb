import 'dart:convert';

import 'package:bb/UserData.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var phoneController = TextEditingController();
    var passController = TextEditingController();
    var maskTextInputFormatter = MaskTextInputFormatter(
        mask: "(###) ###-##-##", filter: {"#": RegExp(r'[0-9]')});

    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      key: _scaffoldKey,
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Номер телефона'),
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'Please enter some text';
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _phone = value;
                  //     });
                  //   },
                  // ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) return 'Поле не должно быть пустым';
                      if (maskTextInputFormatter.getUnmaskedText().length != 10)
                        return 'Неверный формат номера';
                      return null;
                    },
                    controller: phoneController,
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
                  ),
                  TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Пароль'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Поле не должно быть пустым';
                      }
                      return null;
                    },
                    // onChanged: (value) {
                    //   setState(() {
                    //     _pass = value;
                    //   });
                    // },
                  ),
                  RaisedButton(
                    onPressed: () {
                      print('phone $_phone');
                      print('text ${maskTextInputFormatter.getUnmaskedText()}');
                      if (_formKey.currentState.validate()) {
                        Api.authorization(PostBody(
                                data: Api.makeData(
                                    '8' +
                                        maskTextInputFormatter
                                            .getUnmaskedText(),
                                    _token,
                                    _pass),
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
                            _saveUserData();
                            print('${data.name} : ${data.id}');
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        });
                      }
                    },
                    child: Text('Войти'),
                  ),
                  // RaisedButton(
                  //   onPressed: () =>
                  //       Navigator.pushNamed(context, '/Registration'),
                  //   child: Text('Регистрация'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveUserData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('user', UserData().toJson().toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> asd = {"_id": UserData().id, "_name": UserData().name};

    await prefs.setString('user', json.encode(asd));
    print(await prefs.getString('user'));
  }
}
