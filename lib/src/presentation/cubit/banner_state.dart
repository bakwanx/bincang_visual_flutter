part of 'banner_cubit.dart';

@freezed
sealed class BannerState with _$BannerState{
  BannerState._();

  factory BannerState({
    @Default(0) int index,
    @Default([]) List<BannerEntity> bannerEntities,
    Exception? exception,
    @Default(false) bool isLoading
  }) = _BannerState;
}
