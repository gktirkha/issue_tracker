class UserModel {
  bool isAdmin;
  String id;
  String? token;
  String name;
  String department;
  int? assignCount;
  UserModel(
      {required this.id,
      required this.isAdmin,
      required this.token,
      required this.department,
      required this.name,
      this.assignCount});
  factory UserModel.formJson(dynamic json) {
    return UserModel(
      id: json["_id"],
      isAdmin: json["isAdmin"],
      token: json["token"],
      department: json["department"],
      name: json["name"],
      assignCount: json["assignedCount"],
    );
  }
}
