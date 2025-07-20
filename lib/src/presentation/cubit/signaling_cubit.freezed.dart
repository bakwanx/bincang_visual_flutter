// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signaling_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignalingState {

 UserModel? get user; String get roomId; List<ChatPayloadModel> get chat; Map<String, List<IceCandidatePayloadModel>> get iceCandidates; Map<String, MediaStream> get remoteStream; Map<String, RTCPeerConnection> get peerConnection; String get toastMessage; CoturnConfigurationModel? get coturnConfiguration; MediaStream? get localStream;
/// Create a copy of SignalingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignalingStateCopyWith<SignalingState> get copyWith => _$SignalingStateCopyWithImpl<SignalingState>(this as SignalingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignalingState&&(identical(other.user, user) || other.user == user)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&const DeepCollectionEquality().equals(other.chat, chat)&&const DeepCollectionEquality().equals(other.iceCandidates, iceCandidates)&&const DeepCollectionEquality().equals(other.remoteStream, remoteStream)&&const DeepCollectionEquality().equals(other.peerConnection, peerConnection)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.coturnConfiguration, coturnConfiguration) || other.coturnConfiguration == coturnConfiguration)&&(identical(other.localStream, localStream) || other.localStream == localStream));
}


@override
int get hashCode => Object.hash(runtimeType,user,roomId,const DeepCollectionEquality().hash(chat),const DeepCollectionEquality().hash(iceCandidates),const DeepCollectionEquality().hash(remoteStream),const DeepCollectionEquality().hash(peerConnection),toastMessage,coturnConfiguration,localStream);

@override
String toString() {
  return 'SignalingState(user: $user, roomId: $roomId, chat: $chat, iceCandidates: $iceCandidates, remoteStream: $remoteStream, peerConnection: $peerConnection, toastMessage: $toastMessage, coturnConfiguration: $coturnConfiguration, localStream: $localStream)';
}


}

/// @nodoc
abstract mixin class $SignalingStateCopyWith<$Res>  {
  factory $SignalingStateCopyWith(SignalingState value, $Res Function(SignalingState) _then) = _$SignalingStateCopyWithImpl;
@useResult
$Res call({
 UserModel? user, String roomId, List<ChatPayloadModel> chat, Map<String, List<IceCandidatePayloadModel>> iceCandidates, Map<String, MediaStream> remoteStream, Map<String, RTCPeerConnection> peerConnection, String toastMessage, CoturnConfigurationModel? coturnConfiguration, MediaStream? localStream
});




}
/// @nodoc
class _$SignalingStateCopyWithImpl<$Res>
    implements $SignalingStateCopyWith<$Res> {
  _$SignalingStateCopyWithImpl(this._self, this._then);

  final SignalingState _self;
  final $Res Function(SignalingState) _then;

/// Create a copy of SignalingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? roomId = null,Object? chat = null,Object? iceCandidates = null,Object? remoteStream = null,Object? peerConnection = null,Object? toastMessage = null,Object? coturnConfiguration = freezed,Object? localStream = freezed,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as List<ChatPayloadModel>,iceCandidates: null == iceCandidates ? _self.iceCandidates : iceCandidates // ignore: cast_nullable_to_non_nullable
as Map<String, List<IceCandidatePayloadModel>>,remoteStream: null == remoteStream ? _self.remoteStream : remoteStream // ignore: cast_nullable_to_non_nullable
as Map<String, MediaStream>,peerConnection: null == peerConnection ? _self.peerConnection : peerConnection // ignore: cast_nullable_to_non_nullable
as Map<String, RTCPeerConnection>,toastMessage: null == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String,coturnConfiguration: freezed == coturnConfiguration ? _self.coturnConfiguration : coturnConfiguration // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationModel?,localStream: freezed == localStream ? _self.localStream : localStream // ignore: cast_nullable_to_non_nullable
as MediaStream?,
  ));
}

}


/// @nodoc


class _SignalingState extends SignalingState {
   _SignalingState({this.user, this.roomId = '', final  List<ChatPayloadModel> chat = const [], final  Map<String, List<IceCandidatePayloadModel>> iceCandidates = const {}, final  Map<String, MediaStream> remoteStream = const {}, final  Map<String, RTCPeerConnection> peerConnection = const {}, this.toastMessage = '', this.coturnConfiguration, this.localStream}): _chat = chat,_iceCandidates = iceCandidates,_remoteStream = remoteStream,_peerConnection = peerConnection,super._();
  

@override final  UserModel? user;
@override@JsonKey() final  String roomId;
 final  List<ChatPayloadModel> _chat;
@override@JsonKey() List<ChatPayloadModel> get chat {
  if (_chat is EqualUnmodifiableListView) return _chat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chat);
}

 final  Map<String, List<IceCandidatePayloadModel>> _iceCandidates;
