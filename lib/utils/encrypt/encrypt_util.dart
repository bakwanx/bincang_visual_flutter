import 'dart:typed_data';

import 'package:bincang_visual_flutter/env/env.dart';
import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  EncryptUtil._();

  static String decryptData(String text) {
    final key = Key.fromUtf8(Env.privateKey);
    final iv = IV.fromUtf8(Env.ivPrivateKey);

    final encrypter = Encrypter(
      AES(key, mode: AESMode.cbc, padding: 'PKCS7'),
    );

    return encrypter.decrypt(
      Encrypted.from64(text),
      iv: iv,
    );
  }

  static String encryptData(String plainText) {
    final key = Key.fromUtf8(Env.privateKey);
    final iv = IV.fromUtf8(Env.ivPrivateKey);

    final encrypter = Encrypter(
      AES(key, mode: AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }
}