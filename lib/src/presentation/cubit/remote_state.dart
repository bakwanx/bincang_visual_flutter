part of 'remote_cubit.dart';


@freezed
sealed class RemoteState with _$RemoteState{
  RemoteState._();

  factory RemoteState({
    UserEntity? userEntity,
    Exception? exception,
    CreateRoomEntity? createRoomEntity,
    CoturnConfigurationEntity? coturnConfigurationEntity,
    @Default(false) bool isLoading,
  }) = _RemoteState;
}