@override@JsonKey() Map<String, List<IceCandidatePayloadModel>> get iceCandidates {
  if (_iceCandidates is EqualUnmodifiableMapView) return _iceCandidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_iceCandidates);
}

 final  Map<String, MediaStream> _remoteStream;
@override@JsonKey() Map<String, MediaStream> get remoteStream {
  if (_remoteStream is EqualUnmodifiableMapView) return _remoteStream;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_remoteStream);
}

 final  Map<String, RTCPeerConnection> _peerConnection;
@override@JsonKey() Map<String, RTCPeerConnection> get peerConnection {
  if (_peerConnection is EqualUnmodifiableMapView) return _peerConnection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_peerConnection);
}

@override@JsonKey() final  String toastMessage;
@override final  CoturnConfigurationModel? coturnConfiguration;
@override final  MediaStream? localStream;

/// Create a copy of SignalingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignalingStateCopyWith<_SignalingState> get copyWith => __$SignalingStateCopyWithImpl<_SignalingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignalingState&&(identical(other.user, user) || other.user == user)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&const DeepCollectionEquality().equals(other._chat, _chat)&&const DeepCollectionEquality().equals(other._iceCandidates, _iceCandidates)&&const DeepCollectionEquality().equals(other._remoteStream, _remoteStream)&&const DeepCollectionEquality().equals(other._peerConnection, _peerConnection)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.coturnConfiguration, coturnConfiguration) || other.coturnConfiguration == coturnConfiguration)&&(identical(other.localStream, localStream) || other.localStream == localStream));
}


@override
int get hashCode => Object.hash(runtimeType,user,roomId,const DeepCollectionEquality().hash(_chat),const DeepCollectionEquality().hash(_iceCandidates),const DeepCollectionEquality().hash(_remoteStream),const DeepCollectionEquality().hash(_peerConnection),toastMessage,coturnConfiguration,localStream);

@override
String toString() {
  return 'SignalingState(user: $user, roomId: $roomId, chat: $chat, iceCandidates: $iceCandidates, remoteStream: $remoteStream, peerConnection: $peerConnection, toastMessage: $toastMessage, coturnConfiguration: $coturnConfiguration, localStream: $localStream)';
}


}

/// @nodoc
abstract mixin class _$SignalingStateCopyWith<$Res> implements $SignalingStateCopyWith<$Res> {
  factory _$SignalingStateCopyWith(_SignalingState value, $Res Function(_SignalingState) _then) = __$SignalingStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? user, String roomId, List<ChatPayloadModel> chat, Map<String, List<IceCandidatePayloadModel>> iceCandidates, Map<String, MediaStream> remoteStream, Map<String, RTCPeerConnection> peerConnection, String toastMessage, CoturnConfigurationModel? coturnConfiguration, MediaStream? localStream
});




}
/// @nodoc
class __$SignalingStateCopyWithImpl<$Res>
    implements _$SignalingStateCopyWith<$Res> {
  __$SignalingStateCopyWithImpl(this._self, this._then);

  final _SignalingState _self;
  final $Res Function(_SignalingState) _then;

/// Create a copy of SignalingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? roomId = null,Object? chat = null,Object? iceCandidates = null,Object? remoteStream = null,Object? peerConnection = null,Object? toastMessage = null,Object? coturnConfiguration = freezed,Object? localStream = freezed,}) {
  return _then(_SignalingState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,chat: null == chat ? _self._chat : chat // ignore: cast_nullable_to_non_nullable
as List<ChatPayloadModel>,iceCandidates: null == iceCandidates ? _self._iceCandidates : iceCandidates // ignore: cast_nullable_to_non_nullable
as Map<String, List<IceCandidatePayloadModel>>,remoteStream: null == remoteStream ? _self._remoteStream : remoteStream // ignore: cast_nullable_to_non_nullable
as Map<String, MediaStream>,peerConnection: null == peerConnection ? _self._peerConnection : peerConnection // ignore: cast_nullable_to_non_nullable
as Map<String, RTCPeerConnection>,toastMessage: null == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String,coturnConfiguration: freezed == coturnConfiguration ? _self.coturnConfiguration : coturnConfiguration // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationModel?,localStream: freezed == localStream ? _self.localStream : localStream // ignore: cast_nullable_to_non_nullable
as MediaStream?,
  ));
}


}

// dart format on
