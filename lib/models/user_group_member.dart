class UserGroupMember {
  late String id;
  late String groupId;
  late String userId;
  late String username;
  late String fullName;

  UserGroupMember({
    required this.groupId,
    required this.userId,
    this.username = '',
    this.fullName = '',
  }) {
    id = '${groupId}_$userId';
  }

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['groupId'] = groupId;
    data['userId'] = userId;
    data['username'] = username;
    data['fullName'] = fullName;
    return data;
  }

  UserGroupMember.fromMap(Map mapData) {
    id = mapData['id'];
    groupId = mapData['groupId'];
    userId = mapData['userId'];
    username = mapData['username'];
    fullName = mapData['fullName'];
  }

  @override
  String toString() {
    return 'Group Member <$id $username> ';
  }
}
