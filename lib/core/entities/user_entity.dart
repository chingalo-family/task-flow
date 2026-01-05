import 'package:objectbox/objectbox.dart';

@Entity()
class UserEntity {
  int id; // ObjectBox id

  String apiUserId; // API user id
  String username;
  String? fullName;
  String? password;
  String? email;
  String? phoneNumber;
  bool isLogin;
  DateTime createdAt;
  DateTime updatedAt;

  UserEntity({
    this.id = 0,
    required this.apiUserId,
    required this.username,
    this.fullName,
    this.password,
    this.email,
    this.phoneNumber,
    this.isLogin = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
