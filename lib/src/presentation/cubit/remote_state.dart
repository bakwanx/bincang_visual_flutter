part of 'remote_cubit.dart';


@freezed
sealed class RemoteState with _$RemoteState{
  RemoteState._();

  factory RemoteState({
    Exception? exception,
    CreateRoomEntity? createRoomEntity,
    @Default(false) bool isLoading,
  }) = _RemoteState;
}

