import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> signInWithGoogle();
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.googleSignIn,
  });

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw ServerException('Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;


      final response = await apiClient.post(
        '/api/auth/google/signin',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('Failed to authenticate');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/api/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Failed to get user');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}