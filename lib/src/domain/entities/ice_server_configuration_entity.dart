class IceServerConfigurationEntity {
  List<String> urls;
  String username;
  String credential;

  IceServerConfigurationEntity({
    required this.urls,
    this.username = '',
    this.credential = '',
  });

  Map<String, dynamic> toJson() => {
    "urls": List<dynamic>.from(urls.map((x) => x)),
    "username": username ?? '',
    "credential": credential ?? '',
  };
}