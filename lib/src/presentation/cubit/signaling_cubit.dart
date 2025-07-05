import 'package:bincang_visual_flutter/src/data/models/chat_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/leave_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/ping_payload_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/call_entity.dart';
import 'package:bincang_visual_flutter/src/domain/usecase/signaling_usecase.dart';
import 'package:bincang_visual_flutter/utils/theme/app_toast.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../infrastructure/websocket_service.dart';
import '../../data/models/ice_candidate_payload_model.dart';
import '../../data/models/request_offering_model.dart';
import '../../data/models/sdp_payload_model.dart';
import '../../data/models/websocket_message_model.dart';

part 'signaling_cubit.freezed.dart';
part 'signaling_state.dart';

class SignalingCubit extends Cubit<SignalingState> {
  final SignalingUseCase signalingUseCase;
  final WebSocketService webSocketService;

  SignalingCubit({
    required this.signalingUseCase,
    required this.webSocketService,
  }) : super(SignalingState());

  void init({required CallEntity callEntity}) {
    emit(
      state.copyWith(
        user: callEntity.user,
        roomId: callEntity.roomId,
        coturnConfiguration: callEntity.configurationModel,
      ),
    );
    initWebsocket(callEntity.roomId);
    initLocalMedia(
      cameraEnabled: callEntity.cameraEnabled,
      micEnabled: callEntity.micEnabled,
    );
  }

  initWebsocket(String roomId) {
    webSocketService.connect(userId: state.user!.id, roomId: roomId).then((_) {
      initListen();
      requestOffer();
    });
  }

  void initListen() {
    signalingUseCase.onMessage.listen((message) {
      switch (message.type) {
        case "pingpong":
          final requestOfferring = PingPongPayloadModel.fromJson(
            message.payload,
          );
          // // send offer
          debugPrint('==== receive a ping: ${requestOfferring.toJson()}');
          _pingPong();
          break;
        case "join":
          final requestOfferring = RequestOfferingModel.fromJson(
            message.payload,
          );
          // // send offer
          debugPrint('==== receive a request join: ${requestOfferring.toJson()}');
          offerSdp(requestOfferring);
          break;
        case "offer":
          // // answer the offer
          final sdpPayload = SdpPayloadModel.fromJson(message.payload);
          debugPrint('==== receive offer: ${sdpPayload.toJson()}');
          sendAnswerSdp(sdpPayload);
          setRemoteSdp(sdpPayload.userFrom, sdpPayload);
          break;
        case "answer":
          final sdpPayload = SdpPayloadModel.fromJson(message.payload);
          debugPrint('==== receive answer: ${sdpPayload.toJson()}');
          // // set answer
          setRemoteSdp(sdpPayload.userFrom, sdpPayload);
          break;
        case "candidate":
          final iceCandidate = IceCandidatePayloadModel.fromJson(
            message.payload,
          );
          debugPrint('==== receive candidate: ${iceCandidate.toJson()}');
          collectIceCandidates(iceCandidate);
          break;
        case 'chat':
          final chatPayloadModel = ChatPayloadModel.fromJson(message.payload);
          debugPrint('==== receive chat message: ${chatPayloadModel.toJson()}');
          receiveChat(chatPayloadModel);
          break;
        case 'leave':
          final leavePayloadModel = LeavePayloadModel.fromJson(message.payload);
          debugPrint('==== receive leave message: ${leavePayloadModel.toJson()}');
          AppToast.showToast(
            message: "${leavePayloadModel.user.username} has left the meeting",
          );
          removeRemoteUserConnection(leavePayloadModel);
          break;
      }
    });
  }

