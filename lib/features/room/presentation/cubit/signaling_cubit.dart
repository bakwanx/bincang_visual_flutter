import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:bincang_visual_flutter/features/room/data/models/leave_payload_model.dart';
import 'package:bincang_visual_flutter/features/room/domain/usecase/signaling_usecase.dart';
import 'package:bincang_visual_flutter/utils/theme/app_toast.dart';

import '../../../../utils/old_signaling/signaling.dart';
import '../../data/models/ice_candidate_payload_model.dart';
import '../../data/models/request_offering_model.dart';
import '../../data/models/sdp_payload_model.dart';
import '../../data/models/websocket_message_model.dart';

part 'signaling_state.dart';

part 'signaling_cubit.freezed.dart';

class SignalingCubit extends Cubit<SignalingState> {
  final SignalingUseCase signalingUseCase;

  SignalingCubit({required this.signalingUseCase}) : super(SignalingState());

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': ['turn:bincang-visual.cloud:3478?transport=udp'],
        'username': 'bincang-visual.cloud',
        'credential': 'bakwanx123!',
      },
      {
        'urls': ['turns:bincang-visual.cloud:5349?transport=tcp'],
        'username': 'bincang-visual.cloud',
        'credential': 'bakwanx123!',
      },
      {
        'urls': ['stun:202.10.42.100:3478', 'stun:stun.flashdance.cx:3478'],
      },
    ],
  };

  // MediaStream? localStream;

  void init({required UserModel user, required String roomId}) {
    emit(state.copyWith(user: user, roomId: roomId));
    initLocalMedia();
    initListen();
    requestOffer();
  }

  void initListen() {
    signalingUseCase.onMessage.listen((message) {
      switch (message.type) {
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
        // colect candidates
        case 'leave':
          final leavePayloadModel = LeavePayloadModel.fromJson(message.payload);
          debugPrint('==== receive candidate: ${leavePayloadModel.toJson()}');
          AppToast.showToast(
            message: "${leavePayloadModel.user.username} has left the meeting",
          );
          removeRemoteUserConnection(leavePayloadModel);
          break;
        // colect candidates
      }
    });
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
    RTCPeerConnection pc = await createPeerConnection(configuration);

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


    RTCPeerConnection pc = await createPeerConnection(configuration);

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
      state.copyWith(peerConnection: {...state.peerConnection, remoteUserId: pc}),
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
        payload: SdpPayloadModel(sdp: answer.sdp!, typeSdp: answer.type!, userFrom: state.user!,
          userTarget: sdpPayload.userFrom,),
      ),
    );
  }

  Future<void> setRemoteSdp(UserModel userModel, SdpPayloadModel sdpPayload) async {
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

  void leave() {
    signalingUseCase.sendMessage(
      WebSocketMessageModel(
        type: "leave",
        payload: LeavePayloadModel(
          roomId: state.roomId,
          user: state.user!,
        ),
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
    localStream?.getTracks().forEach((t) => t.stop());
    localStream?.dispose();
    localStream = null;
    emit(
      state.copyWith(
        localStream: localStream,
        remoteStream: {},
        peerConnection: {},
        iceCandidates: {}
      ),
    );

    signalingUseCase.dispose();
  }

  Future<void> reconnect() async {
    for (final pc in state.peerConnection.values) {
      pc.close();
    }
    emit(
      state.copyWith(
          peerConnection: {},
          iceCandidates: {}
      ),
    );

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

  Future<void> initLocalMedia() async {
    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'},
    };
    final localStream = await navigator.mediaDevices.getUserMedia(
      mediaConstraints,
    );
    emit(state.copyWith(localStream: localStream));
  }

  void registerPeerConnectionListeners(String username) {
    final pc = state.peerConnection[username];
    final localStream = state.localStream;
    pc?.onIceGatheringState = (RTCIceGatheringState state) {
      debugPrint('ICE gathering state changed: $state');
    };

    pc?.onConnectionState = (RTCPeerConnectionState state) {
      if (localStream != null && state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected || state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        reconnect();
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
}
