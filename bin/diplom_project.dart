import 'dart:typed_data';

import 'RSA/generate_key_rsa.dart';
import 'RSA/rsa.dart';

void main() {
  const message = 'я люблю кушать';
  final rsa = RSAKeyPair();
  final keys = rsa.generateRSAKeys(2);
  final publicKey = rsa.decodePublicKey(keys['publicKey']!);
  final privateKey = rsa.decodePrivateKey(keys['privateKey']!);

  final e = publicKey['e']!;
  final n = publicKey['n']!;

  final d = privateKey['d']!;

  // const message = 'я люблю кушать';

  // final p = 3557;
  // final q = 2579;

  // final d = 1527895;
  // final e = 3;
  // final n = 9173503;

  final encodedMessage = RSA.encode(message, e, n);
  print(encodedMessage);

  final decodedMessage = RSA.decode(encodedMessage, d, n);
  print(decodedMessage);
}
