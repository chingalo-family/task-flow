class User {
  final String id; // api user id as string
  String username;
  String? fullName;
  String? password;
  String? email;
  String? phoneNumber;

  User({
    required this.id,
    required this.username,
    this.fullName,
    this.password,
    this.email,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullName: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, fullName: $fullName, email: $email, phoneNumber: $phoneNumber}';
  }
}
