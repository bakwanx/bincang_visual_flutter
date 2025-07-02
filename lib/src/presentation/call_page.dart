import 'dart:math';

import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/dashboard_page.dart';
import 'package:bincang_visual_flutter/utils/extension/context_extension.dart';
import 'package:bincang_visual_flutter/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../di/dependency_injection.dart';
import '../../utils/theme/app_colors.dart';

class CallPage extends StatelessWidget {
  final UserModel user;
  final String roomId;
  final bool micEnabled;
  final bool cameraEnabled;

  const CallPage({
    super.key,
    required this.user,
    required this.roomId,
    required this.micEnabled,
    required this.cameraEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              di<SignalingCubit>()..init(
                user: user,
                roomId: roomId,
                cameraEnabled: cameraEnabled,
                micEnabled: micEnabled,
              ),
      child: CallPageUI(
        user: user,
        roomId: roomId,
        cameraEnabled: cameraEnabled,
        micEnabled: micEnabled,
      ),
    );
  }
}

class CallPageUI extends StatefulWidget {
  final UserModel user;
  final String roomId;
  final bool micEnabled;
  final bool cameraEnabled;

  const CallPageUI({
    required this.user,
    required this.roomId,
    required this.micEnabled,
    required this.cameraEnabled,
  });

  @override
  State<CallPageUI> createState() => _CallPageUIState();
}

class _CallPageUIState extends State<CallPageUI> {
  // late MultipleUserSignaling multipleUserSignaling;
  double x = 0;
  double y = 0;
  bool micEnabled = true;
  bool cameraEnabled = true;

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final Map<String, RTCVideoRenderer> remoteRenderers = {};
  bool _isChatVisible = false;
  final Duration _animationDuration = Duration(milliseconds: 300);

  void toggleChatPanel() {
    setState(() {
      _isChatVisible = !_isChatVisible;
    });
  }

  @override
  void initState() {
    super.initState();

    init();
    initCameraAndMic();
    // initRenderers();
    // startSignaling();
  }

  void initCameraAndMic() {
    micEnabled = widget.micEnabled;
    cameraEnabled = widget.cameraEnabled;
  }

  Future<void> init() async {
    final signalingCubit = context.read<SignalingCubit>();

    await localRenderer.initialize();

    signalingCubit.stream.listen((state) {
      // Initialize local stream
      if (state.localStream != null &&
          localRenderer.srcObject != state.localStream) {
        localRenderer.srcObject = state.localStream;
      }

      // Loop through the updated remote streams
      //   state.remoteStream.forEach((key, stream) {
      //     if (!remoteRenderers.containsKey(key)) {
      //       final renderer = RTCVideoRenderer();
      //       renderer.initialize().then((_) {
      //         renderer.srcObject = stream;
      //         setState(() {
      //           remoteRenderers[key] = renderer;
      //         });
      //       });
      //     } else {
      //       // Update existing renderer with the new stream
      //       remoteRenderers[key]?.srcObject = stream;
      //     }
      //   });
      //
      //   // Remove remote users who left
      //   remoteRenderers.forEach((key, renderer) {
      //     if (!state.remoteStream.containsKey(key)) {
      //       renderer.srcObject = null; // Clean up the stream if user leaves
      //       remoteRenderers.remove(key);
      //     }
      //   });
    });
  }

  // Future<void> initRenderers() async {
  //   await localRenderer.initialize();
  // }

