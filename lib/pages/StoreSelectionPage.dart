import 'dart:io';

import 'package:bb/device.dart';
import 'package:bb/LocalDataBase/DBManager.dart';
import 'package:bb/PostBody.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

import '../Api.dart';

class StoreSelectionPage extends StatefulWidget {
  @override
  _StoreSelectionPageState createState() => _StoreSelectionPageState();
}

class _StoreSelectionPageState extends State<StoreSelectionPage> {
  String _selectedLocation = 'Сидим Дома';
  final DBManager dbManager = new DBManager();
  String _name = "DemKo";

  Device device = new Device();

  @override
  void initState() {
    device.initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
          DropdownButton<String>(
            value: _selectedLocation,
            items: <String>['Сидим Дома'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (newVal) {
              _selectedLocation = newVal;
              this.setState(() {});
            },
          ),
          FlatButton(
              color: Colors.green,
              child: Text("Продолжить"),
              onPressed: () {
                print(_selectedLocation);
                dbManager
                    .insertLocation({"loc": _selectedLocation}).then((value) {
                  Navigator.pushReplacementNamed(context, '/Login');
                });
              }),
          FlatButton(
            color: Colors.blue,
            child: Text('GetShopList'),
            onPressed: () => Api.registration(PostBody(
                    data: "",
                    name: _name,
                    uid: device.deviceData['uid'],
                    deviceName: device.deviceData['deviceName'],
                    system: device.deviceData['system'],
                    systemVersion: device.deviceData['systemVersion']))
                .then((value) => print(value)),
          )
        ])));
  }
}
