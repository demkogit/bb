import 'dart:convert';

import 'package:bb/LocalDataBase/DBManager.dart';
import 'package:bb/ProductCounter.dart';
import 'package:bb/ProductItem.dart';
import 'package:bb/cart_bloc.dart';
import 'package:bb/pages/LoginPage.dart';
import 'package:bb/pages/RegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'App.dart';
import 'pages/StoreSelectionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductCounter>.value(value: ProductCounter())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/Home': (BuildContext context) => App(),
          '/Login': (BuildContext context) => LoginPage(),
          '/Registration': (BuildContext context) => RegistrationPage(),
        },
        home: App(),
      ), //App(),
    );
  }
}
