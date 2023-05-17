import 'package:cryptography/config/rsa_and_aes.dart';
import 'package:flutter/material.dart';
import 'package:ui/crypt_screen/crypt_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MARK: Dependencies
    final cryptoService = RSAandAES(1, 1, 1, randomGeneratedKeys: true);

    return MaterialApp(
      title: 'Crypto Demo',
      home: CryptScreen(cryptoService: cryptoService),
    );
  }
}
