import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];
}

class AuthToken extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final int expiresIn;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn];
}