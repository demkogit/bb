class ProductItem {
  String _name;
  String _unit = 'шт.';
  String _imageURL;
  int _price;
  int _count = 0;
  int _id;

  ProductItem.fromJson(Map json) {
    _name = json['_name'];
    _price = json['_price'];
    _imageURL = json['_imageURL'];
    _unit = json['_unit'];
    _id = json['_id'];
    _count = json['_count'];
  }

  ProductItem(this._name, this._price, this._id, this._imageURL);

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_name': _name,
        '_unit': _unit,
        '_imageURL': _imageURL,
        '_price': _price,
        '_count': _count,
        '_id': _id,
      };

  Map<String, dynamic> toPOSTJson() => <String, dynamic>{
        'price': _price,
        'count': _count,
        'id': _id,
      };

  String get name => _name;
  String get unit => _unit;
  String get imageURL => _imageURL;
  int get price => _price;
  int get count => _count;
  int get id => _id;

  void increaseCount() => _count++;
  void decreaseCount() => _count > 0 ? _count-- : null;
}
