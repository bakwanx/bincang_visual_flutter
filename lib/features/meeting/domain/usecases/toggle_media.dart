import 'package:equatable/equatable.dart';

class ToggleAudioParams extends Equatable {
  final bool muted;

  const ToggleAudioParams({required this.muted});

  @override
  List<Object?> get props => [muted];
}

class ToggleVideoParams extends Equatable {
  final bool videoOff;

  const ToggleVideoParams({required this.videoOff});

  @override
  List<Object?> get props => [videoOff];
}