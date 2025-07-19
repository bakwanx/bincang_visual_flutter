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

 int get currentBanner; Map<String, UserModel> get user; String get roomId; List<ChatPayloadModel> get chat; Map<String, List<IceCandidatePayloadModel>> get iceCandidates; Map<String, MediaStreamModel> get remoteStream; Map<String, RtcPeerConnectionModel> get peerConnection; String get toastMessage; bool get isCasting; CoturnConfigurationModel? get coturnConfiguration; Map<String, MediaStream> get localStream;
/// Create a copy of SignalingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignalingStateCopyWith<SignalingState> get copyWith => _$SignalingStateCopyWithImpl<SignalingState>(this as SignalingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignalingState&&(identical(other.currentBanner, currentBanner) || other.currentBanner == currentBanner)&&const DeepCollectionEquality().equals(other.user, user)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&const DeepCollectionEquality().equals(other.chat, chat)&&const DeepCollectionEquality().equals(other.iceCandidates, iceCandidates)&&const DeepCollectionEquality().equals(other.remoteStream, remoteStream)&&const DeepCollectionEquality().equals(other.peerConnection, peerConnection)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.isCasting, isCasting) || other.isCasting == isCasting)&&(identical(other.coturnConfiguration, coturnConfiguration) || other.coturnConfiguration == coturnConfiguration)&&const DeepCollectionEquality().equals(other.localStream, localStream));
}


@override
int get hashCode => Object.hash(runtimeType,currentBanner,const DeepCollectionEquality().hash(user),roomId,const DeepCollectionEquality().hash(chat),const DeepCollectionEquality().hash(iceCandidates),const DeepCollectionEquality().hash(remoteStream),const DeepCollectionEquality().hash(peerConnection),toastMessage,isCasting,coturnConfiguration,const DeepCollectionEquality().hash(localStream));

@override
String toString() {
  return 'SignalingState(currentBanner: $currentBanner, user: $user, roomId: $roomId, chat: $chat, iceCandidates: $iceCandidates, remoteStream: $remoteStream, peerConnection: $peerConnection, toastMessage: $toastMessage, isCasting: $isCasting, coturnConfiguration: $coturnConfiguration, localStream: $localStream)';
}


}

/// @nodoc
abstract mixin class $SignalingStateCopyWith<$Res>  {
  factory $SignalingStateCopyWith(SignalingState value, $Res Function(SignalingState) _then) = _$SignalingStateCopyWithImpl;
@useResult
$Res call({
 int currentBanner, Map<String, UserModel> user, String roomId, List<ChatPayloadModel> chat, Map<String, List<IceCandidatePayloadModel>> iceCandidates, Map<String, MediaStreamModel> remoteStream, Map<String, RtcPeerConnectionModel> peerConnection, String toastMessage, bool isCasting, CoturnConfigurationModel? coturnConfiguration, Map<String, MediaStream> localStream
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
@pragma('vm:prefer-inline') @override $Res call({Object? currentBanner = null,Object? user = null,Object? roomId = null,Object? chat = null,Object? iceCandidates = null,Object? remoteStream = null,Object? peerConnection = null,Object? toastMessage = null,Object? isCasting = null,Object? coturnConfiguration = freezed,Object? localStream = null,}) {
  return _then(_self.copyWith(
currentBanner: null == currentBanner ? _self.currentBanner : currentBanner // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as Map<String, UserModel>,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as List<ChatPayloadModel>,iceCandidates: null == iceCandidates ? _self.iceCandidates : iceCandidates // ignore: cast_nullable_to_non_nullable
as Map<String, List<IceCandidatePayloadModel>>,remoteStream: null == remoteStream ? _self.remoteStream : remoteStream // ignore: cast_nullable_to_non_nullable
as Map<String, MediaStreamModel>,peerConnection: null == peerConnection ? _self.peerConnection : peerConnection // ignore: cast_nullable_to_non_nullable
as Map<String, RtcPeerConnectionModel>,toastMessage: null == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String,isCasting: null == isCasting ? _self.isCasting : isCasting // ignore: cast_nullable_to_non_nullable
as bool,coturnConfiguration: freezed == coturnConfiguration ? _self.coturnConfiguration : coturnConfiguration // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationModel?,localStream: null == localStream ? _self.localStream : localStream // ignore: cast_nullable_to_non_nullable
as Map<String, MediaStream>,
  ));
}

}


/// @nodoc


class _SignalingState extends SignalingState {
   _SignalingState({this.currentBanner = 0, final  Map<String, UserModel> user = const {}, this.roomId = '', final  List<ChatPayloadModel> chat = const [], final  Map<String, List<IceCandidatePayloadModel>> iceCandidates = const {}, final  Map<String, MediaStreamModel> remoteStream = const {}, final  Map<String, RtcPeerConnectionModel> peerConnection = const {}, this.toastMessage = '', this.isCasting = false, this.coturnConfiguration, final  Map<String, MediaStream> localStream = const {}}): _user = user,_chat = chat,_iceCandidates = iceCandidates,_remoteStream = remoteStream,_peerConnection = peerConnection,_localStream = localStream,super._();
  

@override@JsonKey() final  int currentBanner;
 final  Map<String, UserModel> _user;
@override@JsonKey() Map<String, UserModel> get user {
  if (_user is EqualUnmodifiableMapView) return _user;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_user);
}

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

 final  Map<String, MediaStreamModel> _remoteStream;
@override@JsonKey() Map<String, MediaStreamModel> get remoteStream {
  if (_remoteStream is EqualUnmodifiableMapView) return _remoteStream;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_remoteStream);
}

 final  Map<String, RtcPeerConnectionModel> _peerConnection;
@override@JsonKey() Map<String, RtcPeerConnectionModel> get peerConnection {
  if (_peerConnection is EqualUnmodifiableMapView) return _peerConnection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_peerConnection);
}

