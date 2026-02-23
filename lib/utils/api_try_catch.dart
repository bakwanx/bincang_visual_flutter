import 'dart:io';

import 'package:bincang_visual_flutter/utils/log/print_debug_log.dart';
import 'package:either_dart/either.dart';

import '../core/error/exceptions.dart';
import '../core/error/failures.dart';

Future<Either<Failure, ENTITY>> apiTryCatch<ENTITY>({
  required Future<Either<Failure, ENTITY>> Function() execute,
}) async {
  try {
    return await execute.call();
  } on ServerException catch (e) {
    printDebugLog(message: 'Server Exception Error: ${e.message}');
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    printDebugLog(message: 'Network Exception Error: ${e.message}');
    return Left(NetworkFailure(e.message));
  } on WebRTCException catch (e) {
    printDebugLog(message: 'WebRTC Exception Error: ${e.message}');
    return Left(WebRTCFailure(e.message));
  } on SocketException catch (e) {
    printDebugLog(message: 'Socket Exception Error: ${e.message}');
    return Left(NetworkFailure(e.message));
  } catch (e) {
    printDebugLog(message: 'GeneralError $e');
    return Left(UnRecognizedFailure('Something went wrong'));
  }
}
