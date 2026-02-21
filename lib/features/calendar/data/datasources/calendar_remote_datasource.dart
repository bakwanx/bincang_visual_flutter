import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/scheduled_meeting_model.dart';

abstract class CalendarRemoteDataSource {
  Future<ScheduledMeetingModel> scheduleMeeting({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required List<String> attendees,
  });

  Future<List<ScheduledMeetingModel>> getUpcomingMeetings();
  Future<void> cancelMeeting(String eventId);
}

class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  final ApiClient apiClient;

  CalendarRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ScheduledMeetingModel> scheduleMeeting({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required List<String> attendees,
  }) async {
    try {
      final response = await apiClient.post(
        '/api/calendar/schedule',
        data: {
          'title': title,
          'description': description,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'attendees': attendees,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return ScheduledMeetingModel.fromJson({
          ...data['event'],
          'joinUrl': data['joinUrl'],
        });
      } else {
        throw ServerException('Failed to schedule meeting');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ScheduledMeetingModel>> getUpcomingMeetings() async {
    try {
      final response = await apiClient.get('/api/calendar/upcoming');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        return data
            .map((json) => ScheduledMeetingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException('Failed to get meetings');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> cancelMeeting(String eventId) async {
    try {
      final response = await apiClient.delete('/api/calendar/$eventId');

      if (response.statusCode != 200) {
        throw ServerException('Failed to cancel meeting');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}