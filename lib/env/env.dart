// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  const Env._();
  @EnviedField(varName: 'PRIVATE_ENCRYPTOR_KEY')
  static const String privateKey = _Env.privateKey;
  @EnviedField(varName: 'IV_PRIVATE_ENCRYPTOR_KEY')
  static const String ivPrivateKey = _Env.ivPrivateKey;
  @EnviedField(varName: 'PROD_URL')
  static const String prodUrl = _Env.prodUrl;
  @EnviedField(varName: 'DEV_URL')
  static const String devUrl = _Env.devUrl;
}