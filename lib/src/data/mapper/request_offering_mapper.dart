import 'package:bincang_visual_flutter/src/data/mapper/user_mapper.dart';
import 'package:bincang_visual_flutter/src/data/models/request_offering_model.dart';
import 'package:bincang_visual_flutter/src/domain/entities/request_offering_payload_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/null_helper_extenison.dart';

extension RequestOfferingMapper on RequestOfferingPayloadModel {
  RequestOfferingPayloadEntity toEntity() {
    return RequestOfferingPayloadEntity(
      roomId: roomId.orEmpty(),
      userRequest: userRequest.toEntity(),
    );
  }
}

extension RequestOfferingToModelMapper on RequestOfferingPayloadEntity {
  RequestOfferingPayloadModel toModel() {
    return RequestOfferingPayloadModel(
      roomId: roomId,
      userRequest: userRequest.toModel()
    );
  }
}
