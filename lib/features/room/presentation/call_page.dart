import 'package:bincang_visual_flutter/features/room/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:bincang_visual_flutter/features/room/presentation/cubit/signaling_cubit.dart';
import '../../../di/dependency_injection.dart';
import '../../../utils/old_signaling/multiple_user_signaling.dart';

class CallPage extends StatelessWidget {
  final UserModel user;
  final String roomId;

  const CallPage({super.key, required this.user, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => di<SignalingCubit>()..init(user: user, roomId: roomId),
      child: CallPageUI(user: user, roomId: roomId),
    );
  }
}

class CallPageUI extends StatefulWidget {
  final UserModel user;
  final String roomId;

  const CallPageUI({required this.user, required this.roomId});

  @override
  State<CallPageUI> createState() => _CallPageUIState();
}

class _CallPageUIState extends State<CallPageUI> {
  // late MultipleUserSignaling multipleUserSignaling;

  bool micEnabled = true;
  bool cameraEnabled = true;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};

  @override
  void initState() {
    super.initState();

    init();
    // initRenderers();
    // startSignaling();
  }

  Future<void> init() async {
    await _localRenderer.initialize();
    final signalingCubit = context.read<SignalingCubit>();
    signalingCubit.stream.listen((state) {
      // Initialize local stream
      if (state.localStream != null && _localRenderer.srcObject != state.localStream) {
        _localRenderer.srcObject = state.localStream;
      }

      // Loop through the updated remote streams
      state.remoteStream.forEach((key, stream) {
        if (!_remoteRenderers.containsKey(key)) {
          final renderer = RTCVideoRenderer();
          renderer.initialize().then((_) {
            renderer.srcObject = stream;
            setState(() {
              _remoteRenderers[key] = renderer;
            });
          });
        } else {
          // Update existing renderer with the new stream
          _remoteRenderers[key]?.srcObject = stream;
        }
      });

      // Remove remote users who left
      _remoteRenderers.forEach((key, renderer) {
        if (!state.remoteStream.containsKey(key)) {
          renderer.srcObject = null;  // Clean up the stream if user leaves
          _remoteRenderers.remove(key);
        }
      });
    });
  }

  // Future<void> initRenderers() async {
  //   await _localRenderer.initialize();
  // }

  // Future<void> startSignaling() async {
  //   multipleUserSignaling = MultipleUserSignaling(
  //     roomId: widget.roomId,
  //     username: widget.username,
  //   );
  //   await multipleUserSignaling.initLocalMedia();
  //   _localRenderer.srcObject = multipleUserSignaling.localStream;
  //
  //   multipleUserSignaling.onAddRemoteStream[widget.username] = (stream) {
  //     return;
  //   };
  //
  //   multipleUserSignaling.onAddRemoteStream.forEach((user, callback) {
  //     debugPrint("Already has callback for $user");
  //   });
  //
  //   multipleUserSignaling.onAddRemoteStream['hanza'] = (MediaStream stream) {
  //     if (!_remoteRenderers.containsKey('hanza')) {
  //       final renderer = RTCVideoRenderer();
  //       renderer.initialize().then((_) {
  //         renderer.srcObject = stream;
  //         setState(() {
  //           _remoteRenderers['hanza'] = renderer;
  //         });
  //       });
  //     }
  //   };
  //
  //   multipleUserSignaling.listenRequestOffer();
  //   multipleUserSignaling.requestOffer();
  //   setState(() {});
  // }

  // Future<void> start() async {
  //   multipleUserSignaling.requestOffer();
  //   multipleUserSignaling.listenRequestOffer();
  //   await multipleUserSignaling.initLocalMedia();
  //   _localRenderer.srcObject = multipleUserSignaling.localStream;
  //   setState(() {});
  // }

  void toggleMic() {
    if (context.read<SignalingCubit>().state.localStream != null) {
      for (var track
          in context
              .read<SignalingCubit>()
              .state
              .localStream!
              .getAudioTracks()) {
        track.enabled = !track.enabled;
      }
      setState(() {
        micEnabled = !micEnabled;
      });
    }
  }

  void toggleCamera() {
    if (context.read<SignalingCubit>().state.localStream != null) {
      for (var track
          in context
              .read<SignalingCubit>()
              .state
              .localStream!
              .getVideoTracks()) {
        track.enabled = !track.enabled;
      }
      setState(() {
        cameraEnabled = !cameraEnabled;
      });
    }
  }

  void leaveRoom() {
    context.read<SignalingCubit>().leave();
    for (final renderer in _remoteRenderers.values) {
      renderer.srcObject = null;
      renderer.dispose();
    }
    _remoteRenderers.clear();
    _localRenderer.dispose();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('user: ${widget.user.username}')),
      body: BlocListener<SignalingCubit, SignalingState>(
        listenWhen:
            (previous, current) =>
                previous.remoteStream != current.remoteStream,
        listener: (context, state) {
          // Loop through the updated remote streams
          state.remoteStream.forEach((key, stream) {
            if (!_remoteRenderers.containsKey(key)) {
              final renderer = RTCVideoRenderer();
              renderer.initialize().then((_) {
                renderer.srcObject = stream;
                setState(() {
                  _remoteRenderers[key] = renderer;
                });
              });
            } else {
              // Update existing renderer with the new stream
              _remoteRenderers[key]?.srcObject = stream;
            }
          });

          // Remove remote users who left
          _remoteRenderers.forEach((key, renderer) {
            if (!state.remoteStream.containsKey(key)) {
              renderer.srcObject = null;  // Clean up the stream if user leaves
              _remoteRenderers.remove(key);
            }
          });
        },
        child: BlocBuilder<SignalingCubit, SignalingState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Remote Videos
                // Align(
                //   alignment: Alignment.center,
                //   child: GridView.builder(
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2,
                //     ),
                //     itemCount: state.remoteStream.length,
                //     itemBuilder: (context, index) {
                //       String key = state.remoteStream.keys.elementAt(index);
                //
                //       MediaStream stream = state.remoteStream[key]!;
                //       RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
                //       remoteRenderer.initialize().then((_) {
                //         remoteRenderer.srcObject = stream;
                //       });
                //
                //       return RTCVideoView(remoteRenderer);
                //     },
                //   ),
                // ),
                GridView.count(
                  crossAxisCount: 2,
                  children: [
                    ..._remoteRenderers.values.map((renderer) => RTCVideoView(renderer)),
                  ],
                ),

                // Local Video
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 120,
                    height: 160,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RTCVideoView(_localRenderer, mirror: true),
                  ),
                ),

                // Bottom Buttons
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          heroTag: 'mic',
                          backgroundColor:
                              micEnabled ? Colors.green : Colors.red,
                          onPressed: toggleMic,
                          child: Icon(micEnabled ? Icons.mic : Icons.mic_off),
                        ),
                        SizedBox(width: 24),
                        FloatingActionButton(
                          heroTag: 'camera',
                          backgroundColor:
                              cameraEnabled ? Colors.green : Colors.red,
                          onPressed: toggleCamera,
                          child: Icon(
                            cameraEnabled ? Icons.videocam : Icons.videocam_off,
                          ),
                        ),
                        SizedBox(width: 24),
                        FloatingActionButton(
                          heroTag: 'leave',
                          backgroundColor: Colors.redAccent,
                          onPressed: leaveRoom,
                          child: Icon(Icons.call_end),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
