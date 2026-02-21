import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';

class RoomModel extends Room {
  const RoomModel({
    String? joinUrl,
    required String id,
    required String name,
    required String hostId,
    required DateTime createdAt,
    required int maxParticipants,
    required bool isRecording,
    required RoomSettings settings,

  }) : super(
         id: id,
         name: name,
         hostId: hostId,
         createdAt: createdAt,
         maxParticipants: maxParticipants,
         isRecording: isRecording,
         settings: settings,
         joinUrl: joinUrl,
       );

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      hostId: json['hostId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      maxParticipants: json['maxParticipants'] as int,
      isRecording: json['isRecording'] as bool,
      settings: RoomSettingsModel.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
      joinUrl: json['joinUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hostId': hostId,
      'createdAt': createdAt.toIso8601String(),
      'maxParticipants': maxParticipants,
      'isRecording': isRecording,
      'settings': (settings as RoomSettingsModel).toJson(),
    };
  }

  factory RoomModel.fromEntity(Room room) {
    return RoomModel(
      id: room.id,
      name: room.name,
      hostId: room.hostId,
      createdAt: room.createdAt,
      maxParticipants: room.maxParticipants,
      isRecording: room.isRecording,
      settings: room.settings,
    );
  }
}

class RoomSettingsModel extends RoomSettings {
  const RoomSettingsModel({
    bool allowScreenShare = true,
    bool allowChat = true,
    bool waitingRoom = false,
    bool recordingEnabled = true,
    int maxDuration = 60,
  }) : super(
         allowScreenShare: allowScreenShare,
         allowChat: allowChat,
         waitingRoom: waitingRoom,
         recordingEnabled: recordingEnabled,
         maxDuration: maxDuration,
       );

  factory RoomSettingsModel.fromJson(Map<String, dynamic> json) {
    return RoomSettingsModel(
      allowScreenShare: json['allowScreenShare'] as bool? ?? true,
      allowChat: json['allowChat'] as bool? ?? true,
      waitingRoom: json['waitingRoom'] as bool? ?? false,
      recordingEnabled: json['recordingEnabled'] as bool? ?? true,
      maxDuration: json['maxDuration'] as int? ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowScreenShare': allowScreenShare,
      'allowChat': allowChat,
      'waitingRoom': waitingRoom,
      'recordingEnabled': recordingEnabled,
      'maxDuration': maxDuration,
    };
  }
}
