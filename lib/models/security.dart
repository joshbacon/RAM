import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart';

class EncryptData {

  static Encrypted? encrypted;
  static var decrypted;

  static encryptAES(plainText){
    final key = Key.fromUtf8(dotenv.env['KEY']!);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted!.base64;
  }

  static decryptAES(plainText){
    final key = Key.fromUtf8(dotenv.env['KEY']!);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    decrypted = encrypter.decrypt(encrypted!, iv: iv);
    return decrypted;
  }
}