part of 'meeting_cubit.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object?> get props => [];
}

class MeetingInitial extends MeetingState {}

class MeetingLoading extends MeetingState {
  final String? message;

  const MeetingLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class MeetingJoined extends MeetingState {
  final String roomId;
  final String localUserId;
  final MediaStream? localStream;
  final Map<String, MediaStream> remoteStreams;
  final Map<String, MediaStream> screenShareStreams;
  final List<Participant> participants;
  final List<ChatMessage> chatMessages;
  final bool isMuted;
  final bool isVideoOff;
  final bool isScreenSharing;
  final bool isRecording;
  final String? recordingId;
  final Room? roomInfo;

  const MeetingJoined({
    required this.roomId,
    required this.localUserId,
    this.localStream,
    required this.remoteStreams,
    this.screenShareStreams = const {},
    required this.participants,
    required this.chatMessages,
    this.isMuted = false,
    this.isVideoOff = false,
    this.isScreenSharing = false,
    this.isRecording = false,
    this.recordingId,
    this.roomInfo,
  });

  MeetingJoined copyWith({
    String? roomId,
    String? localUserId,
    MediaStream? localStream,
    Map<String, MediaStream>? remoteStreams,
    Map<String, MediaStream>? screenShareStreams,
    List<Participant>? participants,
    List<ChatMessage>? chatMessages,
    bool? isMuted,
    bool? isVideoOff,
    bool? isScreenSharing,
    bool? isRecording,
    String? recordingId,
    Room? roomInfo,
  }) {
    return MeetingJoined(
      roomId: roomId ?? this.roomId,
      localUserId: localUserId ?? this.localUserId,
      localStream: localStream ?? this.localStream,
      remoteStreams: remoteStreams ?? Map.from(this.remoteStreams),
      screenShareStreams: screenShareStreams ?? Map.from(this.screenShareStreams),
      participants: participants ?? this.participants,
      chatMessages: chatMessages ?? this.chatMessages,
      isMuted: isMuted ?? this.isMuted,
      isVideoOff: isVideoOff ?? this.isVideoOff,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      isRecording: isRecording ?? this.isRecording,
      recordingId: recordingId ?? this.recordingId,
      roomInfo: roomInfo ?? this.roomInfo,
    );
  }

  @override
  List<Object?> get props => [
    roomId,
    localUserId,
    localStream,
    remoteStreams,
    screenShareStreams,
    participants,
    chatMessages,
    isMuted,
    isVideoOff,
    isScreenSharing,
    isRecording,
    recordingId,
    roomInfo,
  ];
}

class MeetingError extends MeetingState {
  final String message;

  const MeetingError(this.message);

  @override
  List<Object?> get props => [message];
}

class MeetingEnded extends MeetingState {
  final String reason;

  const MeetingEnded({this.reason = 'Meeting ended'});

  @override
  List<Object?> get props => [reason];
}

class MeetingRoomCreated extends MeetingState {
  final String roomId;
  final String joinUrl;

  const MeetingRoomCreated({
    required this.roomId,
    required this.joinUrl,
  });

  @override
  List<Object?> get props => [roomId, joinUrl];
}