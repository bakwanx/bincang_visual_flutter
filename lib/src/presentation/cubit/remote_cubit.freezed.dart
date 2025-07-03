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

 UserModel? get user; Exception? get exception; CreateRoomModel? get createRoomModel; CoturnConfigurationModel? get coturnConfigurationModel; bool get isLoading;
/// Create a copy of RemoteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteStateCopyWith<RemoteState> get copyWith => _$RemoteStateCopyWithImpl<RemoteState>(this as RemoteState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteState&&(identical(other.user, user) || other.user == user)&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.createRoomModel, createRoomModel) || other.createRoomModel == createRoomModel)&&(identical(other.coturnConfigurationModel, coturnConfigurationModel) || other.coturnConfigurationModel == coturnConfigurationModel)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,user,exception,createRoomModel,coturnConfigurationModel,isLoading);

@override
String toString() {
  return 'RemoteState(user: $user, exception: $exception, createRoomModel: $createRoomModel, coturnConfigurationModel: $coturnConfigurationModel, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $RemoteStateCopyWith<$Res>  {
  factory $RemoteStateCopyWith(RemoteState value, $Res Function(RemoteState) _then) = _$RemoteStateCopyWithImpl;
@useResult
$Res call({
 UserModel? user, Exception? exception, CreateRoomModel? createRoomModel, CoturnConfigurationModel? coturnConfigurationModel, bool isLoading
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
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? exception = freezed,Object? createRoomModel = freezed,Object? coturnConfigurationModel = freezed,Object? isLoading = null,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception?,createRoomModel: freezed == createRoomModel ? _self.createRoomModel : createRoomModel // ignore: cast_nullable_to_non_nullable
as CreateRoomModel?,coturnConfigurationModel: freezed == coturnConfigurationModel ? _self.coturnConfigurationModel : coturnConfigurationModel // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _RemoteState extends RemoteState {
   _RemoteState({this.user, this.exception, this.createRoomModel, this.coturnConfigurationModel, this.isLoading = false}): super._();
  

@override final  UserModel? user;
@override final  Exception? exception;
@override final  CreateRoomModel? createRoomModel;
@override final  CoturnConfigurationModel? coturnConfigurationModel;
@override@JsonKey() final  bool isLoading;

/// Create a copy of RemoteState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteStateCopyWith<_RemoteState> get copyWith => __$RemoteStateCopyWithImpl<_RemoteState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteState&&(identical(other.user, user) || other.user == user)&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.createRoomModel, createRoomModel) || other.createRoomModel == createRoomModel)&&(identical(other.coturnConfigurationModel, coturnConfigurationModel) || other.coturnConfigurationModel == coturnConfigurationModel)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,user,exception,createRoomModel,coturnConfigurationModel,isLoading);

@override
String toString() {
  return 'RemoteState(user: $user, exception: $exception, createRoomModel: $createRoomModel, coturnConfigurationModel: $coturnConfigurationModel, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$RemoteStateCopyWith<$Res> implements $RemoteStateCopyWith<$Res> {
  factory _$RemoteStateCopyWith(_RemoteState value, $Res Function(_RemoteState) _then) = __$RemoteStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? user, Exception? exception, CreateRoomModel? createRoomModel, CoturnConfigurationModel? coturnConfigurationModel, bool isLoading
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
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? exception = freezed,Object? createRoomModel = freezed,Object? coturnConfigurationModel = freezed,Object? isLoading = null,}) {
  return _then(_RemoteState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception?,createRoomModel: freezed == createRoomModel ? _self.createRoomModel : createRoomModel // ignore: cast_nullable_to_non_nullable
as CreateRoomModel?,coturnConfigurationModel: freezed == coturnConfigurationModel ? _self.coturnConfigurationModel : coturnConfigurationModel // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
