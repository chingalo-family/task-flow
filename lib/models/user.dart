class User {
  late String id;
  late String username;
  late String fullName;
  late String? password;
  late String? email;
  late String? gender;
  late String? phoneNumber;
  late List<String>? userGroups;
  late bool isLogin;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.fullName,
    required this.password,
    this.phoneNumber,
    this.gender,
    this.userGroups,
    this.isLogin = false,
  }) {
    this.userGroups = this.userGroups ?? [];
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['fullName'] = this.fullName;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['isLogin'] = this.isLogin ? '1' : '0';
    return data;
  }

  User.fromMap(Map mapData) {
    this.id = mapData['id'];
    this.username = mapData['username'];
    this.fullName = mapData['fullName'];
    this.password = mapData['password'];
    this.email = mapData['email'];
    this.phoneNumber = mapData['phoneNumber'];
    this.isLogin = mapData['isLogin'] == '1';
  }

  factory User.fromJson(
    dynamic json,
    String username,
    String password,
  ) {
    List<String> userGroups = _getUserGroups(json);
    return User(
      fullName: json['name'],
      id: json['id'],
      password: password,
      username: username,
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userGroups: userGroups,
      isLogin: true,
    );
  }

  static List<String> _getUserGroups(
    dynamic json,
  ) {
    List userGroupsList = json['userGroups'] as List<dynamic>;
    return userGroupsList
        .map((dynamic userGroup) => userGroup['id'] ?? '')
        .toList()
        .toSet()
        .toList()
        .where((id) => '$id'.isNotEmpty)
        .toList() as List<String>;
  }

  @override
  String toString() {
    return 'User <$id : $username>';
  }
}
