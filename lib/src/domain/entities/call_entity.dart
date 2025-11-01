import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/coturn_configuration_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/user_entity.dart';

class CallEntity {
  final UserEntity user;
  final String roomId;
  final bool micEnabled;
  final bool cameraEnabled;
  final CoturnConfigurationEntity configurationEntity;

  CallEntity({
    required this.user,
    required this.roomId,
    required this.micEnabled,
    required this.cameraEnabled,
    required this.configurationEntity,
  });
}
