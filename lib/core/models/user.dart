class User {
  final String id; // api user id as string
  String username;
  String? fullName;
  String? password;
  String? email;
  String? phoneNumber;
  bool isLogin;

  User({
    required this.id,
    required this.username,
    this.fullName,
    this.password,
    this.email,
    this.phoneNumber,
    this.isLogin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullName: json['name'] ?? json['displayName'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'name': fullName,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
  };

  @override
  String toString() {
    return 'User{id: $id, username: $username, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, isLogin: $isLogin}';
  }
}
