import 'package:bincang_visual_flutter/src/data/models/coturn_configuration_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/coturn_configuration_entity.dart';
import 'package:bincang_visual_flutter/src/domain/entities/ice_server_configuration_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension CoturnConfigurationMapper on CoturnConfigurationModel {
  CoturnConfigurationEntity toEntity() {
    return CoturnConfigurationEntity(
      iceServers: iceServers.map((value) => value.toEntity()).toList(),
    );
  }
}

extension IceServerConfigurationMapper on IceServerConfiguration {
  IceServerConfigurationEntity toEntity() {
    return IceServerConfigurationEntity(
      urls: urls.orEmpty(),
      username: username.orEmpty(),
      credential: credential.orEmpty(),
    );
  }
}
