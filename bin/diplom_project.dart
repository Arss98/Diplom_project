import 'config/rsa_and_aes.dart';

void main() {
  final crypto = RSAandAES();

  const String plaintext = 'Hello, World! This is test';

  crypto.encryptAesRsa(plaintext);
}
