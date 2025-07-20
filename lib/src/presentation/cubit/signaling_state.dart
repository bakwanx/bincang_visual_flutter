part of 'signaling_cubit.dart';


@freezed
sealed class SignalingState with _$SignalingState{
  SignalingState._();

  factory SignalingState({
    UserModel? user,
    @Default('') String roomId,
    @Default([]) List<ChatPayloadModel> chat,
    @Default({}) Map<String, List<IceCandidatePayloadModel>> iceCandidates,
    @Default({}) Map<String, MediaStream> remoteStream,
    @Default({}) Map<String, RTCPeerConnection> peerConnection,
    @Default('') String toastMessage,
    CoturnConfigurationModel? coturnConfiguration,
    MediaStream? localStream,
  }) = _SignalingState;
}
