class UserModel {
  String id;
  String username;
  bool isCastingScreen;

  UserModel({
    required this.id,
    required this.username,
    required this.isCastingScreen,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
    id: json['id'],
    username: json['username'],
    isCastingScreen: json["isCastingScreen"],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'isCastingScreen': isCastingScreen,
  };
}
