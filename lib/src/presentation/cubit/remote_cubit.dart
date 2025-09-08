import 'dart:async';

import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/coturn_configuration_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/create_room_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';
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

    UserEntity? userEntity;
    CoturnConfigurationEntity? coturnConfigurationEntity;

    result.fold(
      (l) {
        emit(state.copyWith(exception: l, isLoading: false, userEntity: null));
      },
      (r) {
        userEntity = r;
      },
    );

    config.fold(
      (l) {
        emit(
          state.copyWith(exception: l, isLoading: false, createRoomEntity: null),
        );
      },
      (r) {
        coturnConfigurationEntity = r;
      },
    );

    emit(
      state.copyWith(
        coturnConfigurationEntity: coturnConfigurationEntity,
        userEntity: userEntity,
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
          state.copyWith(exception: l, isLoading: false, createRoomEntity: null),
        );
      },
      (r) {
        emit(
          state.copyWith(createRoomEntity: r, exception: null, isLoading: false),
        );
      },
    );
  }

  Future<bool> checkRoom(String roomId) async {
    emit(state.copyWith(isLoading: true));

    final room = await remoteUseCase.checkRoom(roomId);

    return room.fold(
      (l) {
        emit(
          state.copyWith(isLoading: false),
        );
        return false;
      },
      (r) {
        emit(
          state.copyWith(isLoading: false),
        );
        return true;
      },
    );
  }
}
