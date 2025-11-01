class UserModel {
  String? id;
  String? username;

  UserModel({required this.id, required this.username});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) =>
      UserModel(id: json['id'], username: json['username']);

  Map<String, dynamic> toJson() => {'id': id, 'username': username};
}
