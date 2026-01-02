class User {
  final String id; // api user id as string
  String username;
  String? fullName;
  String? password;
  String? email;
  String? phoneNumber;
  List<String>? userGroups;
  List<String>? userOrgUnitIds;
  bool isLogin;

  User({
    required this.id,
    required this.username,
    this.fullName,
    this.password,
    this.email,
    this.phoneNumber,
    this.userGroups,
    this.userOrgUnitIds,
    this.isLogin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullName: json['displayName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      userGroups: (json['userGroups'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      userOrgUnitIds: (json['organisationUnits'] as List?)
          ?.map((e) => e['id'].toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'fullName': fullName,
    'email': email,
    'phone': phoneNumber,
    'userGroups': userGroups,
    'organisationUnits': userOrgUnitIds,
  };
}
