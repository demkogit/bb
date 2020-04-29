class UserData {
  int _id;
  String _name;

  static final UserData _singleton = UserData._internal();
  factory UserData() => _singleton;
  UserData._internal();

  UserData.fromJson(Map<String, dynamic> json) {
    _name = json['_name'];
    _id = json['_id'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_name': _name,
        '_id': _id,
      };

  String get name => _name;
  int get id => _id;

  void setId(int id) {
    _id = id;
  }

  void setName(String name) {
    _name = name;
  }
}
