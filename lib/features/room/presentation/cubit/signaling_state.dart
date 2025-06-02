part of 'signaling_cubit.dart';


@freezed
sealed class SignalingState with _$SignalingState{
  SignalingState._();

  factory SignalingState({
    @Default(0) int currentBanner,
    UserModel? user,
    @Default('') String roomId,
    @Default({}) Map<String, List<IceCandidatePayloadModel>> iceCandidates,
    @Default({}) Map<String, MediaStream> remoteStream,
    @Default({}) Map<String, RTCPeerConnection> peerConnection,
    @Default('') String toastMessage,
    MediaStream? localStream,
  }) = _SignalingState;
}
