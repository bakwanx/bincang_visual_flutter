import 'package:bincang_visual_flutter/src/presentation/cubit/remote_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_snackbar.dart';
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

class PreviewPage extends StatelessWidget {
  final String roomId;

  const PreviewPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return PreviewPageUI(roomId: roomId);
  }
}

class PreviewPageUI extends StatefulWidget {
  final String roomId;

  const PreviewPageUI({super.key, required this.roomId});

  @override
  State<PreviewPageUI> createState() => _PreviewPageUIState();
}

class _PreviewPageUIState extends State<PreviewPageUI> {
  TextEditingController usernameController = TextEditingController();
  bool micEnabled = true;
  bool cameraEnabled = true;
  MediaStream? localStream;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();

  void registerUser() {
    if (usernameController.text.isEmpty) {
      CustomSnackBar(context: context, message: "Username Empty");
      return;
    }
    context.read<RemoteCubit>().registerUser(usernameController.text);
  }

  @override
  void initState() {
    super.initState();
    initializeRenderer();
    initLocalStream();
  }

  Future<void> initializeRenderer() async {
    // final signalingCubit = context.read<SignalingCubit>();
    await localRenderer.initialize();
    // await signalingCubit.initLocalMedia();
  }

  Future<void> initLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'},
    };

    final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    setState(() {
      localStream = stream;
      localRenderer.srcObject = localStream;
    });
  }

  void toggleMic() {
    if (localStream != null) {
      for (var track in localStream!.getAudioTracks()) {
        track.enabled = !track.enabled;
      }
      setState(() {
        micEnabled = !micEnabled;
      });
    }
  }

  Future<void> toggleCamera() async {
    if (localStream != null) {
      final videoTracks = localStream!.getVideoTracks();

      if (cameraEnabled) {
        for (var track in videoTracks) {
          await track.stop();
        }
      } else {
        initLocalStream();
      }
      setState(() {
        cameraEnabled = !cameraEnabled;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    localRenderer.dispose();
    usernameController.dispose();
  }

  Widget phoneView() {
    return Column(
      children: [
        Expanded(
          child:
              cameraEnabled
                  ? Container(
                    color: Colors.red,
                    width: 400,
                    height: 400,
                    child: RTCVideoView(
                      localRenderer,
                      mirror: true,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  )
                  : Container(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(micEnabled ? Icons.mic : Icons.mic_off),
              onPressed: toggleMic,
            ),
            IconButton(
              icon: Icon(cameraEnabled ? Icons.videocam : Icons.videocam_off),
              onPressed: toggleCamera,
            ),
          ],
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
        Container(
          padding: const EdgeInsets.all(8.0),
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
    );
  }

  Widget tabletView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (cameraEnabled) ...[
                Container(
                  margin: EdgeInsets.all(24),
                  color: Colors.red,
                  width: 400,
                  height: 400,
                  child: RTCVideoView(
                    localRenderer,
                    mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ] else ...[
                Container(
                  color: Colors.grey,
                  margin: EdgeInsets.all(24),
                  width: 400,
                  height: 400,
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'mic',
                    backgroundColor:
                        micEnabled ? AppColors.secondaryColor : Colors.red,
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
                        cameraEnabled ? AppColors.secondaryColor : Colors.red,
                    onPressed: toggleCamera,
                    child: Icon(
                      cameraEnabled ? Icons.videocam : Icons.videocam_off,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: context.width(),
                padding: const EdgeInsets.symmetric(horizontal: 100),
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
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Page'),
        backgroundColor: Color(0XFFFCFCFF),
        automaticallyImplyLeading: true,
      ),
      body: BlocListener<RemoteCubit, RemoteState>(
        listener: (context, state) {
          if (state.user != null) {
            context.pushReplacement(
              CallPage(
                roomId: widget.roomId,
                user: state.user!,
                cameraEnabled: cameraEnabled,
                micEnabled: micEnabled,
              ),
            );
          }
        },
        listenWhen: (previous, current) => previous.user != current.user,
        child: context.isPhone() ? phoneView() : tabletView(),
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
