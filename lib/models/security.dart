import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart';

class EncryptData {

  static final iv = IV.fromLength(16);
  static final key = Key.fromUtf8(dotenv.env['KEY']!);
  static final encrypter = Encrypter(AES(key));

  static encryptAES(plainText){
    Encrypted? encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static decryptAES(plainText){
    String decrypted = encrypter.decrypt64(plainText, iv: iv);
    return decrypted;
  }
}