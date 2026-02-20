import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
}