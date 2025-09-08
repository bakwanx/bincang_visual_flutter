import 'package:bincang_visual_flutter/src/domain/entities/payload_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class RequestOfferingPayloadEntity extends PayloadEntity {
  String roomId;
  UserEntity userRequest;

  RequestOfferingPayloadEntity({required this.roomId, required this.userRequest});

}
