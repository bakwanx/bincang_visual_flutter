import 'package:equatable/equatable.dart';


class Room extends Equatable {
  final String id;
  final String name;
  final String hostId;
  final DateTime createdAt;
  final int maxParticipants;
  final bool isRecording;
  final String? joinUrl;
  final RoomSettings settings;

  const Room({
    required this.id,
    required this.name,
    required this.hostId,
    required this.createdAt,
    required this.maxParticipants,
    required this.isRecording,
    required this.settings,
    this.joinUrl
  });

  @override
  List<Object?> get props => [
    id,
    name,
    hostId,
    createdAt,
    maxParticipants,
    isRecording,
    settings,
    joinUrl,
  ];

  Room copyWith({
    String? id,
    String? name,
    String? hostId,
    DateTime? createdAt,
    int? maxParticipants,
    bool? isRecording,
    RoomSettings? settings,
    String? joinUrl,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      createdAt: createdAt ?? this.createdAt,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isRecording: isRecording ?? this.isRecording,
      settings: settings ?? this.settings,
        joinUrl: joinUrl ?? this.joinUrl,
    );
  }
}


class RoomSettings extends Equatable {
  final bool allowScreenShare;
  final bool allowChat;
  final bool waitingRoom;
  final bool recordingEnabled;
  final int maxDuration;

  const RoomSettings({
    this.allowScreenShare = true,
    this.allowChat = true,
    this.waitingRoom = false,
    this.recordingEnabled = true,
    this.maxDuration = 60,
  });

  @override
  List<Object?> get props => [
    allowScreenShare,
    allowChat,
    waitingRoom,
    recordingEnabled,
    maxDuration,
  ];

  RoomSettings copyWith({
    bool? allowScreenShare,
    bool? allowChat,
    bool? waitingRoom,
    bool? recordingEnabled,
    int? maxDuration,
  }) {
    return RoomSettings(
      allowScreenShare: allowScreenShare ?? this.allowScreenShare,
      allowChat: allowChat ?? this.allowChat,
      waitingRoom: waitingRoom ?? this.waitingRoom,
      recordingEnabled: recordingEnabled ?? this.recordingEnabled,
      maxDuration: maxDuration ?? this.maxDuration,
    );
  }
}


class Participant extends Equatable {
  final String userId;
  final String roomId;
  final String displayName;
  final DateTime joinedAt;
  final bool isHost;
  final bool isMuted;
  final bool isVideoOff;
  final bool isScreenSharing;

  const Participant({
    required this.userId,
    required this.roomId,
    required this.displayName,
    required this.joinedAt,
    this.isHost = false,
    this.isMuted = false,
    this.isVideoOff = false,
    this.isScreenSharing = false,
  });

  @override
  List<Object?> get props => [
    userId,
    roomId,
    displayName,
    joinedAt,
    isHost,
    isMuted,
    isVideoOff,
    isScreenSharing,
  ];

  Participant copyWith({
    String? userId,
    String? roomId,
    String? displayName,
    DateTime? joinedAt,
    bool? isHost,
    bool? isMuted,
    bool? isVideoOff,
    bool? isScreenSharing,
  }) {
    return Participant(
      userId: userId ?? this.userId,
      roomId: roomId ?? this.roomId,
      displayName: displayName ?? this.displayName,
      joinedAt: joinedAt ?? this.joinedAt,
      isHost: isHost ?? this.isHost,
      isMuted: isMuted ?? this.isMuted,
      isVideoOff: isVideoOff ?? this.isVideoOff,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
    );
  }
}


class ChatMessage extends Equatable {
  final String id;
  final String roomId;
  final String userId;
  final String userName;
  final String message;
  final DateTime timestamp;
  final ChatMessageType type;

  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.type = ChatMessageType.text,
  });

  @override
  List<Object?> get props => [
    id,
    roomId,
    userId,
    userName,
    message,
    timestamp,
    type,
  ];
}

enum ChatMessageType {
  text,
  file,
  system,
}


class SignalMessage extends Equatable {
  final SignalType type;
  final String from;
  final String? to;
  final String roomId;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  const SignalMessage({
    required this.type,
    required this.from,
    this.to,
    required this.roomId,
    this.data,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [type, from, to, roomId, data, timestamp];
}

enum SignalType {
  offer,
  answer,
  ice,
  join,
  ping,
  pong,
  leave,
  chat,
  mediaState,
  screenShare,
  screenShareError,
  peerJoined,
  peerLeft,
}


class IceServer extends Equatable {
  final List<String> urls;
  final String? username;
  final String? credential;

  const IceServer({
    required this.urls,
    this.username,
    this.credential,
  });

  @override
  List<Object?> get props => [urls, username, credential];
}


class RoomConfig extends Equatable {
  final List<IceServer> iceServers;
  final int maxBitrate;
  final List<String> codecPreferences;

  const RoomConfig({
    required this.iceServers,
    this.maxBitrate = 2500000,
    this.codecPreferences = const [],
  });

  @override
  List<Object?> get props => [iceServers, maxBitrate, codecPreferences];
}


class Recording extends Equatable {
  final String id;
  final String roomId;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration;
  final String? fileUrl;
  final RecordingStatus status;

  const Recording({
    required this.id,
    required this.roomId,
    required this.startTime,
    this.endTime,
    this.duration = 0,
    this.fileUrl,
    this.status = RecordingStatus.recording,
  });

  @override
  List<Object?> get props => [
    id,
    roomId,
    startTime,
    endTime,
    duration,
    fileUrl,
    status,
  ];
}

enum RecordingStatus {
  recording,
  processing,
  completed,
  failed,
}