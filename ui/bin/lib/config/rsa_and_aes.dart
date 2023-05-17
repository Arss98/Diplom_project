import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../../AES/aes.dart';
import '../../AES/convert_data_aes.dart';
import '../../RSA/generate_key_rsa.dart';
import '../../RSA/rsa.dart';

class RSAandAES {
  late int publicExponent;
  late int privateExponent;
  late int modulus;
  late String keyAES;

  RSAandAES(int publicExponent, int privateExponent, int modulus,
      {required bool randomGeneratedKeys}) {
    if (randomGeneratedKeys) {
      generateKeysForObject();
    } else {
      this.publicExponent = publicExponent;
      this.privateExponent = privateExponent;
      this.modulus = modulus;
    }
  }

  void generateKeysForObject() {
    final rsa = RSAKeyPair();
    final keys = rsa.generateRSAKeys(12);
    final publicKey = rsa.decodePublicKey(keys['publicKey']!);
    final privateKey = rsa.decodePrivateKey(keys['privateKey']!);

    publicExponent = publicKey['e']!;
    privateExponent = privateKey['d']!;

    modulus = publicKey['n']!;

    keyAES = _generateRandomKey();
  }

  EncodingResult encryptData(String message) {
    final messageByte = _convertTextToByteArray(message);
    AES aes = AES(_stringToUint8List(keyAES));

    final aesCryptingData = ConvertDataAes.encryptData(messageByte, aes);
    final encryptKeyAES = RSA.encode(keyAES, publicExponent, modulus);

    return EncodingResult(aesResult: aesCryptingData, rsaKey: encryptKeyAES);
  }

  String decryptData(List<int> encryptMessage, List<int> keyAES) {
    final decryptKeyAES = RSA.decode(keyAES, privateExponent, modulus);
    AES aes = AES(_stringToUint8List(decryptKeyAES));
    final decryptDataAES = ConvertDataAes.decryptData(encryptMessage, aes);

    final result = _convertByteArrayToText(decryptDataAES);

    return result;
  }

  String _generateRandomKey() {
    final random = Random.secure();
    const charset =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final key =
        List.generate(16, (_) => charset[random.nextInt(charset.length)])
            .join();
    return key;
  }

  Uint8List _stringToUint8List(String text) {
    List<int> bytes = utf8.encode(text); // конвертируем строку в байты
    return Uint8List.fromList(bytes); // возвращаем байты в виде Uint8List
  }

  List<int> _convertTextToByteArray(String text) {
    List<int> result = [];

    // Преобразуем символы в код ASCII и добавляем в список байтов
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      result.add(charCode);
    }
    return result;
  }

  String _convertByteArrayToText(List<int> byteArray) {
    // Если массив байтов пустой, то возращаем пустую строку
    if (byteArray.isEmpty) {
      return '';
    }

    String text = '';

    for (int i = 0; i < byteArray.length; i++) {
      // преобразуем код символа в символ и добавляем в текст
      text += String.fromCharCode(byteArray[i]);
    }

    // удаляем лишние символы в конце текста
    int padding = byteArray.last;
    if (padding > 0 && padding < 4) {
      text = text.substring(0, text.length - padding);
    }

    return text;
  }
}

class EncodingResult {
  final List<int> aesResult;
  final List<int> rsaKey;

  EncodingResult({required this.aesResult, required this.rsaKey});
}
