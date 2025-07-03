class CoturnConfigurationModelResponse {
  CoturnConfigurationModel data;
  String message;

  CoturnConfigurationModelResponse({
    required this.data,
    required this.message,
  });

  factory CoturnConfigurationModelResponse.fromJson(Map<String, dynamic> json) => CoturnConfigurationModelResponse(
    data: CoturnConfigurationModel.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
  };
}

class CoturnConfigurationModel {
  List<IceServerConfiguration> iceServers;

  CoturnConfigurationModel({
    required this.iceServers,
  });

  factory CoturnConfigurationModel.fromJson(Map<String, dynamic> json) => CoturnConfigurationModel(
    iceServers: List<IceServerConfiguration>.from(json["iceServers"].map((x) => IceServerConfiguration.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "iceServers": List<dynamic>.from(iceServers.map((x) => x.toJson())),
  };
}

class IceServerConfiguration {
  List<String> urls;
  String? username;
  String? credential;

  IceServerConfiguration({
    required this.urls,
    this.username,
    this.credential,
  });

  factory IceServerConfiguration.fromJson(Map<String, dynamic> json) => IceServerConfiguration(
    urls: List<String>.from(json["urls"].map((x) => x)),
    username: json["username"],
    credential: json["credential"],
  );

  Map<String, dynamic> toJson() => {
    "urls": List<dynamic>.from(urls.map((x) => x)),
    "username": username ?? '',
    "credential": credential ?? '',
  };
}