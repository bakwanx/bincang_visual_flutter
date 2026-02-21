// import 'package:either_dart/either.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../core/error/exceptions.dart';
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/user.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../datasources/auth_remote_datasource.dart';
// import '../models/user_model.dart';
//
// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final SharedPreferences sharedPreferences;
//
//   AuthRepositoryImpl({
//     required this.remoteDataSource,
//     required this.sharedPreferences,
//   });
//
//   @override
//   Future<Either<Failure, User>> signInWithGoogle() async {
//     try {
//       final result = await remoteDataSource.signInWithGoogle();
//
//       final token = result['token'] as String;
//       await sharedPreferences.setString('auth_token', token);
//
//       final user = UserModel.fromJson(result['user'] as Map<String, dynamic>);
//
//       return Right(user);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, User>> getCurrentUser() async {
//     try {
//       final user = await remoteDataSource.getCurrentUser();
//       return Right(user);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
//
//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await remoteDataSource.signOut();
//       await sharedPreferences.remove('auth_token');
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }
// }
