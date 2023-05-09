import 'RSA/generate_key_rsa.dart';
import 'RSA/rsa.dart';

void main() {
  const message =
      'я чет устал сидеть за компом и хотелось бы прилечь поспать, но нужнопосидеть еще за компом и поработать';

  final rsa = RSAKeyPair();
  final keys = rsa.generateRSAKeys(12);
  final publicKey = rsa.decodePublicKey(keys['publicKey']!);
  final privateKey = rsa.decodePrivateKey(keys['privateKey']!);

  final e = publicKey['e']!;
  final n = publicKey['n']!;

  final d = privateKey['d']!;

  final encodedMessage = RSA.encode(message, e, n);
  print(encodedMessage);

  final decodedMessage = RSA.decode(encodedMessage, d, n);
  print(decodedMessage);
}
