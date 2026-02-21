import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required String id,
    required String roomId,
    required String userId,
    required String userName,
    required String message,
    required DateTime timestamp,
    ChatMessageType type = ChatMessageType.text,
  }) : super(
    id: id,
    roomId: roomId,
    userId: userId,
    userName: userName,
    message: message,
    timestamp: timestamp,
    type: type,
  );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: _parseMessageType(json['type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'userName': userName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }

  static ChatMessageType _parseMessageType(String type) {
    switch (type) {
      case 'text':
        return ChatMessageType.text;
      case 'file':
        return ChatMessageType.file;
      case 'system':
        return ChatMessageType.system;
      default:
        return ChatMessageType.text;
    }
  }
}