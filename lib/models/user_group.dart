class UserGroup {
  late String id;
  late String name;
  late String description;

  UserGroup({
    required this.name,
    required this.id,
    this.description = '',
  }) {
    this.description = this.description != '' ? this.description : '';
  }

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

  @override
  String toString() {
    return 'Group <$id : $name>';
  }
}
