part of 'call_cubit.dart';

@freezed
sealed class CallState with _$CallState{
  CallState._();

  factory CallState({
    @Default(0) double x,
    @Default(0) double y,
    @Default({}) Map<String, RTCVideoRenderer> remoteRenderer,
    RTCVideoRenderer? localRenderer,
    @Default(false) bool isChatVisible,
    @Default(true) bool micEnabled,
    @Default(true) bool cameraEnabled,
  }) = _CallState;
}

