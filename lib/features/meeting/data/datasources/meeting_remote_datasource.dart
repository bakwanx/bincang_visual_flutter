import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../utils/encrypt/encrypt_util.dart';
import '../models/room_model.dart';
import '../models/participant_model.dart';
import '../models/chat_message_model.dart';

abstract class MeetingRemoteDataSource {
  Future<RoomModel> createRoom({
    required String name,
    required int maxParticipants,
    required RoomSettings settings,
  });

  Future<RoomModel> getRoom(String roomId);
  Future<List<ParticipantModel>> getParticipants(String roomId);
  Future<List<ChatMessageModel>> getChatHistory(String roomId);
  Future<RoomConfig> getIceServers();
  Future<Recording> startRecording(String roomId);
  Future<void> stopRecording(String roomId, String recordingId);
}

class MeetingRemoteDataSourceImpl implements MeetingRemoteDataSource {
  final ApiClient apiClient;

  MeetingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RoomModel> createRoom({
    required String name,
    required int maxParticipants,
    required RoomSettings settings,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.rooms,
        data: {
          'name': name,
          'maxParticipants': maxParticipants,
          'settings': RoomSettingsModel(
            allowScreenShare: settings.allowScreenShare,
            allowChat: settings.allowChat,
            waitingRoom: settings.waitingRoom,
            recordingEnabled: settings.recordingEnabled,
            maxDuration: settings.maxDuration,
          ).toJson(),
        },
      );

      if (response.statusCode == 201) {
        final roomId = response.data['roomId'] as String;
        return await getRoom(roomId);
      } else {
        throw ServerException('Failed to create room');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> getRoom(String roomId) async {
    try {
      final response = await apiClient.get(ApiConstants.room(roomId));

      if (response.statusCode == 200) {
        return RoomModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Failed to get room');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ParticipantModel>> getParticipants(String roomId) async {
    try {
      final response = await apiClient.get(ApiConstants.participants(roomId));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        return data
            .map((json) => ParticipantModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException('Failed to get participants');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory(String roomId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.chatHistory(roomId),
        queryParameters: {'limit': 100},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        return data
            .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException('Failed to get chat history');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomConfig> getIceServers() async {
    try {
      final response = await apiClient.get(ApiConstants.iceServers);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final iceServersData = data['iceServers'] as List;

        final iceServers = iceServersData.map((server) {
          String? username = server['username'];
          String? credential = server['credential'];
          if(!kDebugMode) {
            if(username != null && credential != null) {
              username = EncryptUtil.decryptData(username);
              credential = EncryptUtil.decryptData(credential);
            }
          }
          return IceServer(
            urls: List<String>.from(server['urls']),
            username: username,
            credential: credential,
          );
        }).toList();

        return RoomConfig(
          iceServers: iceServers,
          maxBitrate: data['maxBitrate'] as int? ?? 2500000,
          codecPreferences: List<String>.from(data['codecPreferences'] ?? []),
        );
      } else {
        throw ServerException('Failed to get ICE servers');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Recording> startRecording(String roomId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.startRecording,
        data: {'roomId': roomId},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Recording(
          id: data['id'],
          roomId: data['roomId'],
          startTime: DateTime.parse(data['startTime']),
          status: RecordingStatus.recording,
        );
      } else {
        throw ServerException('Failed to start recording');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> stopRecording(String roomId, String recordingId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.stopRecording,
        data: {
          'roomId': roomId,
          'recordingId': recordingId,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to stop recording');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}