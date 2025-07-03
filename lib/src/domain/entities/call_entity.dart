import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/data/models/user_model.dart';

class CallEntity {
  final UserModel user;
  final String roomId;
  final bool micEnabled;
  final bool cameraEnabled;
  final CoturnConfigurationModel configurationModel;

  CallEntity({
    required this.user,
    required this.roomId,
    required this.micEnabled,
    required this.cameraEnabled,
    required this.configurationModel,
  });
}