  // Future<void> startSignaling() async {
  //   multipleUserSignaling = MultipleUserSignaling(
  //     roomId: widget.roomId,
  //     username: widget.username,
  //   );
  //   await multipleUserSignaling.initLocalMedia();
  //   localRenderer.srcObject = multipleUserSignaling.localStream;
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
  //     if (!remoteRenderers.containsKey('hanza')) {
  //       final renderer = RTCVideoRenderer();
  //       renderer.initialize().then((_) {
  //         renderer.srcObject = stream;
  //         setState(() {
  //           remoteRenderers['hanza'] = renderer;
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
  //   localRenderer.srcObject = multipleUserSignaling.localStream;
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
    for (final renderer in remoteRenderers.values) {
      renderer.srcObject = null;
      renderer.dispose();
    }
    remoteRenderers.clear();
    // localRenderer.dispose();
    localRenderer.dispose();
    context.pushAndRemoveUntil(DashboardPage());
  }

  // Example number of items
  final int numberOfItems = 20;

  Widget participants() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the screen width and height
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        // Calculate number of columns and rows
        int columns = (sqrt(numberOfItems)).ceil();
        int rows = (numberOfItems / columns).ceil();

        // Calculate tile size
        double tileWidth = screenWidth / columns;
        double tileHeight = screenHeight / rows;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.isTablet() ? 2 : 2,
            childAspectRatio: context.isTablet() ? tileWidth / tileHeight : 0.9,
          ),
          scrollDirection: context.isTablet() ? Axis.horizontal : Axis.vertical,
          itemCount: remoteRenderers.entries.isEmpty ? 0 : numberOfItems,
          itemBuilder: (context, index) {
            final entry = remoteRenderers.entries.toList()[0];
            final renderer = entry.value;
            final key = entry.key;
            return Container(
              margin: const EdgeInsets.all(4.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: RTCVideoView(
                        renderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        right: 4,
                        left: 4,
                      ),
                      child: Text(
                        key,
                        style: AppTextStyle.smallNormal.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user: ${widget.user.username}'),
        actions: [
          if (context.isPhone()) ...[
            IconButton(onPressed: toggleChatPanel, icon: Icon(Icons.message)),
          ],
        ],
      ),
      body: BlocListener<SignalingCubit, SignalingState>(
        listenWhen:
            (previous, current) =>
                previous.remoteStream != current.remoteStream,
        listener: (context, state) {
          // Loop through the updated remote streams
          state.remoteStream.forEach((key, stream) {
            if (!remoteRenderers.containsKey(key)) {
              final renderer = RTCVideoRenderer();
              renderer.initialize().then((_) {
                renderer.srcObject = stream;
                setState(() {
                  remoteRenderers[key] = renderer;
                });
              });
            } else {
              // Update existing renderer with the new stream
              remoteRenderers[key]?.srcObject = stream;
            }
          });

          // Remove remote users who left
          remoteRenderers.forEach((key, renderer) {
            if (!state.remoteStream.containsKey(key)) {
              renderer.srcObject = null; // Clean up the stream if user leaves
              remoteRenderers.remove(key);
            }
          });
        },
        child: BlocBuilder<SignalingCubit, SignalingState>(
          builder: (context, state) {
            return Stack(
              children: [

                participants(),

                // Local Video
                Positioned(
                  left: x,
                  top: y,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        x += details.delta.dx;
                        y += details.delta.dy;
                      });
                    },
                    child: Container(
                      width: 120,
                      height: 160,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: RTCVideoView(
                          localRenderer,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                      ),
                    ),
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
                              micEnabled
                                  ? AppColors.secondaryColor
                                  : Colors.red,
                          onPressed: toggleMic,
                          child: Icon(
                            micEnabled ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 24),
                        FloatingActionButton(
                          heroTag: 'camera',
                          backgroundColor:
                              cameraEnabled
                                  ? AppColors.secondaryColor
                                  : Colors.red,
                          onPressed: toggleCamera,
                          child: Icon(
                            cameraEnabled ? Icons.videocam : Icons.videocam_off,
                            color: Colors.white,
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

                context.isTablet()
                    ? Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              heroTag: 'chat',
                              backgroundColor: Colors.white,
                              onPressed: toggleChatPanel,
                              child: Icon(Icons.message),
                            ),
                          ],
                        ),
                      ),
                    )
                    : SizedBox(),
                _DisplayChat(
                  toggleChatPanel: toggleChatPanel,
                  isChatVisible: _isChatVisible,
                  animationDuration: _animationDuration,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DisplayChat extends StatefulWidget {
  final Function() toggleChatPanel;
  final Duration animationDuration;
  final bool isChatVisible;

  const _DisplayChat({
    super.key,
    required this.toggleChatPanel,
    required this.animationDuration,
    required this.isChatVisible
  });

  @override
  State<_DisplayChat> createState() => _DisplayChatState();
}

class _DisplayChatState extends State<_DisplayChat> {
  final messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double chatWidth = screenWidth * 0.6; // 60% of screen
    return // Chat Panel
    AnimatedPositioned(
      duration: widget.animationDuration,
      right: widget.isChatVisible ? 0 : -chatWidth,
      top: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: chatWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('Meeting Chat'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: widget.toggleChatPanel,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: 20,
                itemBuilder:
                    (context, index) => Align(
                      alignment:
                          index % 2 == 0
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              index % 2 == 0
                                  ? Colors.grey[300]
                                  : Colors.blue[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Message #$index'),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(icon: Icon(Icons.send), onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
