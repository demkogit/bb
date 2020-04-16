class Category {
  String _name;
  int _id;
  int _idParent = -1;
  List<Category> _children;
  bool _noChildren = true;

  Category(this._name, this._id, int idParent) {
    _children = new List();
    if (idParent != null) _idParent = idParent;
  }

  String get name => _name;
  int get id => _id;
  int get idParent => _idParent;
  List<Category> get children => _children;
  bool get noChildren => _noChildren;

  void addChild(Category child) {
    _noChildren = false;
    _children.add(child);
  }
}
