import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

import 'ganerate_key_rsa.dart';

void main() {
  // Генерируем пару ключей RSA
  final keyPair = _generateRSAKeys();

  final message = Uint8List.fromList('a'.codeUnits);
  final encrypted = rsaEncrypt(keyPair.publicKey, message);
  final decrypted = rsaDecrypt(keyPair.privateKey, encrypted);

  print('Original message: $message');
  print('Encrypted message: ${String.fromCharCodes(encrypted)}');
  print('Decrypted message: ${String.fromCharCodes(decrypted)}');
}

// Функция для генерации пары ключей RSA
RSAKeyPair _generateRSAKeys() {
  final rsa = RSAKeyPairr();
  // final encryptionRSA = RSAEncryption();
  final keys = rsa.generateRSAKeys(16);
  final pairPrime = rsa.decodePairPrime(keys['pairPrime']!);
  final publicKeyCustom = rsa.decodePublicKey(keys['publicKey']!);
  final privateKeyCustom = rsa.decodePrivateKey(keys['privateKey']!);
  final nCustom = rsa.n;
  final eCustom = publicKeyCustom['e'];
  final dCustom = privateKeyCustom['d'];
  // print(eCustom);

  return RSAKeyPair(
    n: nCustom,
    e: eCustom!,
    d: dCustom!,
    p: pairPrime[0],
    q: pairPrime[1],
  );
}

Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
  final encryptor = OAEPEncoding(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

  return _processInBlocks(encryptor, dataToEncrypt);
}

Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
  final decryptor = OAEPEncoding(RSAEngine())
    ..init(
        false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

  return _processInBlocks(decryptor, cipherText);
}

Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
  final numBlocks = input.length ~/ engine.inputBlockSize +
      ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

  final output = Uint8List(numBlocks * engine.outputBlockSize);

  var inputOffset = 0;
  var outputOffset = 0;
  while (inputOffset < input.length) {
    final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
        ? engine.inputBlockSize
        : input.length - inputOffset;

    outputOffset += engine.processBlock(
        input, inputOffset, chunkSize, output, outputOffset);

    inputOffset += chunkSize;
  }

  return (output.length == outputOffset)
      ? output
      : output.sublist(0, outputOffset);
}

// Класс для хранения ключей RSA
class RSAKeyPair {
  final BigInt n;
  final BigInt e;
  final BigInt d;
  final BigInt p;
  final BigInt q;

  RSAKeyPair({
    required this.n,
    required this.e,
    required this.d,
    required this.p,
    required this.q,
  });

  RSAPrivateKey get privateKey => RSAPrivateKey(n, d, p, q);
  RSAPublicKey get publicKey => RSAPublicKey(n, privateKey.publicExponent!);
}
