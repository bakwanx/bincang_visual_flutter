import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/analytics_entities.dart';
import '../repositories/analytics_repository.dart';

class GetUserAnalytics implements UseCase<UserAnalytics, NoParams> {
  final AnalyticsRepository repository;

  GetUserAnalytics(this.repository);

  @override
  Future<Either<Failure, UserAnalytics>> call(NoParams params) async {
    return await repository.getUserAnalytics();
  }
}