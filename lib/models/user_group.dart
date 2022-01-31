import 'package:task_manager/models/user_group_member.dart';

class UserGroup {
  late String id;
  late String name;
  late String description;
  late List<UserGroupMember> groupMembers;

  UserGroup({
    required this.name,
    required this.id,
    this.description = '',
    this.groupMembers = const [],
  }) {
    this.description = this.description != '' ? this.description : '';
  }

  String get groupMemberCount => '${groupMembers.length}';

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }

  UserGroup.fromMap(Map mapData) {
    this.id = mapData['id'];
    this.name = mapData['name'];
    this.description = mapData['description'];
  }

  factory UserGroup.fromJson(
    dynamic json,
  ) {
    return UserGroup(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      description: '',
      groupMembers: _getUserGroupMembers(json),
    );
  }

  static List<UserGroupMember> _getUserGroupMembers(
    dynamic json,
  ) {
    List userGroupsList = json['users'] as List<dynamic>;
    return userGroupsList
        .map(
          (dynamic user) => UserGroupMember(
            groupId: json['id'] ?? '',
            userId: user['id'] ?? '',
            username: user['username'] ?? '',
            fullName: user['name'] ?? '',
          ),
        )
        .toList();
  }

  @override
  String toString() {
    return 'Group <$id : $name>';
  }
}
