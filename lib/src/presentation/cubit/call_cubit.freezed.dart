// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallState {

 double get x; double get y; Map<String, RTCVideoRenderer> get remoteRenderer; RTCVideoRenderer? get localRenderer; bool get isChatVisible; bool get micEnabled; bool get cameraEnabled;
/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStateCopyWith<CallState> get copyWith => _$CallStateCopyWithImpl<CallState>(this as CallState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallState&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&const DeepCollectionEquality().equals(other.remoteRenderer, remoteRenderer)&&(identical(other.localRenderer, localRenderer) || other.localRenderer == localRenderer)&&(identical(other.isChatVisible, isChatVisible) || other.isChatVisible == isChatVisible)&&(identical(other.micEnabled, micEnabled) || other.micEnabled == micEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,x,y,const DeepCollectionEquality().hash(remoteRenderer),localRenderer,isChatVisible,micEnabled,cameraEnabled);

@override
String toString() {
  return 'CallState(x: $x, y: $y, remoteRenderer: $remoteRenderer, localRenderer: $localRenderer, isChatVisible: $isChatVisible, micEnabled: $micEnabled, cameraEnabled: $cameraEnabled)';
}


}

/// @nodoc
abstract mixin class $CallStateCopyWith<$Res>  {
  factory $CallStateCopyWith(CallState value, $Res Function(CallState) _then) = _$CallStateCopyWithImpl;
@useResult
$Res call({
 double x, double y, Map<String, RTCVideoRenderer> remoteRenderer, RTCVideoRenderer? localRenderer, bool isChatVisible, bool micEnabled, bool cameraEnabled
});




}
/// @nodoc
class _$CallStateCopyWithImpl<$Res>
    implements $CallStateCopyWith<$Res> {
  _$CallStateCopyWithImpl(this._self, this._then);

  final CallState _self;
  final $Res Function(CallState) _then;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? remoteRenderer = null,Object? localRenderer = freezed,Object? isChatVisible = null,Object? micEnabled = null,Object? cameraEnabled = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,remoteRenderer: null == remoteRenderer ? _self.remoteRenderer : remoteRenderer // ignore: cast_nullable_to_non_nullable
as Map<String, RTCVideoRenderer>,localRenderer: freezed == localRenderer ? _self.localRenderer : localRenderer // ignore: cast_nullable_to_non_nullable
as RTCVideoRenderer?,isChatVisible: null == isChatVisible ? _self.isChatVisible : isChatVisible // ignore: cast_nullable_to_non_nullable
as bool,micEnabled: null == micEnabled ? _self.micEnabled : micEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _CallState extends CallState {
   _CallState({this.x = 0, this.y = 0, final  Map<String, RTCVideoRenderer> remoteRenderer = const {}, this.localRenderer, this.isChatVisible = false, this.micEnabled = true, this.cameraEnabled = true}): _remoteRenderer = remoteRenderer,super._();
  

@override@JsonKey() final  double x;
@override@JsonKey() final  double y;
 final  Map<String, RTCVideoRenderer> _remoteRenderer;
@override@JsonKey() Map<String, RTCVideoRenderer> get remoteRenderer {
  if (_remoteRenderer is EqualUnmodifiableMapView) return _remoteRenderer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_remoteRenderer);
}

@override final  RTCVideoRenderer? localRenderer;
@override@JsonKey() final  bool isChatVisible;
@override@JsonKey() final  bool micEnabled;
@override@JsonKey() final  bool cameraEnabled;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallStateCopyWith<_CallState> get copyWith => __$CallStateCopyWithImpl<_CallState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallState&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&const DeepCollectionEquality().equals(other._remoteRenderer, _remoteRenderer)&&(identical(other.localRenderer, localRenderer) || other.localRenderer == localRenderer)&&(identical(other.isChatVisible, isChatVisible) || other.isChatVisible == isChatVisible)&&(identical(other.micEnabled, micEnabled) || other.micEnabled == micEnabled)&&(identical(other.cameraEnabled, cameraEnabled) || other.cameraEnabled == cameraEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,x,y,const DeepCollectionEquality().hash(_remoteRenderer),localRenderer,isChatVisible,micEnabled,cameraEnabled);

@override
String toString() {
  return 'CallState(x: $x, y: $y, remoteRenderer: $remoteRenderer, localRenderer: $localRenderer, isChatVisible: $isChatVisible, micEnabled: $micEnabled, cameraEnabled: $cameraEnabled)';
}


}

/// @nodoc
abstract mixin class _$CallStateCopyWith<$Res> implements $CallStateCopyWith<$Res> {
  factory _$CallStateCopyWith(_CallState value, $Res Function(_CallState) _then) = __$CallStateCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, Map<String, RTCVideoRenderer> remoteRenderer, RTCVideoRenderer? localRenderer, bool isChatVisible, bool micEnabled, bool cameraEnabled
});




}
/// @nodoc
class __$CallStateCopyWithImpl<$Res>
    implements _$CallStateCopyWith<$Res> {
  __$CallStateCopyWithImpl(this._self, this._then);

  final _CallState _self;
  final $Res Function(_CallState) _then;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? remoteRenderer = null,Object? localRenderer = freezed,Object? isChatVisible = null,Object? micEnabled = null,Object? cameraEnabled = null,}) {
  return _then(_CallState(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,remoteRenderer: null == remoteRenderer ? _self._remoteRenderer : remoteRenderer // ignore: cast_nullable_to_non_nullable
as Map<String, RTCVideoRenderer>,localRenderer: freezed == localRenderer ? _self.localRenderer : localRenderer // ignore: cast_nullable_to_non_nullable
as RTCVideoRenderer?,isChatVisible: null == isChatVisible ? _self.isChatVisible : isChatVisible // ignore: cast_nullable_to_non_nullable
as bool,micEnabled: null == micEnabled ? _self.micEnabled : micEnabled // ignore: cast_nullable_to_non_nullable
as bool,cameraEnabled: null == cameraEnabled ? _self.cameraEnabled : cameraEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
