import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class WebRTCFailure extends Failure {
  const WebRTCFailure(String message) : super(message);
}

class UnRecognizedFailure extends Failure {
  const UnRecognizedFailure(String message) : super(message);
}