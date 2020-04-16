import 'dart:convert';

class ProductItem {
  String _name;
  String _unit = 'шт.';
  int _price;
  int _count = 0;
  int _id;

  ProductItem.fromJson(Map json) {
    _name = json['_name'];
    _price = json['_price'];
    _unit = json['_unit'];
    _id = json['_id'];
    _count = json['_count'];
  }

  ProductItem(this._name, this._price, this._id);

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_name': _name,
        '_unit': _unit,
        '_price': _price,
        '_count': _count,
        '_id': _id,
      };

  String get name => _name;
  String get unit => _unit;
  int get price => _price;
  int get count => _count;
  int get id => _id;

  void increaseCount() => _count++;
  void decreaseCount() => _count > 0 ? _count-- : null;
}
