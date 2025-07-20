import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'call_cubit.freezed.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallState());

  Future<void> init(bool micEnabled, bool cameraEnabled) async {
    final localRenderer = RTCVideoRenderer();
    localRenderer.initialize();

    emit(
      state.copyWith(
        localRenderer: localRenderer,
        micEnabled: micEnabled,
        cameraEnabled: cameraEnabled,
      ),
    );
  }

  void setLocalStream(MediaStream? localStream) {
    if (localStream != null && state.localRenderer?.srcObject != localStream) {
      final localRenderer = state.localRenderer;
      localRenderer?.srcObject = localStream;
      emit(state.copyWith(localRenderer: localRenderer));
    }
  }

  void setRemoteStream(String key, MediaStream? remoteStream) {
    if (!state.remoteRenderer.containsKey(key)) {
      final renderer = RTCVideoRenderer();
      renderer.initialize().then((_) {
        renderer.srcObject = remoteStream;
        emit(state.copyWith(
            remoteRenderer: {
              ...state.remoteRenderer, key: renderer
            }
        ));
      });
    } else {
      // Update existing renderer with the new stream
      final renderer = state.remoteRenderer[key]!;
      renderer.srcObject = remoteStream;
      emit(state.copyWith(
          remoteRenderer: {
            ...state.remoteRenderer, key: renderer
          }
      ));
    }
  }

  void removeRemoteStream(String key) {
    final remoteRenderer = Map<String, RTCVideoRenderer>.from(
        state.remoteRenderer);

    remoteRenderer[key]?.srcObject = null;
    remoteRenderer.remove(key);
    emit(state.copyWith(
        remoteRenderer: remoteRenderer
    ));
  }

  void setMic(MediaStream localStream) {
    for (var track in localStream.getAudioTracks()) {
      track.enabled = !track.enabled;
    }
    emit(state.copyWith(micEnabled: !state.micEnabled));
  }

  void setCamera(MediaStream localStream) {
    for (var track in localStream.getVideoTracks()) {
      track.enabled = !track.enabled;
    }
    emit(state.copyWith(cameraEnabled: !state.cameraEnabled));
  }

  void setVisibleChat() {
    emit(state.copyWith(
        isChatVisible: !state.isChatVisible
    ));
  }

  leave() {
    final remoteRenderers = state.remoteRenderer;
    final localRenderer = state.localRenderer;

    // dispose
    localRenderer?.srcObject = null;
    localRenderer?.dispose();
    for (final remoteRenderer in remoteRenderers.values) {
      remoteRenderer.dispose();
    }

    emit(
      state.copyWith(
        localRenderer: localRenderer,
        remoteRenderer: remoteRenderers,
      ),
    );
  }


  void axisXY(double x, double y) {
    emit(state.copyWith(
      x: state.x + x,
      y: state.y + y,
    ));
  }
}
