part of 'remote_cubit.dart';


@freezed
sealed class RemoteState with _$RemoteState{
  RemoteState._();

  factory RemoteState({
    UserModel? user,
    Exception? exception,
    CreateRoomModel? createRoomModel,
    CoturnConfigurationModel? coturnConfigurationModel,
    @Default(false) bool isLoading,
  }) = _RemoteState;
}

