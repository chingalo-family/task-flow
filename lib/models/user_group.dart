import 'package:task_manager/models/user_group_member.dart';

class UserGroup {
  late String id;
  late String name;
  late String createdBy;

  late List<UserGroupMember> groupMembers;

  UserGroup({
    required this.name,
    required this.id,
    this.createdBy = '',
    this.groupMembers = const [],
  }) {
    createdBy = createdBy != '' ? createdBy : '';
  }

  String get groupMemberCount => groupMembers.length > 1
      ? '${groupMembers.length} members'
      : '${groupMembers.length} memmber';

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdBy'] = createdBy;
    return data;
  }

  UserGroup.fromMap(Map mapData) {
    id = mapData['id'];
    name = mapData['name'];
    createdBy = mapData['createdBy'];
  }

  factory UserGroup.fromJson(
    dynamic json,
  ) {
    dynamic createdBy = json['createdBy'];
    return UserGroup(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      createdBy: createdBy['username'] ?? '',
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
