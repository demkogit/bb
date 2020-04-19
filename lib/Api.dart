import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bb/ProductItem.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'PostBody.dart';

const baseUrl = 'https://axiantest.dynvpn.ru:8443/testBlackBrio/hs/api/v1';

class Api {
  static Future getShopList() async {
    var url = baseUrl + '/shopList';

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.persistentConnection = false;

    request.headers.set('Content-type', 'application/json');
    request.headers.set('Token', '3ac61eab-d819-4d4f-b024-6584187d8437');

    HttpClientResponse response = await request.close();
    print("started");
    return await response.transform(utf8.decoder).join();
  }

  static Future getCatalogList(int idGroup) async {
    var url = baseUrl + '/catalogList' + '?idGroup=' + idGroup.toString();
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.getUrl(Uri.parse(url));

    request.headers.set('Content-type', 'application/json');
    request.headers.set('Token', '3ac61eab-d819-4d4f-b024-6584187d8437');

    HttpClientResponse response = await request.close();
    print("started");
    return await response.transform(utf8.decoder).join();
  }

  static Future getCatalogGroupList(int idShop) async {
    var url = baseUrl + '/catalogGroupList?idShop=' + idShop.toString();
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.getUrl(Uri.parse(url));

    request.headers.set('Content-type', 'application/json');
    request.headers.set('Token', '3ac61eab-d819-4d4f-b024-6584187d8437');

    HttpClientResponse response = await request.close();
    print("started");
    return await response.transform(utf8.decoder).join();
  }

  static Future registration(PostBody body) async {
    var url = baseUrl + '/registration';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('Content-type', 'application/json');
    request.headers.set('Token', '3ac61eab-d819-4d4f-b024-6584187d8437');

    print(body.toJson());
    request.write(body.toJson());
    HttpClientResponse response = await request.close();

    return await response.transform(utf8.decoder).join();
  }

  static Future authorization(PostBody body) async {
    var url = baseUrl + '/authorization';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('Content-type', 'application/json');
    request.headers.set('Token', '3ac61eab-d819-4d4f-b024-6584187d8437');

    request.write(body.toJson());
    HttpClientResponse response = await request.close();

    return await response.transform(utf8.decoder).join();
  }

  static String makeData(String login, String token, String pass) {
    String credentials = login + token + pass;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    return encoded;
  }

  static Future order(Map<String, dynamic> body) async {
    var url = baseUrl + '/orderCreate';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('Content-type', 'application/json');
    request.headers.set('Token', '3ac61eab-d819-4d4f-b024-6584187d8437');

    //print(json.encode(body));
    //(body['productList'] as List<ProductItem>);
    request.write(json.encode(body));
    HttpClientResponse response = await request.close();

    return await response.transform(utf8.decoder).join();
  }
}
