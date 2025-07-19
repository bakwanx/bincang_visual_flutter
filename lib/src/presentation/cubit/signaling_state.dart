part of 'signaling_cubit.dart';


@freezed
sealed class SignalingState with _$SignalingState{
  SignalingState._();

  factory SignalingState({
    @Default(0) int currentBanner,
    @Default({}) Map<String, UserModel> user,
    @Default('') String roomId,
    @Default([]) List<ChatPayloadModel> chat,
    @Default({}) Map<String, List<IceCandidatePayloadModel>> iceCandidates,
    @Default({}) Map<String, MediaStreamModel> remoteStream,
    @Default({}) Map<String, RtcPeerConnectionModel> peerConnection,
    @Default('') String toastMessage,
    @Default(false) bool isCasting,
    CoturnConfigurationModel? coturnConfiguration,
    @Default({}) Map<String, MediaStream> localStream,
  }) = _SignalingState;
}
