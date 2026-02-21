import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
  }) : super(
    id: id,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required String accessToken,
    String? refreshToken,
    required int expiresIn,
  }) : super(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
  );

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int,
    );
  }
}