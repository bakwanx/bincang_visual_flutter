import 'dart:math';

import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/call_entity.dart';
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
  final CallEntity callEntity;

  const CallPage({super.key, required this.callEntity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<SignalingCubit>()..init(callEntity: callEntity),
      child: CallPageUI(callEntity: callEntity),
    );
  }
}

class CallPageUI extends StatefulWidget {
  final CallEntity callEntity;

  const CallPageUI({required this.callEntity});

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
    micEnabled = widget.callEntity.micEnabled;
    cameraEnabled = widget.callEntity.cameraEnabled;
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


  Widget participant() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;
        final bool isPortrait = screenHeight > screenWidth;

        const double minTileWidth = 200;
        const double minTileHeight = 200;

        if (remoteRenderers.entries.length <= 2) {
          return remoteRenderers.entries.length == 1
              ? _buildFullScreenParticipant(
                remoteRenderers.entries.first.key,
                remoteRenderers.entries.first.value,
                false,
              )
              : (isPortrait
                  ? Column(
                    children:
                        remoteRenderers.entries.map((entry) {
                          return Expanded(
                            child: _buildParticipantTile(
                              entry.key,
                              entry.value,
                            ),
                          );
                        }).toList(),
                  )
                  : Row(
                    children:
                        remoteRenderers.entries.map((entry) {
                          return Expanded(
                            child: _buildParticipantTile(
                              entry.key,
                              entry.value,
                            ),
                          );
                        }).toList(),
                  ));
        }

        int columns = isPortrait ? 2 : 3;
        double tileWidth = screenWidth / columns;
        double tileHeight =
            screenHeight / ((remoteRenderers.entries.length / columns).ceil());

        if (tileWidth >= minTileWidth && tileHeight >= minTileHeight) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children:
                remoteRenderers.entries.map((entry) {
                  return SizedBox(
                    width: tileWidth - 8,
                    height: tileHeight - 8,
                    child: _buildParticipantTile(entry.key, entry.value),
                  );
                }).toList(),
          );
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isPortrait ? 2 : 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: isPortrait ? 3 / 4 : 4 / 3,
            ),
            itemCount: remoteRenderers.entries.length,
            itemBuilder: (context, index) {
              // final entry = remoteRenderers.entries.toList()[0];
              // final renderer = entry.value;
              // final key = entry.key;
              // // final isActive = participant.key == widget.activeSpeakerId;
              // final isActive = false;
              final participant = remoteRenderers.entries.elementAt(index);
              return _buildParticipantTile(participant.key, participant.value);
            },
          );
        }
      },
    );
  }

  Widget _buildFullScreenParticipant(
    String id,
    RTCVideoRenderer renderer,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: RTCVideoView(
                renderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
            if (isActive)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(String id, RTCVideoRenderer renderer) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: RTCVideoView(
                renderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user: ${widget.callEntity.user.username}'),
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
                participant(),

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
    required this.isChatVisible,
  });

  @override
  State<_DisplayChat> createState() => _DisplayChatState();
}

class _DisplayChatState extends State<_DisplayChat> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double chatWidth =
        context.isTablet()
            ? screenWidth * 0.4
            : context.width(); // 60% of screen
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
              child: BlocBuilder<SignalingCubit, SignalingState>(
                builder: (context, state) {
                  return ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: state.chat.length,
                    itemBuilder:
                        (context, index) => Align(
                          alignment:
                              state.user!.id != state.chat[index].userFrom.id
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment:
                                state.user!.id != state.chat[index].userFrom.id
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                            children: [
                              Text(
                                state.chat[index].userFrom.username,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      state.user!.id !=
                                              state.chat[index].userFrom.id
                                          ? Colors.grey[300]
                                          : Colors.blue[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(state.chat[index].message),
                              ),
                            ],
                          ),
                        ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        context.read<SignalingCubit>().sendChat(
                          messageController.text,
                        );
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
