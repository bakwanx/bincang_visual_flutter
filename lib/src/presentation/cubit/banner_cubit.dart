import 'dart:async';

import 'package:bincang_visual_flutter/src/domain/entities/banner_entity.dart';
import 'package:bincang_visual_flutter/utils/const/assets_path.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'banner_state.dart';

part 'banner_cubit.freezed.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerState());

  init() {
    final banners = [
      BannerEntity(
        img: AssetsPath.banner1,
        title: "Host longer group calls",
        description: "Meetings with three or more participants. Meetings can include up to 100 participants.",
      ),
      BannerEntity(
        img: AssetsPath.banner2,
        title: "Record and share recordings",
        description: "Once started, the recording is saved to your storage and can be shared with others.",
      ),
      BannerEntity(
        img: AssetsPath.banner3,
        title: "Get a link you can share",
        description: "Click New Meeting to get a link that can be sent to people you want to join the meeting.",
      ),
      BannerEntity(
        img: AssetsPath.banner4,
        title: "Real-Time Messaging and Reactions",
        description: "Engage with others using in-meeting chat, emoji reactions, and quick responses to enhance collaboration and feedback",
      ),
      BannerEntity(
        img: AssetsPath.banner5,
        title: "Freedom to Connect",
        description: "Experience powerful features with no cost. No fees, no commitments. Just effortless communication",
      ),
    ];

    emit(state.copyWith(bannerEntities: banners));
  }

  onChanged(int index) {
    emit(state.copyWith(index: index));
  }
}
