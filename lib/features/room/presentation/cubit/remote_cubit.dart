import 'package:bincang_visual_flutter/features/room/domain/usecase/remote_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import '../../../../di/dependency_injection.dart';
import '../../../../infrastructure/websocket_service.dart';
import '../../data/models/user_model.dart';

part 'remote_state.dart';

part 'remote_cubit.freezed.dart';

class RemoteCubit extends Cubit<RemoteState> {
  RemoteCubit({required this.remoteUseCase}) : super(RemoteState());

  final RemoteUseCase remoteUseCase;

  Future<void> registerUser(String username) async {
    emit(state.copyWith(isLoading: true));
    final result = await remoteUseCase.registerUser(username);

    result.fold(
      (l) {
        emit((state).copyWith(exception: l, isLoading: false, user: null));
      },
      (r) {
        emit((state).copyWith(user: r, isLoading: false, exception: null));
      },
    );
  }
}
