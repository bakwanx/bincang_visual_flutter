import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/usecases/get_user_analytics.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetUserAnalytics getUserAnalytics;

  AnalyticsCubit({required this.getUserAnalytics}) : super(AnalyticsInitial());

  Future<void> loadUserAnalytics() async {
    emit(AnalyticsLoading());

    final result = await getUserAnalytics(NoParams());

    result.fold(
          (failure) => emit(AnalyticsError(failure.message)),
          (analytics) => emit(AnalyticsLoaded(analytics)),
    );
  }

  Future<void> refresh() async {
    await loadUserAnalytics();
  }
}