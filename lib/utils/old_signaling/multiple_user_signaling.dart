// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:bincang_visual_flutter/features/room/data/models/request_offering_model.dart';
// import 'package:bincang_visual_flutter/features/room/data/models/websocket_message_model.dart';
// import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';
//
// import '../../features/room/data/models/ice_candidate_payload_model.dart';
// import '../../features/room/data/models/sdp_payload_model.dart';
//
// typedef void StreamStateCallback(MediaStream stream);
//
// class MultipleUserSignaling {
//   Map<String, dynamic> configuration = {
//     'iceServers': [
//       {
//         'urls': ['stun:stun.flashdance.cx:3478'],
//       },
//     ],
//   };
//   late WebSocketService webSocketService;
//   final Map<String, RTCPeerConnection> peerConnection = {};
//   final Map<String, MediaStream> remoteStream = {};
//   MediaStream? localStream;
//   String roomId;
//   String username;
//   final Map<String, StreamStateCallback> onAddRemoteStream = {};
//   final Map<String, List<IceCandidatePayloadModel>> iceCandidates = {};
//
//   MultipleUserSignaling({required this.roomId, required this.username}) {
//     // webSocketService = WebSocketService.initialize(
//     //   username: username,
//     //   roomId: roomId,
//     // );
//   }
//
//   Future<void> requestOffer() async {
//     final encode = jsonEncode(
//       WebSocketMessageModel(
//         type: "join",
//         payload: RequestOfferingModel(
//           roomId: roomId,
//           usernameRequest: username,
//         ),
//       ).toJson(),
//     );
//     webSocketService.send(encode);
//   }
//
//   Future<void> listenRequestOffer() async {
//     webSocketService.stream.map((message) async {
//       final decode = jsonDecode(message);
//       final data = WebSocketMessageModel.fromJson(decode);
//       switch (data.type) {
//         case "join":
//           final requestOfferring = RequestOfferingModel.fromJson(data.payload);
//           // send offer
//           debugPrint('==== receive a request join: ${data.toJson()}');
//           offerSdp(requestOfferring);
//         case "offer":
//           // answer the offer
//           debugPrint('==== receive offer: ${data.toJson()}');
//           sendAnswerSdp(data);
//         case "answer":
//           final sdpPayload = SdpPayloadModel.fromJson(data.payload);
//           debugPrint('==== receive answer: ${data.toJson()}');
//           // set answer
//           await setRemoteSdp(data.from ?? '', sdpPayload);
//         case "candidate":
//           debugPrint('==== receive candidate: ${data.toJson()}');
//           collectIceCandidates(data);
//         // colect candidates
//       }
//     });
//   }
//
//   Future<void> offerSdp(RequestOfferingModel req) async {
//     RTCPeerConnection pc = await createPeerConnection(configuration);
//     peerConnection[req.usernameRequest] = pc;
//     localStream?.getTracks().forEach((track) {
//       pc.addTrack(track, localStream!);
//     });
//     RTCSessionDescription offer = await pc.createOffer();
//     await pc.setLocalDescription(offer);
//
//     registerPeerConnectionListeners(req.usernameRequest);
//
//     pc.onIceCandidate = (RTCIceCandidate candidate) {
//       _iceCandidate(
//         candidate: candidate,
//         from: username,
//         to: req.usernameRequest,
//       );
//     };
//
//     pc.onTrack = (RTCTrackEvent event) {
//       print('Got remote track: ${event.streams[0]}');
//
//       if (!remoteStream.containsKey(req.usernameRequest)) {
//         remoteStream[req.usernameRequest] = event.streams[0];
//         onAddRemoteStream[req.usernameRequest]?.call(event.streams[0]);
//       }
//     };
//
//     // send offer
//     final encode = jsonEncode(
//       WebSocketMessageModel(
//         type: "offer",
//         from: username,
//         to: req.usernameRequest,
//         payload: SdpPayloadModel(sdp: offer.sdp!, typeSdp: offer.type!),
//       ).toJson(),
//     );
//     webSocketService.send(encode);
//   }
//
//   Future<void> sendAnswerSdp(WebSocketMessageModel webRtcMessageModel) async {
//     final sdpPayload = SdpPayloadModel.fromJson(webRtcMessageModel.payload);
//     final remoteUser = webRtcMessageModel.from ?? '';
//
//     RTCPeerConnection pc = await createPeerConnection(configuration);
//     peerConnection[remoteUser] = pc;
//     localStream?.getTracks().forEach((track) {
//       pc.addTrack(track, localStream!);
//     });
//
//     await pc.setRemoteDescription(
//       RTCSessionDescription(sdpPayload.sdp, sdpPayload.typeSdp),
//     );
//
//     RTCSessionDescription answer = await pc.createAnswer();
//     await pc.setLocalDescription(answer);
//
//     registerPeerConnectionListeners(remoteUser ?? '');
//
//     pc.onIceCandidate = (RTCIceCandidate candidate) {
//       _iceCandidate(
//         candidate: candidate,
//         to: remoteUser ?? '',
//         from: username,
//       );
//     };
//
//     pc.onTrack = (RTCTrackEvent event) {
//       debugPrint('Got remote track: ${event.streams[0]}');
//
//       if (!remoteStream.containsKey(remoteUser)) {
//         remoteStream[remoteUser] = event.streams[0];
//         onAddRemoteStream[remoteUser]?.call(event.streams[0]);
//       }
//     };
//
//     // send answer
//     final encode = jsonEncode(
//       WebSocketMessageModel(
//         type: "answer",
//         from: username,
//         to: remoteUser,
//         payload: SdpPayloadModel(sdp: answer.sdp!, typeSdp: answer.type!),
//       ).toJson(),
//     );
//     webSocketService.send(encode);
//   }
//
//   Future<void> setRemoteSdp(String username, SdpPayloadModel sdpPayload) async {
//     final description = RTCSessionDescription(
//       sdpPayload.sdp,
//       sdpPayload.typeSdp,
//     );
//     await peerConnection[username]?.setRemoteDescription(description);
//   }
//
//   void _iceCandidate({
//     required String to,
//     required String from,
//     required RTCIceCandidate candidate,
//   }) {
//     final encode = jsonEncode(
//       WebSocketMessageModel(
//         type: "candidate",
//         to: to,
//         from: from,
//         payload: IceCandidatePayloadModel(
//           candidate: candidate.candidate!,
//           sdpMLineIndex: candidate.sdpMLineIndex!,
//           sdpMid: candidate.sdpMid!,
//         ),
//       ).toJson(),
//     );
//     webSocketService.send(encode);
//   }
//
//   Future<void> collectIceCandidates(
//       WebSocketMessageModel webRtcMessageModel,
//   ) async {
//     final fromUser = webRtcMessageModel.from ?? '';
//     final iceCandidate = IceCandidatePayloadModel.fromJson(
//       webRtcMessageModel.payload,
//     );
//
//     iceCandidates.putIfAbsent(fromUser, () => []);
//     iceCandidates[fromUser]!.add(iceCandidate);
//     peerConnection[fromUser]?.addCandidate(
//       RTCIceCandidate(
//         iceCandidate.candidate,
//         iceCandidate.sdpMid,
//         iceCandidate.sdpMLineIndex,
//       ),
//     );
//   }
//
//   void leave() {
//     for (final pc in peerConnection.values) {
//       pc.close();
//     }
//     peerConnection.clear();
//
//     for (final stream in remoteStream.values) {
//       stream.getTracks().forEach((t) => t.stop());
//     }
//     remoteStream.clear();
//
//     // Clean up local stream
//     localStream?.getTracks().forEach((t) => t.stop());
//     localStream?.dispose();
//     localStream = null;
//
//     webSocketService.close();
//   }
//
//   Future<void> initLocalMedia() async {
//     final mediaConstraints = {
//       'audio': false,
//       'video': {'facingMode': 'user'},
//     };
//     localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//   }
//
//   void registerPeerConnectionListeners(String username) {
//     final pc = peerConnection[username];
//     pc?.onIceGatheringState = (RTCIceGatheringState state) {
//       print('ICE gathering state changed: $state');
//     };
//
//     pc?.onConnectionState = (RTCPeerConnectionState state) {
//       if (localStream != null &&
//           state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
//         localStream!.getTracks().forEach((track) => track.stop());
//       }
//       print('Connection state change: $state');
//     };
//
//     pc?.onSignalingState = (RTCSignalingState state) {
//       print('Signaling state change: $state');
//     };
//
//     pc?.onIceGatheringState = (RTCIceGatheringState state) {
//       print('ICE connection state change: $state');
//     };
//
//     // pc?.onAddStream = (MediaStream stream) {
//     //   print("Add remote stream");
//     //   onAddRemoteStream[username]?.call(stream);
//     //   remoteStream[username] = stream;
//     // };
//   }
// }
