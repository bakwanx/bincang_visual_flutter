import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<UserAnalyticsModel> getUserAnalytics();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient apiClient;

  AnalyticsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserAnalyticsModel> getUserAnalytics() async {
    try {
      final response = await apiClient.get('/analytics/user');

      if (response.statusCode == 200) {
        return UserAnalyticsModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Failed to get analytics');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}