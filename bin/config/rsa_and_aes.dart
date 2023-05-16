import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../AES/aes.dart';
import '../AES/convert_data_aes.dart';
import '../RSA/generate_key_rsa.dart';
import '../RSA/rsa.dart';

class RSAandAES {
  late int publicExponent;
  late int privateExponent;
  late int modulus;
  late String keyAES;

  RSAandAES() {
    final rsa = RSAKeyPair();
    final keys = rsa.generateRSAKeys(12);
    final publicKey = rsa.decodePublicKey(keys['publicKey']!);
    final privateKey = rsa.decodePrivateKey(keys['privateKey']!);

    publicExponent = publicKey['e']!;
    privateExponent = publicKey['n']!;

    modulus = privateKey['d']!;

    keyAES = _generateRandomKey();
  }
  void encryptAesRsa(String message) {
    final messageByte = _convertTextToByteArray(message);
    AES aes = AES(_stringToUint8List(keyAES));
    final aesCryptingData = ConvertDataAes.encryptData(messageByte, aes);
    final encryptKeyAES = RSA.encode(keyAES, publicExponent, modulus);
    print('aes: $aesCryptingData');
    print('rsa: $encryptKeyAES');
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
}
