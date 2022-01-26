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
    this.id = '${groupId}_$userId';
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = this.id;
    data['groupId'] = this.groupId;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['fullName'] = this.fullName;
    return data;
  }

  UserGroupMember.fromMap(Map mapData) {
    this.id = mapData['id'];
    this.groupId = mapData['groupId'];
    this.userId = mapData['userId'];
    this.username = mapData['username'];
    this.fullName = mapData['fullName'];
  }

  @override
  String toString() {
    return 'Group Member <$id $username> ';
  }
}