@override@JsonKey() final  String toastMessage;
@override@JsonKey() final  bool isCasting;
@override final  CoturnConfigurationModel? coturnConfiguration;
 final  Map<String, MediaStream> _localStream;
@override@JsonKey() Map<String, MediaStream> get localStream {
  if (_localStream is EqualUnmodifiableMapView) return _localStream;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_localStream);
}


/// Create a copy of SignalingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignalingStateCopyWith<_SignalingState> get copyWith => __$SignalingStateCopyWithImpl<_SignalingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignalingState&&(identical(other.currentBanner, currentBanner) || other.currentBanner == currentBanner)&&const DeepCollectionEquality().equals(other._user, _user)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&const DeepCollectionEquality().equals(other._chat, _chat)&&const DeepCollectionEquality().equals(other._iceCandidates, _iceCandidates)&&const DeepCollectionEquality().equals(other._remoteStream, _remoteStream)&&const DeepCollectionEquality().equals(other._peerConnection, _peerConnection)&&(identical(other.toastMessage, toastMessage) || other.toastMessage == toastMessage)&&(identical(other.isCasting, isCasting) || other.isCasting == isCasting)&&(identical(other.coturnConfiguration, coturnConfiguration) || other.coturnConfiguration == coturnConfiguration)&&const DeepCollectionEquality().equals(other._localStream, _localStream));
}


@override
int get hashCode => Object.hash(runtimeType,currentBanner,const DeepCollectionEquality().hash(_user),roomId,const DeepCollectionEquality().hash(_chat),const DeepCollectionEquality().hash(_iceCandidates),const DeepCollectionEquality().hash(_remoteStream),const DeepCollectionEquality().hash(_peerConnection),toastMessage,isCasting,coturnConfiguration,const DeepCollectionEquality().hash(_localStream));

@override
String toString() {
  return 'SignalingState(currentBanner: $currentBanner, user: $user, roomId: $roomId, chat: $chat, iceCandidates: $iceCandidates, remoteStream: $remoteStream, peerConnection: $peerConnection, toastMessage: $toastMessage, isCasting: $isCasting, coturnConfiguration: $coturnConfiguration, localStream: $localStream)';
}


}

/// @nodoc
abstract mixin class _$SignalingStateCopyWith<$Res> implements $SignalingStateCopyWith<$Res> {
  factory _$SignalingStateCopyWith(_SignalingState value, $Res Function(_SignalingState) _then) = __$SignalingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentBanner, Map<String, UserModel> user, String roomId, List<ChatPayloadModel> chat, Map<String, List<IceCandidatePayloadModel>> iceCandidates, Map<String, MediaStreamModel> remoteStream, Map<String, RtcPeerConnectionModel> peerConnection, String toastMessage, bool isCasting, CoturnConfigurationModel? coturnConfiguration, Map<String, MediaStream> localStream
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
@override @pragma('vm:prefer-inline') $Res call({Object? currentBanner = null,Object? user = null,Object? roomId = null,Object? chat = null,Object? iceCandidates = null,Object? remoteStream = null,Object? peerConnection = null,Object? toastMessage = null,Object? isCasting = null,Object? coturnConfiguration = freezed,Object? localStream = null,}) {
  return _then(_SignalingState(
currentBanner: null == currentBanner ? _self.currentBanner : currentBanner // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self._user : user // ignore: cast_nullable_to_non_nullable
as Map<String, UserModel>,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,chat: null == chat ? _self._chat : chat // ignore: cast_nullable_to_non_nullable
as List<ChatPayloadModel>,iceCandidates: null == iceCandidates ? _self._iceCandidates : iceCandidates // ignore: cast_nullable_to_non_nullable
as Map<String, List<IceCandidatePayloadModel>>,remoteStream: null == remoteStream ? _self._remoteStream : remoteStream // ignore: cast_nullable_to_non_nullable
as Map<String, MediaStreamModel>,peerConnection: null == peerConnection ? _self._peerConnection : peerConnection // ignore: cast_nullable_to_non_nullable
as Map<String, RtcPeerConnectionModel>,toastMessage: null == toastMessage ? _self.toastMessage : toastMessage // ignore: cast_nullable_to_non_nullable
as String,isCasting: null == isCasting ? _self.isCasting : isCasting // ignore: cast_nullable_to_non_nullable
as bool,coturnConfiguration: freezed == coturnConfiguration ? _self.coturnConfiguration : coturnConfiguration // ignore: cast_nullable_to_non_nullable
as CoturnConfigurationModel?,localStream: null == localStream ? _self._localStream : localStream // ignore: cast_nullable_to_non_nullable
as Map<String, MediaStream>,
  ));
}


}

// dart format on