  void _pingPong() {
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "pingpong",
        payload: PingPongPayloadModel(message: "pong"),
      ),
    );
  }

  Future<void> requestOffer() async {
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "join",
        payload: RequestOfferingModel(
          roomId: state.roomId,
          userRequest: state.user!,
        ),
      ),
    );
  }

  Future<void> offerSdp(RequestOfferingModel req) async {
    RTCPeerConnection pc = await createPeerConnection(
      state.coturnConfiguration!.toJson(),
    );

    pc.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      final stream = event.streams.isNotEmpty ? event.streams[0] : null;
      if (stream != null &&
          !state.remoteStream.containsKey(req.userRequest.id)) {
        emit(
          state.copyWith(
            remoteStream: {...state.remoteStream, req.userRequest.id: stream},
          ),
        );
      }
    };

    emit(
      state.copyWith(
        peerConnection: {...state.peerConnection, req.userRequest.id: pc},
      ),
    );

    state.localStream?.getTracks().forEach((track) {
      pc.addTrack(track, state.localStream!);
    });

    RTCSessionDescription offer = await pc.createOffer();
    await pc.setLocalDescription(offer);

    registerPeerConnectionListeners(req.userRequest.id);

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      _iceCandidate(
        candidate: candidate,
        userFrom: state.user!,
        userTarget: req.userRequest,
      );
    };

    // send offer
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "offer",
        payload: SdpPayloadModel(
          sdp: offer.sdp!,
          typeSdp: offer.type!,
          userFrom: state.user!,
          userTarget: req.userRequest,
        ),
      ),
    );
  }

  Future<void> sendAnswerSdp(SdpPayloadModel sdpPayload) async {
    // final sdpPayload = SdpPayloadModel.fromJson(webRtcMessageModel.payload);
    final remoteUser = sdpPayload.userFrom;
    final remoteUserId = remoteUser.id;

    RTCPeerConnection pc = await createPeerConnection(
      state.coturnConfiguration!.toJson(),
    );

    pc.onTrack = (RTCTrackEvent event) {
      debugPrint('Got remote track: ${event.streams[0]}');
      final stream = event.streams.isNotEmpty ? event.streams[0] : null;
      if (stream != null && !state.remoteStream.containsKey(remoteUserId)) {
        emit(
          state.copyWith(
            remoteStream: {...state.remoteStream, remoteUserId: stream},
          ),
        );
      }
    };

    emit(
      state.copyWith(
        peerConnection: {...state.peerConnection, remoteUserId: pc},
      ),
    );

    state.localStream?.getTracks().forEach((track) {
      pc.addTrack(track, state.localStream!);
    });

    await pc.setRemoteDescription(
      RTCSessionDescription(sdpPayload.sdp, sdpPayload.typeSdp),
    );

    RTCSessionDescription answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);

    registerPeerConnectionListeners(remoteUserId ?? '');

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      _iceCandidate(
        candidate: candidate,
        userTarget: remoteUser,
        userFrom: state.user!,
      );
    };

    // send answer
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "answer",
        payload: SdpPayloadModel(
          sdp: answer.sdp!,
          typeSdp: answer.type!,
          userFrom: state.user!,
          userTarget: sdpPayload.userFrom,
        ),
      ),
    );
  }

  Future<void> setRemoteSdp(
    UserModel userModel,
    SdpPayloadModel sdpPayload,
  ) async {
    final description = RTCSessionDescription(
      sdpPayload.sdp,
      sdpPayload.typeSdp,
    );
    await state.peerConnection[userModel.id]?.setRemoteDescription(description);

    // await peerConnection[username]?.setRemoteDescription(description);
  }

  void _iceCandidate({
    required UserModel userTarget,
    required UserModel userFrom,
    required RTCIceCandidate candidate,
  }) {
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "candidate",
        payload: IceCandidatePayloadModel(
          candidate: candidate.candidate!,
          sdpMLineIndex: candidate.sdpMLineIndex!,
          sdpMid: candidate.sdpMid!,
          userTarget: userTarget,
          userFrom: userFrom,
        ),
      ),
    );
  }

  Future<void> collectIceCandidates(
    IceCandidatePayloadModel iceCandidate,
  ) async {
    final fromUser = iceCandidate.userFrom.id;
    // final iceCandidate = IceCandidatePayloadModel.fromJson(
    //   webRtcMessageModel.payload,
    // );

    // state.iceCandidates.putIfAbsent(fromUser, () => []);
    final newListCandidates = state.iceCandidates[fromUser] ?? [];
    newListCandidates.add(iceCandidate);
    final peerAddCandidate = state.peerConnection[fromUser];
    if (peerAddCandidate != null) {
      peerAddCandidate.addCandidate(
        RTCIceCandidate(
          iceCandidate.candidate,
          iceCandidate.sdpMid,
          iceCandidate.sdpMLineIndex,
        ),
      );
      emit(
        state.copyWith(
          peerConnection: {...state.peerConnection, fromUser: peerAddCandidate},
        ),
      );
    }

    emit(
      state.copyWith(
        iceCandidates: {...state.iceCandidates, fromUser: newListCandidates},
      ),
    );
  }

  void removeTrack(MediaStreamTrack track) {
    try {
      track.stop();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void leave() {
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "leave",
        payload: LeavePayloadModel(roomId: state.roomId, user: state.user!),
      ),
    );
    for (final pc in state.peerConnection.values) {
      pc.close();
    }

    for (final stream in state.remoteStream.values) {
      stream.getTracks().forEach((t) => t.stop());
    }

    // Clean up local stream
    var localStream = state.localStream;
    localStream?.getTracks().forEach((t) async => await t.stop());
    localStream?.dispose();
    localStream = null;
    emit(
      state.copyWith(
        localStream: localStream,
        remoteStream: {},
        peerConnection: {},
        iceCandidates: {},
      ),
    );

    signalingUseCase.dispose();
  }

  Future<void> reconnect() async {
    for (final pc in state.peerConnection.values) {
      pc.close();
    }
    emit(state.copyWith(peerConnection: {}, iceCandidates: {}));

    requestOffer();
  }

  void removeRemoteUserConnection(LeavePayloadModel leavePayloadModel) {
    final remoteUser = leavePayloadModel.user.id;
    final remoteStreams = Map<String, MediaStream>.from(state.remoteStream);
    final iceCandidates = Map<String, List<IceCandidatePayloadModel>>.from(
      state.iceCandidates,
    );
    final peerConnections = Map<String, RTCPeerConnection>.from(
      state.peerConnection,
    );

    peerConnections[remoteUser]?.close();
    remoteStreams[remoteUser]?.getTracks().forEach((t) => t.stop());

    remoteStreams.remove(leavePayloadModel.user.id);
    iceCandidates.remove(leavePayloadModel.user.id);
    peerConnections.remove(leavePayloadModel.user.id);
    emit(
      state.copyWith(
        remoteStream: remoteStreams,
        iceCandidates: iceCandidates,
        peerConnection: peerConnections,
      ),
    );
  }

  Future<void> initLocalMedia({
    required bool micEnabled,
    required bool cameraEnabled,
  }) async {
    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'},
    };
    final localStream = await navigator.mediaDevices.getUserMedia(
      mediaConstraints,
    );
    if (!micEnabled) {
      for (var track in localStream.getAudioTracks()) {
        track.enabled = !track.enabled;
      }
    }
    if (!cameraEnabled) {
      for (var track in localStream.getVideoTracks()) {
        track.enabled = !track.enabled;
      }
    }
    emit(state.copyWith(localStream: localStream));
  }

  Future<void> getDisplayMedia({bool video = true, bool audio = false}) async {
    Map<String, dynamic> constraints = {'audio': audio, 'video': video};
    final displayStream = await navigator.mediaDevices.getDisplayMedia(
      constraints,
    );
  }

  void registerPeerConnectionListeners(String username) {
    final pc = state.peerConnection[username];
    final localStream = state.localStream;
    pc?.onIceGatheringState = (RTCIceGatheringState state) {
      debugPrint('ICE gathering state changed: $state');
    };

    pc?.onConnectionState = (RTCPeerConnectionState state) {
      if (localStream != null &&
              state ==
                  RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        // reconnect();
        // localStream.getTracks().forEach((track) => track.stop());
      }
      debugPrint('Connection state change: $state');
    };

    pc?.onSignalingState = (RTCSignalingState state) {
      debugPrint('Signaling state change: $state');
    };

    pc?.onIceGatheringState = (RTCIceGatheringState state) {
      debugPrint('ICE connection state change: $state');
    };

    // pc?.onAddStream = (MediaStream stream) {
    //   print("Add remote stream");
    //   onAddRemoteStream[username]?.call(stream);
    //   remoteStream[username] = stream;
    // };
  }

  Future<void> sendChat(String message) async {
    final chat = ChatPayloadModel(
      roomId: state.roomId,
      userFrom: state.user!,
      message: message,
    );
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "chat",
        payload: chat,
      ),
    );
    emit(state.copyWith(
        chat: [...state.chat, chat]
    ));
  }

  Future<void> receiveChat(ChatPayloadModel chat) async {
    emit(state.copyWith(
      chat: [...state.chat, chat]
    ));
  }
}
