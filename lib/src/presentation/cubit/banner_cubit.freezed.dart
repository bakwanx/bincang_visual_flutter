// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BannerState {

 int get index; List<BannerEntity> get bannerEntities; Exception? get exception; bool get isLoading;
/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerStateCopyWith<BannerState> get copyWith => _$BannerStateCopyWithImpl<BannerState>(this as BannerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerState&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.bannerEntities, bannerEntities)&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,index,const DeepCollectionEquality().hash(bannerEntities),exception,isLoading);

@override
String toString() {
  return 'BannerState(index: $index, bannerEntities: $bannerEntities, exception: $exception, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $BannerStateCopyWith<$Res>  {
  factory $BannerStateCopyWith(BannerState value, $Res Function(BannerState) _then) = _$BannerStateCopyWithImpl;
@useResult
$Res call({
 int index, List<BannerEntity> bannerEntities, Exception? exception, bool isLoading
});




}
/// @nodoc
class _$BannerStateCopyWithImpl<$Res>
    implements $BannerStateCopyWith<$Res> {
  _$BannerStateCopyWithImpl(this._self, this._then);

  final BannerState _self;
  final $Res Function(BannerState) _then;

/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? bannerEntities = null,Object? exception = freezed,Object? isLoading = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,bannerEntities: null == bannerEntities ? _self.bannerEntities : bannerEntities // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _BannerState extends BannerState {
   _BannerState({this.index = 0, final  List<BannerEntity> bannerEntities = const [], this.exception, this.isLoading = false}): _bannerEntities = bannerEntities,super._();
  

@override@JsonKey() final  int index;
 final  List<BannerEntity> _bannerEntities;
@override@JsonKey() List<BannerEntity> get bannerEntities {
  if (_bannerEntities is EqualUnmodifiableListView) return _bannerEntities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bannerEntities);
}

@override final  Exception? exception;
@override@JsonKey() final  bool isLoading;

/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerStateCopyWith<_BannerState> get copyWith => __$BannerStateCopyWithImpl<_BannerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerState&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other._bannerEntities, _bannerEntities)&&(identical(other.exception, exception) || other.exception == exception)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,index,const DeepCollectionEquality().hash(_bannerEntities),exception,isLoading);

@override
String toString() {
  return 'BannerState(index: $index, bannerEntities: $bannerEntities, exception: $exception, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$BannerStateCopyWith<$Res> implements $BannerStateCopyWith<$Res> {
  factory _$BannerStateCopyWith(_BannerState value, $Res Function(_BannerState) _then) = __$BannerStateCopyWithImpl;
@override @useResult
$Res call({
 int index, List<BannerEntity> bannerEntities, Exception? exception, bool isLoading
});




}
/// @nodoc
class __$BannerStateCopyWithImpl<$Res>
    implements _$BannerStateCopyWith<$Res> {
  __$BannerStateCopyWithImpl(this._self, this._then);

  final _BannerState _self;
  final $Res Function(_BannerState) _then;

/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? bannerEntities = null,Object? exception = freezed,Object? isLoading = null,}) {
  return _then(_BannerState(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,bannerEntities: null == bannerEntities ? _self._bannerEntities : bannerEntities // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,exception: freezed == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
