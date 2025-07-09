import 'package:bincang_visual_flutter/src/presentation/cubit/banner_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/preview_page.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/banner_item.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_snackbar.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_text_button.dart';
import 'package:bincang_visual_flutter/src/presentation/widgets/custom_text_form_field.dart';
import 'package:bincang_visual_flutter/utils/const/assets_path.dart';
import 'package:bincang_visual_flutter/utils/extension/context_extension.dart';
import 'package:bincang_visual_flutter/utils/extension/datetime_extension.dart';
import 'package:bincang_visual_flutter/utils/format/datetime_util_format.dart';
import 'package:bincang_visual_flutter/utils/theme/app_colors.dart';
import 'package:bincang_visual_flutter/utils/theme/app_text_style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/dependency_injection.dart';
import 'cubit/remote_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<BannerCubit>()..init(),
      child: DashboardPageUI(),
    );
  }
}

class DashboardPageUI extends StatefulWidget {
  const DashboardPageUI({super.key});

  @override
  State<DashboardPageUI> createState() => _DashboardPageUIState();
}

class _DashboardPageUIState extends State<DashboardPageUI> {
  TextEditingController invitationCode = TextEditingController();

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Color(0XFFFCFCFF),
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Image.asset(AssetsPath.icLogo, width: 200),
      ),
      actions: [
        StreamBuilder(
          stream: Stream.periodic(Duration(minutes: 1)),
          builder: (ctx, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                DateTime.now().asString(DateTimeUtilFormat.defaultFormat),
              ),
            );
          },
        ),
      ],
    );
  }

  void roomCreatedDialog(String code) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          title: const Text('Here is your room meeting'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share this link to the person you want to join the meeting',
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(code),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: code)).then((_) {
                          CustomSnackBar(
                            context: context,
                            message: "Link copied to clipboard",
                          );
                        });
                      },
                      child: Icon(Icons.copy, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> joinHandler() async {
    if (invitationCode.text.isEmpty) {
      CustomSnackBar(context: context, message: "Invitation code is empty");
      return;
    }

    context.read<RemoteCubit>().checkRoom(invitationCode.text).then((isAvailable) {
      if (isAvailable) {
        context.push(PreviewPage(roomId: invitationCode.text));
        invitationCode.clear();
      } else {
        CustomSnackBar(context: context, message: "Room not found");
      }
    });
  }

  Widget body() {
    Widget newMeetingOrJoin() {
      return BlocListener<RemoteCubit, RemoteState>(
        listener: (context, state) {
          roomCreatedDialog(state.createRoomModel!.data.roomId);
        },
        listenWhen:
            (previous, current) =>
                previous != current &&
                previous.createRoomModel != current.createRoomModel &&
                current.createRoomModel != null,
        child: BlocBuilder<RemoteCubit, RemoteState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Meetings and video calls\nfor everyone",
                  style: AppTextStyle.bodyLarge.copyWith(fontSize: 40),
                ),
                Text(
                  "Connect, collaborate, and celebrate from anywhere with Bincang Visual",
                  style: AppTextStyle.bodyLarge.copyWith(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                if (context.isPhone()) ...[
                  Column(
                    children: [
                      CustomTextButton(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: AppColors.primaryColor,
                        onPressed: () async {
                          await context.read<RemoteCubit>().createRoom();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.video_call_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "New Meeting",
                              style: AppTextStyle.bodyMedium.copyWith(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomTextFormField(
                        controller: invitationCode,
                        hintText: "Enter the code",
                        onFieldSubmitted: (value) async {
                          await joinHandler();
                        },
                        prefixIcon: Icon(
                          Icons.keyboard,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          await joinHandler();
                        },
                        child: Text(
                          "Join",
                          style: AppTextStyle.bodyMedium.copyWith(),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextButton(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: AppColors.primaryColor,
                        onPressed: () async {
                          await context.read<RemoteCubit>().createRoom();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.video_call_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "New Meeting",
                              style: AppTextStyle.bodyMedium.copyWith(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          controller: invitationCode,
                          hintText: "Enter the code",
                          onFieldSubmitted: (value) async {
                            await joinHandler();
                          },
                          prefixIcon: Icon(
                            Icons.keyboard,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () async {
                          await joinHandler();
                        },
                        child: Text(
                          "Join",
                          style: AppTextStyle.bodyMedium.copyWith(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      );
    }

    Widget banner() {
      return BlocBuilder<BannerCubit, BannerState>(
        builder: (context, state) {
          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 400,
                    onPageChanged: (index, _) {
                      context.read<BannerCubit>().onChanged(index);
                    },
                  ),
                  items:
                      state.bannerEntities.map((value) {
                        return BannerItem(bannerEntity: value);
                      }).toList(),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children:
                      state.bannerEntities.asMap().entries.map((entry) {
                        return Container(
                          width: state.index == entry.key ? 16 : 6.0,
                          height: 6.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            shape:
                                state.index == entry.key
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                            color:
                                state.index == entry.key
                                    ? AppColors.secondaryColor
                                    : AppColors.grey[300],
                            borderRadius:
                                state.index == entry.key
                                    ? BorderRadius.circular(8)
                                    : null,
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Container(
        height: context.height(),
        margin: EdgeInsets.symmetric(horizontal: 24),
        child:
            context.isPhone()
                ? newMeetingOrJoin()
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: newMeetingOrJoin()),
                    Expanded(child: banner()),
                  ],
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      resizeToAvoidBottomInset: false,
    );
  }
}
