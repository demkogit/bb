import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'ProductItem.dart';

class DataModel {
  DataModel(this._context, this._controller, this._product);
  TextEditingController _controller;
  ProductItem _product;
  BuildContext _context;

  TextEditingController get controller => _controller;
  ProductItem get product => _product;
  BuildContext get context => _context;
}

// class DataModelBloc {
//   DataModel dataModel;

//   static final DataModelBloc _singleton = DataModelBloc._internal();
//   factory DataModelBloc() => _singleton;

//   final _dataController = StreamController<DataModel>();
//   Sink<DataModel> get dataController => _dataController.sink;

//   final _dataSubject = BehaviorSubject<DataModel>();
//   Stream<DataModel> get dataSubject => _dataSubject.stream;

//   DataModelBloc._internal() {
//     _dataController.stream.listen(_actionHandle);
//   }

//   _actionHandle(DataModel dataModel) {
//     //dataModel = dataModel;
//     _dataSubject.add(dataModel);
//   }

//   void dispose() {
//     this._dataController.close();
//   }
// }

class DataModelBloc {
  DataModel dataModel;

  StreamController<DataModel> _dataModelController = StreamController();
  Stream<DataModel> get dataModelStream => _dataModelController.stream;

  void updateDataModel(DataModel dataModel){
    this._dataModelController.sink.add(dataModel);
  }

  void dispose() {
    this._dataModelController.close();
  }
}
