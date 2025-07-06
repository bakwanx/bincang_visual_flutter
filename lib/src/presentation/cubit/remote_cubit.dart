import 'dart:async';

import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/domain/usecase/remote_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/create_room_model.dart';
import '../../data/models/user_model.dart';

part 'remote_cubit.freezed.dart';

part 'remote_state.dart';

class RemoteCubit extends Cubit<RemoteState> {
  RemoteCubit({required this.remoteUseCase}) : super(RemoteState());

  final RemoteUseCase remoteUseCase;

  Future<void> registerUser(String username) async {
    emit(state.copyWith(isLoading: true));
    final result = await remoteUseCase.registerUser(username);
    final config = await remoteUseCase.getConfiguration();

    UserModel? userModel;
    CoturnConfigurationModel? coturnConfigurationModel;

    result.fold(
      (l) {
        emit((state).copyWith(exception: l, isLoading: false, user: null));
      },
      (r) {
        userModel = r;
      },
    );

    config.fold(
      (l) {
        emit(
          (state).copyWith(
            exception: l,
            isLoading: false,
            createRoomModel: null,
          ),
        );
      },
      (r) {
        coturnConfigurationModel = r;
      },
    );

    emit(
      (state).copyWith(
        coturnConfigurationModel: coturnConfigurationModel,
        user: userModel,
        isLoading: false,
        exception: null,
      ),
    );
  }

  Future<void> createRoom() async {
    emit(state.copyWith(isLoading: true));

    final room = await remoteUseCase.createRoom();

    room.fold(
      (l) {
        emit(
          (state).copyWith(
            exception: l,
            isLoading: false,
            createRoomModel: null,
          ),
        );
      },
      (r) {
        emit(
          (state).copyWith(
            createRoomModel: r,
            exception: null,
            isLoading: false,
          ),
        );
      },
    );
  }
}
