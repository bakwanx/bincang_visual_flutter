import 'package:bincang_visual_flutter/core/error/failures.dart';
import 'package:either_dart/either.dart';

import '../entities/meeting_entities.dart';


abstract class MeetingRepository {
  Future<Either<Failure, Room>> createRoom({
    required String name,
    required int maxParticipants,
    required RoomSettings settings,
  });

  Future<Either<Failure, Room>> getRoom(String roomId);

  Future<Either<Failure, List<Participant>>> getParticipants(String roomId);


  Future<Either<Failure, List<ChatMessage>>> getChatHistory(String roomId);

  Future<Either<Failure, Recording>> startRecording(String roomId);

  Future<Either<Failure, void>> stopRecording({
    required String roomId,
    required String recordingId,
  });

  Future<Either<Failure, RoomConfig>> getIceServers();
}