import 'dart:async';

import 'package:bincang_visual_flutter/core/usecase/usecase.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:bincang_visual_flutter/infrastructure/webrtc_service.dart';
import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';
import 'package:bincang_visual_flutter/utils/log/print_debug_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/usecases/create_room.dart';
import '../../domain/usecases/get_ice_servers.dart';
import '../../domain/usecases/get_room.dart';
import '../../domain/usecases/join_room.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  final CreateRoom createRoomUseCase;
  final JoinRoom joinRoom;
  final GetRoom getRoom;
  final GetIceServers getIceServers;
  final WebRTCService webrtcService;
  final WebSocketService websocketService;
  final SharedPreferences sharedPreferences;

  StreamSubscription? _signalSubscription;
  StreamSubscription? _remoteStreamSubscription;
  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _iceCandidateSubscription;

  final String _localUserId = const Uuid().v4();
  String _localDisplayName = "";

  StreamSubscription? _screenShareStreamSubscription;

  MeetingCubit({
    required this.createRoomUseCase,
    required this.joinRoom,
    required this.getIceServers,
    required this.webrtcService,
    required this.websocketService,
    required this.sharedPreferences,
    required this.getRoom,
  }) : super(MeetingInitial());

  Future<void> createRoom() async {
    emit(const MeetingLoading(message: 'Creating room...'));

    final result = await createRoomUseCase(
      CreateRoomParams(
        name: 'New Meeting',
        maxParticipants: 100,
        settings: const RoomSettings(),
      ),
    );

    result.fold(
      (failure) => emit(MeetingError(failure.message)),
      (room) => emit(
        MeetingRoomCreated(
          roomId: room.id,
          joinUrl:
              room.joinUrl ?? 'https://bincang-visual.cloud/room/${room.id}',
        ),
      ),
    );
  }

  Future<void> validateRoom({
    required String roomId,
  }) async {
    try {
      emit(const MeetingLoading(message: 'Joining meeting...'));

      final roomResult = await joinRoom(JoinRoomParams(roomId: roomId));

      roomResult.fold(
        (failure) => throw Exception(failure.message), (room) => emit(RoomValidated(room: room)),
      );
    } catch (e) {
      emit(MeetingError('Failed to join meeting: ${e.toString()}'));
    }
  }

  Future<void> joinMeeting({
    required String roomId,
    required String displayName,
  }) async {
    try {
      emit(const MeetingLoading(message: 'Joining meeting...'));

      final roomResult = await joinRoom(JoinRoomParams(roomId: roomId));
      Room? roomInfo;

      roomResult.fold(
        (failure) => throw Exception(failure.message),
        (room) => roomInfo = room,
      );

      final iceResult = await getIceServers(NoParams());
      RoomConfig? config;

      iceResult.fold(
        (failure) => throw Exception(failure.message),
        (c) => config = c,
      );

      if (config == null) {
        throw Exception('Failed to get ICE servers');
      }

      emit(const MeetingLoading(message: 'Initializing media...'));
      final localStream = await webrtcService.initializeLocalMedia();

      emit(const MeetingLoading(message: 'Connecting to server...'));
      _localDisplayName = displayName;

      await websocketService.connect(
        roomId: roomId,
        userId: _localUserId,
        displayName: displayName,
      );
      webrtcService.setLocalUserId(_localUserId);
      webrtcService.onBrowserStopShare = () {
        printDebugLog(
          tag: 'MeetingCubit',
          message: 'Browser stop button clicked',
        );
        _handleBrowserStopShare();
      };

      _setupSignalingListener(config!);
      _setupRemoteStreamListener();
      _setupConnectionStateListener();
      _setupIceCandidateListener();
      _setupScreenShareListener();

      emit(
        MeetingJoined(
          roomId: roomId,
          localUserId: _localUserId,
          localStream: localStream,
          remoteStreams: const {},
          participants: [],
          chatMessages: [],
          roomInfo: roomInfo,
        ),
      );

      printDebugLog(
        tag: 'MeetingCubit',
        message: 'Successfully joined meeting: $roomId',
      );
    } catch (e) {
      emit(MeetingError('Failed to join meeting: ${e.toString()}'));
    }
  }

  void _setupSignalingListener(RoomConfig config) {
    _signalSubscription?.cancel();
    _signalSubscription = websocketService.messages.listen((message) {
      _handleSignalingMessage(message, config);
    });
  }

  void _setupRemoteStreamListener() {
    _remoteStreamSubscription?.cancel();
    _remoteStreamSubscription = webrtcService.remoteStreams.listen((streams) {
      final state = this.state;
      if (state is MeetingJoined) {
        emit(state.copyWith(remoteStreams: streams));
      }
    });
  }

  void _setupConnectionStateListener() {
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = webrtcService.iceConnectionStates.listen((
      states,
    ) {
      states.forEach((peerId, state) {
        printDebugLog(
          tag: 'MeetingCubit',
          message: 'Peer $peerId connection state: $state',
        );

        if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          printDebugLog(
            tag: 'MeetingCubit',
            message: 'Peer $peerId connection failed',
          );
        }
      });
    });
  }

  void _setupIceCandidateListener() {
    _iceCandidateSubscription?.cancel();
    _iceCandidateSubscription = webrtcService.iceCandidates.listen((
      candidates,
    ) {
      candidates.forEach((peerId, candidate) {
        _sendIceCandidate(peerId, candidate);
      });
    });
  }

  void _setupScreenShareListener() {
    _screenShareStreamSubscription?.cancel();
    _screenShareStreamSubscription = webrtcService.screenShareStreams.listen((
      streams,
    ) {
      final state = this.state;
      if (state is MeetingJoined) {
        emit(state.copyWith(screenShareStreams: streams));
      }
    });
  }

  Future<void> _handleSignalingMessage(
    SignalMessage message,
    RoomConfig config,
  ) async {
    printDebugLog(
      tag: 'MeetingCubit',
      message: 'Received signal: ${message.type} from ${message.from}',
    );

    switch (message.type) {
      case SignalType.peerJoined:
        await _handlePeerJoined(message, config);
        break;

      case SignalType.offer:
        await _handleOffer(message, config);
        break;

      case SignalType.answer:
        await _handleAnswer(message);
        break;

      case SignalType.screenShare:
        _handleScreenShare(message);
        break;

      case SignalType.screenShareError:
        _handleScreenShareError(message);
        break;

      case SignalType.ice:
        await _handleIceCandidate(message);
        break;

      case SignalType.peerLeft:
        await _handlePeerLeft(message);
        break;

      case SignalType.chat:
        _handleChatMessage(message);
        break;

      case SignalType.mediaState:
        _handleMediaStateChange(message);
        break;

      default:
        printDebugLog(
          tag: 'MeetingCubit',
          message: 'Unhandled signal type: ${message.type}',
        );
    }
  }

  Future<void> _handlePeerJoined(
    SignalMessage message,
    RoomConfig config,
  ) async {
    final peerId = message.from; // userId from
    printDebugLog(tag: 'MeetingCubit', message: ' Peer joined: $peerId');

    _updateParticipantsList(message);

    await webrtcService.establishedPeerConnection(peerId, config);

    final offer = await webrtcService.createOffer(peerId);

    websocketService.send(
      SignalMessage(
        type: SignalType.offer,
        from: _localUserId,
        to: peerId,
        roomId: message.roomId,
        data: {
          'sdp': offer.sdp,
          'type': offer.type,
          'displayName': _localDisplayName,
        },
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _handleOffer(SignalMessage message, RoomConfig config) async {
    final peerId = message.from; // userId from
    final displayName =
        message.data!['displayName'] as String? ?? 'Participant';
    final isRenegotiate = message.data!['renegotiate'] as bool? ?? false;

    printDebugLog(
      tag: 'MeetingCubit',
      message:
          'Received ${isRenegotiate ? "renegotiation" : "initial"} offer from: $peerId',
    );

    if (!isRenegotiate && message.data != null) {
      final state = this.state;
      if (state is MeetingJoined) {
        if (!state.participants.any((p) => p.userId == peerId)) {
          printDebugLog(
            tag: 'MeetingCubit',
            message: 'Adding participant from offer: $displayName',
          );

          final participant = Participant(
            userId: peerId,
            roomId: state.roomId,
            displayName: displayName,
            joinedAt: DateTime.now(),
          );

          emit(
            state.copyWith(participants: [...state.participants, participant]),
          );
        }
      }
    }

    /*
    if (isRenegotiate) {
      final state = this.state;
      if (state is MeetingJoined) {
        final wasSharing = state.participants.any(
          (p) => p.userId == peerId && p.isScreenSharing,
        );

        if (wasSharing) {
          printDebugLog(
            tag: 'MeetingCubit',
            message: 'Peer $peerId was sharing, waiting for track removal...',
          );

        }
      }
    }*/

    await webrtcService.establishedPeerConnection(peerId, config);

    final sdp = message.data!['sdp'] as String;
    final type = message.data!['type'] as String;
    await webrtcService.setRemoteDescription(
      peerId,
      RTCSessionDescription(sdp, type),
    );

    /*
    if (isRenegotiate) {
      await Future.delayed(const Duration(milliseconds: 300));

      final state = this.state;
      if (state is MeetingJoined) {
        final isStillSharing = state.participants.any(
          (p) => p.userId == peerId && p.isScreenSharing,
        );

        if (isStillSharing &&
            !webrtcService.currentScreenShares.containsKey(peerId)) {
          printDebugLog(
            tag: 'MeetingCubit',
            message: 'Detected screen share stop for $peerId, updating state',
          );

          final updatedParticipants =
              state.participants.map((p) {
                if (p.userId == peerId) {
                  return p.copyWith(isScreenSharing: false);
                }
                return p;
              }).toList();

          emit(state.copyWith(participants: updatedParticipants));
        }
      }
    }
    */

    final answer = await webrtcService.createAnswer(peerId);

    websocketService.send(
      SignalMessage(
        type: SignalType.answer,
        from: _localUserId,
        to: peerId,
        roomId: message.roomId,
        data: {'sdp': answer.sdp, 'type': answer.type},
        timestamp: DateTime.now(),
      ),
    );

    printDebugLog(tag: 'MeetingCubit', message: 'Sent answer to $peerId');
  }

  Future<void> _handleAnswer(SignalMessage message) async {
    final peerId = message.from; // userId from
    printDebugLog(
      tag: 'MeetingCubit',
      message: 'Received answer from: $peerId',
    );

    final sdp = message.data!['sdp'] as String;
    final type = message.data!['type'] as String;

    await webrtcService.setRemoteDescription(
      peerId,
      RTCSessionDescription(sdp, type),
    );
  }

  Future<void> _handleIceCandidate(SignalMessage message) async {
    final peerId = message.from; // userId from
    final candidateData = message.data!;

    final candidate = RTCIceCandidate(
      candidateData['candidate'] as String,
      candidateData['sdpMid'] as String,
      candidateData['sdpMLineIndex'] as int,
    );

    await webrtcService.addIceCandidate(peerId, candidate);
  }

  void _sendIceCandidate(String peerId, RTCIceCandidate candidate) {
    final state = this.state;
    if (state is! MeetingJoined) return;

    websocketService.send(
      SignalMessage(
        type: SignalType.ice,
        from: _localUserId,
        to: peerId,
        roomId: state.roomId,
        data: {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        },
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _handlePeerLeft(SignalMessage message) async {
    final peerId = message.from; // userId from
    printDebugLog(tag: 'MeetingCubit', message: 'Peer left: $peerId');

    await webrtcService.closePeerConnection(peerId);

    final state = this.state;
    if (state is MeetingJoined) {
      final userId = message.data?['userId'] as String?;
      final updatedStreams = Map<String, MediaStream>.from(state.remoteStreams);
      updatedStreams.remove(peerId);

      final updatedParticipants =
          state.participants.where((p) {
            return p.userId != userId;
          }).toList();

      emit(
        state.copyWith(
          remoteStreams: updatedStreams,
          participants: updatedParticipants,
        ),
      );
    }
  }

  void _handleChatMessage(SignalMessage message) {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final chatMessage = ChatMessage(
      id: const Uuid().v4(),
      roomId: state.roomId,
      userId: message.from,
      userName: message.data!['userName'] as String? ?? 'Unknown',
      message: message.data!['message'] as String,
      timestamp: message.timestamp,
      type: ChatMessageType.text,
    );

    final updatedMessages = [...state.chatMessages, chatMessage];
    emit(state.copyWith(chatMessages: updatedMessages));
  }

  void _handleMediaStateChange(SignalMessage message) {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final peerId = message.from; // userId from
    final isMuted = message.data!['isMuted'] as bool?;
    final isVideoOff = message.data!['isVideoOff'] as bool?;

    final updatedParticipants =
        state.participants.map((p) {
          if (p.userId == peerId) {
            return p.copyWith(
              isMuted: isMuted ?? p.isMuted,
              isVideoOff: isVideoOff ?? p.isVideoOff,
            );
          }
          return p;
        }).toList();

    emit(state.copyWith(participants: updatedParticipants));
  }

  void _updateParticipantsList(SignalMessage message) {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final participantData = message.data;
    if (participantData == null) {
      printDebugLog(
        tag: 'MeetingCubit',
        message: 'No participant data in peer-joined message',
      );
      return;
    }

    final userId = participantData['userId'] as String? ?? message.from;
    final displayName =
        participantData['displayName'] as String? ?? 'Participant';
    final isHost = participantData['isHost'] as bool? ?? false;

    printDebugLog(
      tag: 'MeetingCubit',
      message: 'Adding participant: $displayName (ID: $userId)',
    );

    if (state.participants.any((p) => p.userId == userId)) {
      printDebugLog(
        tag: 'MeetingCubit',
        message: 'Participant already in list, skipping',
      );
      return;
    }

    final participant = Participant(
      userId: userId,
      roomId: state.roomId,
      displayName: displayName,
      joinedAt: DateTime.now(),
      isHost: isHost,
    );

    final updatedParticipants = [...state.participants, participant];

    printDebugLog(
      tag: 'MeetingCubit',
      message:
          'Participants count: ${state.participants.length} -> ${updatedParticipants.length}',
    );

    emit(state.copyWith(participants: updatedParticipants));
  }

  Future<void> toggleMute() async {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final newMuteState = !state.isMuted;

    await webrtcService.toggleAudio(newMuteState);

    emit(state.copyWith(isMuted: newMuteState));

    websocketService.send(
      SignalMessage(
        type: SignalType.mediaState,
        from: _localUserId,
        roomId: state.roomId,
        data: {'isMuted': newMuteState},
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> toggleVideo() async {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final newVideoState = !state.isVideoOff;

    await webrtcService.toggleVideo(newVideoState);

    emit(state.copyWith(isVideoOff: newVideoState));

    websocketService.send(
      SignalMessage(
        type: SignalType.mediaState,
        from: _localUserId,
        roomId: state.roomId,
        data: {'isVideoOff': newVideoState},
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> switchCamera() async {
    await webrtcService.switchCamera();
  }

  Future<void> startScreenShare() async {
    final state = this.state;
    if (state is! MeetingJoined) return;

    try {
      final offers = await webrtcService.startScreenShare();

      for (var entry in offers.entries) {
        final peerId = entry.key;
        final offer = entry.value;

        websocketService.send(
          SignalMessage(
            type: SignalType.offer,
            from: _localUserId,
            to: peerId,
            roomId: state.roomId,
            data: {
              'sdp': offer.sdp,
              'type': offer.type,
              'displayName': _localDisplayName,
              'renegotiate': true,
            },
            timestamp: DateTime.now(),
          ),
        );

        printDebugLog(
          tag: 'MeetingCubit',
          message: 'Sent renegotiation offer to $peerId',
        );
      }

      emit(state.copyWith(isScreenSharing: true));

      websocketService.send(
        SignalMessage(
          type: SignalType.screenShare,
          from: _localUserId,
          roomId: state.roomId,
          data: {'isSharing': true},
          timestamp: DateTime.now(),
        ),
      );

      printDebugLog(tag: 'MeetingCubit', message: 'Screen share started');
    } catch (e) {
      printDebugLog(
        tag: 'MeetingCubit',
        message: 'Failed to start screen share: $e',
      );
    }
  }

  void _handleScreenShareError(SignalMessage message) {
    final error = message.data?['error'] as String? ?? 'Screen share failed';

    printDebugLog(tag: 'MeetingCubit', message: 'Screen share error: $error');

    final state = this.state;
    if (state is MeetingJoined) {
      emit(state.copyWith(isScreenSharing: false));
    }

    emit(MeetingError(error));
  }

  void _handleScreenShare(SignalMessage message) {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final peerId = message.from;
    final isSharing = message.data?['isSharing'] as bool? ?? false;

    printDebugLog(
      tag: 'MeetingCubit',
      message: 'Screen share from $peerId: $isSharing',
    );

    if (!isSharing) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (webrtcService.currentScreenShares.containsKey(peerId)) {
          printDebugLog(
            tag: 'MeetingCubit',
            message: 'Screen share still present, forcing removal',
          );
          webrtcService.removeScreenShareStream(peerId);
        }
      });
    }

    final updatedParticipants =
        state.participants.map((p) {
          if (p.userId == peerId) {
            return p.copyWith(isScreenSharing: isSharing);
          }
          return p;
        }).toList();

    emit(state.copyWith(participants: updatedParticipants));
  }

  Future<void> stopScreenShare() async {
    final state = this.state;
    if (state is! MeetingJoined) return;

    final offers = await webrtcService.stopScreenShare();

    for (var entry in offers.entries) {
      final peerId = entry.key;
      final offer = entry.value;

      websocketService.send(
        SignalMessage(
          type: SignalType.offer,
          from: _localUserId,
          to: peerId,
          roomId: state.roomId,
          data: {
            'sdp': offer.sdp,
            'type': offer.type,
            'displayName': _localDisplayName,
            'renegotiate': true,
          },
          timestamp: DateTime.now(),
        ),
      );

      printDebugLog(
        tag: 'MeetingCubit',
        message: 'Sent renegotiation offer (stop) to $peerId',
      );
    }

    emit(state.copyWith(isScreenSharing: false));

    websocketService.send(
      SignalMessage(
        type: SignalType.screenShare,
        from: _localUserId,
        roomId: state.roomId,
        data: {'isSharing': false},
        timestamp: DateTime.now(),
      ),
    );

    printDebugLog(tag: 'MeetingCubit', message: 'Screen share stopped');
  }

  void sendChatMessage(String message) {
    final state = this.state;
    if (state is! MeetingJoined) return;

    websocketService.send(
      SignalMessage(
        type: SignalType.chat,
        from: _localUserId,
        roomId: state.roomId,
        data: {'message': message, 'userName': _localDisplayName},
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> leaveMeeting() async {
    final state = this.state;
    if (state is! MeetingJoined) return;

    websocketService.send(
      SignalMessage(
        type: SignalType.leave,
        from: _localUserId,
        roomId: state.roomId,
        timestamp: DateTime.now(),
      ),
    );

    await _cleanup();

    emit(const MeetingEnded());
  }

  Future<void> _cleanup() async {
    await _signalSubscription?.cancel();
    await _remoteStreamSubscription?.cancel();
    await _connectionStateSubscription?.cancel();
    await _iceCandidateSubscription?.cancel();
    await _screenShareStreamSubscription?.cancel();

    _screenShareStreamSubscription = null;

    websocketService.disconnect();
    await webrtcService.closeAllConnections();
    await webrtcService.stopLocalMedia();
  }

  void _handleBrowserStopShare() {
    final state = this.state;
    if (state is! MeetingJoined) return;

    printDebugLog(
      tag: 'MeetingCubit',
      message: 'Handling browser stop share button',
    );

    emit(state.copyWith(isScreenSharing: false));

    websocketService.send(
      SignalMessage(
        type: SignalType.screenShare,
        from: _localUserId,
        roomId: state.roomId,
        data: {'isSharing': false},
        timestamp: DateTime.now(),
      ),
    );

    printDebugLog(
      tag: 'MeetingCubit',
      message: 'Screen share stopped via browser button',
    );
  }

  @override
  Future<void> close() async {
    await _cleanup();
    return super.close();
  }
}
