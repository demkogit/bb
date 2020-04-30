import 'dart:convert';

import 'package:bb/pages/RegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Api.dart';
import 'ProductItem.dart';
import 'UserData.dart';
import 'cart_bloc.dart';

class SendOrderWidget extends StatelessWidget {
  final Stream stream;
  final ValueChanged<int> selectTab;
  final ValueChanged<MaterialPageRoute> pushRegistration;
  SendOrderWidget({this.stream, this.selectTab, this.pushRegistration});
  final cartBloc = CartBloc();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('Данные: ${snapshot.data}');
          return Visibility(
            visible: snapshot.data > 0,
            child: Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                color: Colors.blue[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Сумма заказа: ${snapshot.data} руб.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RaisedButton(
                      child: Text('Заказать'),
                      onPressed: () async {
                        if (await _readUserData()) {
                          // Есть данные по пользователю
                          // Отправить заказ
                          Api.order({
                            'shopId': 1,
                            'userId': UserData().id,
                            'productList': (await cartBloc.productList.first)
                                .map((e) => e.toPOSTJson())
                                .toList(),
                          }).then(
                            (e) {
                              var decoded = json.decode(e);
                              if (decoded['error']) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(decoded['errorDescription']),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                cartBloc.delete.add(ActionType.clear);
                                _savingCart();
                                selectTab(-1);
                              }
                            },
                          );
                        } else {
                          print('asd');
                          // Нет данных по пользователю
                          // Показать окно регистрации с кнопкой перехода на окно авторизации
                          //Navigator.pushNamed(context, '/Registration');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegistrationPage(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else
          return Text('');
      },
    );
  }

  _savingCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cart = CartBloc();
    var wtf = await cart.productList.first;

    print(wtf.length.toString());
    await prefs.setString('products', json.encode(wtf));
  }

  Future<bool> _readUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('user');
    if (jsonString != null) {
      print(jsonString);
      Map<String, dynamic> map = json.decode(jsonString);
      UserData data = UserData();
      data.setId(map['_id']);
      data.setName(map['_name']);
      print('${UserData().id} : ${UserData().name}');
      return true;
    } else {
      print('empty');
      return false;
    }
  }
}
