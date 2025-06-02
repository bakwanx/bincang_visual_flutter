import 'package:bincang_visual_flutter/features/room/presentation/cubit/remote_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bincang_visual_flutter/di/dependency_injection.dart';
import 'package:bincang_visual_flutter/features/room/presentation/widgets/custom_outlined_button.dart';
import 'package:bincang_visual_flutter/features/room/presentation/widgets/custom_text_form_field.dart';
import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';
import 'package:bincang_visual_flutter/utils/extension/widget_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'call_page.dart';

class UsernameInputPage extends StatelessWidget {
  const UsernameInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<RemoteCubit>(),
      child: UsernameInputPageUI(),
    );
  }
}

class UsernameInputPageUI extends StatefulWidget {
  const UsernameInputPageUI({super.key});

  @override
  State<UsernameInputPageUI> createState() => _UsernameInputPageUIState();
}

class _UsernameInputPageUIState extends State<UsernameInputPageUI> {
  TextEditingController usernameController = TextEditingController();
  String errMessage = '';

  void registerUser() {
    if (usernameController.text.isEmpty) {
      return;
    }
    context.read<RemoteCubit>().registerUser(usernameController.text).then((
        value,) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebRTC Testing")),
      body: BlocListener<RemoteCubit, RemoteState>(
        listener: (context, state) {
          if (state.user != null) {
            di<WebSocketService>().connect(userId: state.user!.id, roomId: "1");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallPage(roomId: "1", user: state.user!),
              ),
            );
          }
        },
        listenWhen: (previous, current) => previous != current,
        child: BlocBuilder<RemoteCubit, RemoteState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      controller: usernameController,
                      hintText: "Username",
                    ).bottomMargin(16),
                    if (errMessage.isNotEmpty) Text(errMessage).bottomMargin(8),
                    state.isLoading
                        ? CircularProgressIndicator()
                        : CustomOutlinedButton(
                      onPressed: registerUser,
                      child: Text("Masuk"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
