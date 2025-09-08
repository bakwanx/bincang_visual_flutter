part of 'signaling_cubit.dart';


@freezed
sealed class SignalingState with _$SignalingState{
  SignalingState._();

  factory SignalingState({
    UserEntity? user,
    @Default('') String roomId,
    @Default([]) List<ChatPayloadEntity> chat,
    @Default({}) Map<String, List<IceCandidatePayloadEntity>> iceCandidates,
    @Default({}) Map<String, MediaStream> remoteStream,
    @Default({}) Map<String, RTCPeerConnection> peerConnection,
    @Default('') String toastMessage,
    CoturnConfigurationEntity? coturnConfiguration,
    MediaStream? localStream,
  }) = _SignalingState;
}
