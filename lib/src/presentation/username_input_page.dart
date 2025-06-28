import 'package:bincang_visual_flutter/src/presentation/cubit/remote_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_text_button.dart';
import 'package:bincang_visual_flutter/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:bincang_visual_flutter/di/dependency_injection.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_text_form_field.dart';
import 'package:bincang_visual_flutter/utils/extension/widget_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../utils/theme/app_colors.dart';
import '../../utils/theme/app_text_style.dart';
import 'call_page.dart';

class UsernameInputPage extends StatelessWidget {
  final String roomId;

  const UsernameInputPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return UsernameInputPageUI(roomId: roomId);
  }
}

class UsernameInputPageUI extends StatefulWidget {
  final String roomId;

  const UsernameInputPageUI({super.key, required this.roomId});

  @override
  State<UsernameInputPageUI> createState() => _UsernameInputPageUIState();
}

class _UsernameInputPageUIState extends State<UsernameInputPageUI> {
  TextEditingController usernameController = TextEditingController();
  String errMessage = '';
  bool micEnabled = true;
  bool cameraEnabled = true;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  void registerUser() {
    if (usernameController.text.isEmpty) {
      return;
    }
    context.read<RemoteCubit>().registerUser(usernameController.text);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final signalingCubit = context.read<SignalingCubit>();
    await _localRenderer.initialize();
    await signalingCubit.initLocalMedia();
  }

  void toggleMic() {
    final signalingCubitState = context.read<SignalingCubit>().state;
    if (signalingCubitState.localStream != null) {
      for (var track in signalingCubitState.localStream!.getAudioTracks()) {
        track.enabled = !track.enabled;
      }
      setState(() {
        micEnabled = !micEnabled;
      });
    }
  }

  Future<void> toggleCamera() async {
    final signalingCubit = context.read<SignalingCubit>();
    if (signalingCubit.state.localStream != null) {
      final videoTracks = signalingCubit.state.localStream!.getVideoTracks();

      if (cameraEnabled) {
        for (var track in videoTracks) {
          await track.stop();
        }
      } else {
        await signalingCubit.initLocalMedia();
      }
      setState(() {
        cameraEnabled = !cameraEnabled;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _localRenderer.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: BlocListener<SignalingCubit, SignalingState>(
        listener: (context, state) {
          if (state.localStream != null &&
              _localRenderer.srcObject != state.localStream) {
            setState(() {
              _localRenderer.srcObject = state.localStream;
            });
          }
        },
        listenWhen:
            (previous, current) => previous.localStream != current.localStream,
        child: BlocListener<RemoteCubit, RemoteState>(
          listener: (context, state) {
            if (state.user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CallPage(
                        localRenderer: _localRenderer,
                        roomId: widget.roomId,
                        user: state.user!,
                      ),
                ),
              );
            }
          },
          listenWhen: (previous, current) => previous != current,
          child: Column(
            children: [
              Expanded(
                child:
                    cameraEnabled
                        ? RTCVideoView(_localRenderer, mirror: true)
                        : Container(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(micEnabled ? Icons.mic : Icons.mic_off),
                    onPressed: toggleMic,
                  ),
                  IconButton(
                    icon: Icon(
                      cameraEnabled ? Icons.videocam : Icons.videocam_off,
                    ),
                    onPressed: toggleCamera,
                  ),
                ],
              ),
              SizedBox(
                width: context.width(),
                child: CustomTextButton(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: AppColors.primaryColor,
                  onPressed: registerUser,
                  child: Text(
                    "Join",
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("WebRTC Testing")),
  //     body: BlocListener<RemoteCubit, RemoteState>(
  //       listener: (context, state) {
  //         if (state.user != null) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder:
  //                   (context) =>
  //                       CallPage(roomId: widget.roomId, user: state.user!),
  //             ),
  //           );
  //         }
  //       },
  //       listenWhen: (previous, current) => previous != current,
  //       child: BlocBuilder<RemoteCubit, RemoteState>(
  //         builder: (context, state) {
  //           return Center(
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 24),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   CustomTextFormField(
  //                     controller: usernameController,
  //                     hintText: "Username",
  //                   ).bottomMargin(16),
  //                   if (errMessage.isNotEmpty) Text(errMessage).bottomMargin(8),
  //                   state.isLoading
  //                       ? CircularProgressIndicator()
  //                       : CustomTextButton(
  //                         onPressed: registerUser,
  //                         child: Text("Masuk"),
  //                       ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
