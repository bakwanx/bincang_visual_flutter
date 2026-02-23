import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

import '../core/error/exceptions.dart';
import '../core/error/failures.dart';

Future<Either<Failure, ENTITY>> apiTryCatch<ENTITY>({
  required Future<Either<Failure, ENTITY>> Function() execute,
}) async {
  try {
    return await execute.call();
  } on ServerException catch (e) {
    debugPrint('Server Exception Error: ${e.message}');
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    debugPrint('Network Exception Error: ${e.message}');
    return Left(NetworkFailure(e.message));
  } on WebRTCException catch (e) {
    debugPrint('WebRTC Exception Error: ${e.message}');
    return Left(WebRTCFailure(e.message));
  } on SocketException catch (e) {
    debugPrint('Socket Exception Error: ${e.message}');
    return Left(NetworkFailure(e.message));
  } catch (e) {
    debugPrint('GeneralError $e');
    return Left(UnRecognizedFailure('Something went wrong'));
  }
}
