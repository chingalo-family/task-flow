import 'dart:convert';

import 'package:task_manager/core/constants/app_contant.dart';

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
    userGroups = userGroups ?? [];
  }

  dynamic toDhis2Json() {
    String ous = '{"id" : "${AppContant.defaultUserOrganisationUnit}"}';
    List<String>? nameList = fullName.split(' ');
    String firstName = nameList.first;
    String surname = nameList.length == 1
        ? nameList.first
        : nameList.where((String name) => name != firstName).join('');
    String userGroupsString = userGroups!
        .map((String groupId) => '{"id": "$groupId"}')
        .toList()
        .join(',');
    String userCredentials =
        '{"username":"$username", "password":"$password","userInfo":{"id":"$id"},"userRoles":[{"id": "${AppContant.defaultUserRole}"}]}';
    return json.decode(
        '{"id":"$id","firstName":"$firstName","surname":"$surname","phoneNumber":"$phoneNumber","email":"$email","userGroups":[$userGroupsString],"userCredentials":$userCredentials,"organisationUnits":[$ous],"dataViewOrganisationUnits":[$ous],"teiSearchOrganisationUnits":[$ous] }');
  }

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fullName'] = fullName;
    data['password'] = password;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['isLogin'] = isLogin ? '1' : '0';
    return data;
  }

  User.fromMap(Map mapData) {
    id = mapData['id'];
    username = mapData['username'];
    fullName = mapData['fullName'];
    password = mapData['password'];
    email = mapData['email'];
    phoneNumber = mapData['phoneNumber'];
    isLogin = mapData['isLogin'] == '1';
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
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      userGroups: userGroups,
      isLogin: true,
    );
  }

  static List<String> _getUserGroups(
    dynamic json,
  ) {
    List userGroupsList = json['userGroups'] as List<dynamic>;
    return userGroupsList
        .map((dynamic userGroup) {
          String id = userGroup['id'] ?? '';
          return id;
        })
        .toList()
        .toSet()
        .toList()
        .where((id) => id.isNotEmpty)
        .toList();
  }

  @override
  String toString() {
    return 'User <$id : $username>';
  }
}
