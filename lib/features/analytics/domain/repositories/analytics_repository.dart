import 'package:either_dart/either.dart';

import '../../../../core/error/failures.dart';
import '../entities/analytics_entities.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, UserAnalytics>> getUserAnalytics();
}