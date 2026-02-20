import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';

class ParticipantModel extends Participant {
  const ParticipantModel({
    required String userId,
    required String roomId,
    required String displayName,
    required DateTime joinedAt,
    bool isHost = false,
    bool isMuted = false,
    bool isVideoOff = false,
    bool isScreenSharing = false,
  }) : super(
         userId: userId,
         roomId: roomId,
         displayName: displayName,
         joinedAt: joinedAt,
         isHost: isHost,
         isMuted: isMuted,
         isVideoOff: isVideoOff,
         isScreenSharing: isScreenSharing,
       );

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      userId: json['userId'] as String,
      roomId: json['roomId'] as String,
      displayName: json['displayName'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      isHost: json['isHost'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      isVideoOff: json['isVideoOff'] as bool? ?? false,
      isScreenSharing: json['isScreenShare'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'roomId': roomId,
      'displayName': displayName,
      'joinedAt': joinedAt.toIso8601String(),
      'isHost': isHost,
      'isMuted': isMuted,
      'isVideoOff': isVideoOff,
      'isScreenShare': isScreenSharing,
    };
  }
}
