class UserData {
  int _id;
  String _name;

  static final UserData _singleton = UserData._internal();
  factory UserData() => _singleton;
  UserData._internal();

  String get name => _name;
  int get id => _id;

  void setId(int id) {
    _id = id;
  }

  void setName(String name) {
    _name = name;
  }
}
