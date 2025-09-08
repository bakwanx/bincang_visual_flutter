// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteState {

 UserEntity? get userEntity; Exception? get exception; CreateRoomEntity? get createRoomEntity; CoturnConfigurationEntity? get coturnConfigurationEntity; bool get isLoading;
/// Create a copy of RemoteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStateCopyWith<RemoteState> get copyWith => _$RemoteStateCopyWithImpl<RemoteState>(this as RemoteState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteState&&(identical(other.userEntity, userEntity) || other.userEntity == userEntity)&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.createRoomEntity, createRoomEntity) || other.createRoomEntity == createRoomEntity)&&(identical(other.coturnConfigurationEntity, coturnConfigurationEntity) || other.coturnConfigurationEntity == coturnConfigurationEntity)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,userEntity,exception,createRoomEntity,coturnConfigurationEntity,isLoading);

@override
String toString() {
  return 'RemoteState(userEntity: $userEntity, exception: $exception, createRoomEntity: $createRoomEntity, coturnConfigurationEntity: $coturnConfigurationEntity, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $RemoteStateCopyWith<$Res>  {
  factory $RemoteStateCopyWith(RemoteState value, $Res Function(RemoteState) _then) = _$RemoteStateCopyWithImpl;
@useResult
$Res call({
 UserEntity? userEntity, Exception? exception, CreateRoomEntity? createRoomEntity, CoturnConfigurationEntity? coturnConfigurationEntity, bool isLoading
});




}
/// @nodoc
class _$RemoteStateCopyWithImpl<$Res>
    implements $RemoteStateCopyWith<$Res> {
  _$RemoteStateCopyWithImpl(this._self, this._then);

  final RemoteState _self;
  final $Res Function(RemoteState) _then;

/// Create a copy of RemoteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userEntity = freezed,Object? exception = freezed,Object? createRoomEntity = freezed,Object? coturnConfigurationEntity = freezed,Object? isLoading = null,}) {
  return _then(_self.copyWith(
userEntity: freezed == userEntity ? _self.userEntity : userEntity // ignore: cast_nullable_to_non_nullable
as UserEntity?,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception?,createRoomEntity: freezed == createRoomEntity ? _self.createRoomEntity : createRoomEntity // ignore: cast_nullable_to_non_nullable
as CreateRoomEntity?,coturnConfigurationEntity: freezed == coturnConfigurationEntity ? _self.coturnConfigurationEntity : coturnConfigurationEntity // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationEntity?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _RemoteState extends RemoteState {
   _RemoteState({this.userEntity, this.exception, this.createRoomEntity, this.coturnConfigurationEntity, this.isLoading = false}): super._();
  

@override final  UserEntity? userEntity;
@override final  Exception? exception;
@override final  CreateRoomEntity? createRoomEntity;
@override final  CoturnConfigurationEntity? coturnConfigurationEntity;
@override@JsonKey() final  bool isLoading;

/// Create a copy of RemoteState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteStateCopyWith<_RemoteState> get copyWith => __$RemoteStateCopyWithImpl<_RemoteState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteState&&(identical(other.userEntity, userEntity) || other.userEntity == userEntity)&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.createRoomEntity, createRoomEntity) || other.createRoomEntity == createRoomEntity)&&(identical(other.coturnConfigurationEntity, coturnConfigurationEntity) || other.coturnConfigurationEntity == coturnConfigurationEntity)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,userEntity,exception,createRoomEntity,coturnConfigurationEntity,isLoading);

@override
String toString() {
  return 'RemoteState(userEntity: $userEntity, exception: $exception, createRoomEntity: $createRoomEntity, coturnConfigurationEntity: $coturnConfigurationEntity, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$RemoteStateCopyWith<$Res> implements $RemoteStateCopyWith<$Res> {
  factory _$RemoteStateCopyWith(_RemoteState value, $Res Function(_RemoteState) _then) = __$RemoteStateCopyWithImpl;
@override @useResult
$Res call({
 UserEntity? userEntity, Exception? exception, CreateRoomEntity? createRoomEntity, CoturnConfigurationEntity? coturnConfigurationEntity, bool isLoading
});




}
/// @nodoc
class __$RemoteStateCopyWithImpl<$Res>
    implements _$RemoteStateCopyWith<$Res> {
  __$RemoteStateCopyWithImpl(this._self, this._then);

  final _RemoteState _self;
  final $Res Function(_RemoteState) _then;

/// Create a copy of RemoteState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userEntity = freezed,Object? exception = freezed,Object? createRoomEntity = freezed,Object? coturnConfigurationEntity = freezed,Object? isLoading = null,}) {
  return _then(_RemoteState(
userEntity: freezed == userEntity ? _self.userEntity : userEntity // ignore: cast_nullable_to_non_nullable
as UserEntity?,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception?,createRoomEntity: freezed == createRoomEntity ? _self.createRoomEntity : createRoomEntity // ignore: cast_nullable_to_non_nullable
as CreateRoomEntity?,coturnConfigurationEntity: freezed == coturnConfigurationEntity ? _self.coturnConfigurationEntity : coturnConfigurationEntity // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationEntity?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
