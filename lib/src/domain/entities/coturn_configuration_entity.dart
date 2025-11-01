import 'package:bincang_visual_flutter/src/domain/entities/ice_server_configuration_entity.dart';

class CoturnConfigurationEntity {
  List<IceServerConfigurationEntity> iceServers;

  CoturnConfigurationEntity({
    required this.iceServers,
  });

  Map<String, dynamic> toJson() => {
    "iceServers": List<dynamic>.from(iceServers.map((x) => x.toJson())),
  };
}