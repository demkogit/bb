import 'package:flutter/material.dart';

class PostBody {
  String _data;
  String _name;
  String _uid;
  String _deviceName;
  String _system;
  String _systemVersion;

  PostBody(
      {@required String data,
      @required String name,
      @required String uid,
      @required String deviceName,
      @required String system,
      @required String systemVersion})
      : assert(data != null),
       
        assert(uid != null),
        assert(deviceName != null),
        assert(system != null),
        assert(systemVersion != null) {
    this._data = data;
    this._name = name;
    this._uid = uid;
    this._deviceName = deviceName;
    this._system = system;
    this._systemVersion = systemVersion;
  }

  String toJson() {
    return '\{\"data\":\"$_data\", \"name\":\"$_name\", ' +
        '\"device\":\{\"UID\":\"$_uid\", \"name\":\"$_deviceName\", ' +
        '\"system\":\"$_system\", \"systemVersion\":\"$_systemVersion\"\}\}';
  }
}
