import 'package:bincang_visual_flutter/src/domain/entities/call_entity.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/remote_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_snackbar.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_text_button.dart';
import 'package:bincang_visual_flutter/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../utils/theme/app_colors.dart';
import '../../utils/theme/app_text_style.dart';
import 'call_page.dart';

class PreviewPage extends StatefulWidget {
  final String roomId;

  const PreviewPage({super.key, required this.roomId});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
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
    await localRenderer.initialize();
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
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey,
              width: 400,
              height: 400,
              child: RTCVideoView(
                localRenderer,
                mirror: true,
                objectFit:
                RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: EdgeInsets.all(24),
                    color: Colors.grey,
                    width: 400,
                    height: 400,
                    child: RTCVideoView(
                      localRenderer,
                      mirror: true,
                      objectFit:
                      RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
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
          if (state.user != null && state.coturnConfigurationModel != null) {
            context.pushReplacement(
              CallPage(
                callEntity: CallEntity(
                  user: state.user!,
                  roomId: widget.roomId,
                  micEnabled: micEnabled,
                  cameraEnabled: cameraEnabled,
                  configurationModel: state.coturnConfigurationModel!,
                ),
              ),
            );
          }
        },
        listenWhen:
            (previous, current) =>
        previous.user != current.user &&
            previous.coturnConfigurationModel !=
                current.coturnConfigurationModel,
        child: context.isPhone() ? phoneView() : tabletView(),
      ),
    );
  }
}
