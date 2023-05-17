import 'package:flutter/material.dart';
import 'package:cryptography/config/rsa_and_aes.dart';
import 'package:ui/crypt_screen/consts.dart';

class CryptScreen extends StatefulWidget {
  final RSAandAES cryptoService;

  const CryptScreen({super.key, required this.cryptoService});

  @override
  State<StatefulWidget> createState() => _CryptScreenState();
}

class _CryptScreenState extends State<CryptScreen> {
  // Internal
  var userMessage = "";

  // For crypt
  var encrypted = [] as List<int>;
  var rsaKey = [] as List<int>;

  // For screen
  var encryptedMessage = "";
  var decryptedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 32),
              const Text(
                "Введите сообщение",
                style: Consts.textStyle,
              ),
              TextField(
                style: Consts.textStyle,
                onSubmitted: onSubmittedTF,
              ),
              const SizedBox(height: 32),
              const Text(
                'Введенное сообщение: ',
                style: Consts.textStyle,
              ),
              const SizedBox(height: 4),
              Container(
                  decoration: Consts.boxStyle,
                  padding: const EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width,
                  child: Text(userMessage)),
              const Spacer(),
              const Text(
                'Зашифрованное сообщение: ',
                style: Consts.textStyle,
              ),
              const SizedBox(height: 4),
              Container(
                  decoration: Consts.boxStyle,
                  padding: const EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width,
                  child: Text(encryptedMessage)),
              const SizedBox(height: 8),
              _onEncodeButton(),
              const SizedBox(height: 16),
              const Text(
                'Расшифрованное сообщение: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Container(
                  decoration: Consts.boxStyle,
                  padding: const EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width,
                  child: Text(decryptedMessage)),
              const SizedBox(height: 8),
              _onDecodeButton(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmittedTF(String value) {
    setState(() {
      userMessage = value;
    });
  }

  Widget _onEncodeButton() {
    return Container(
      alignment: Alignment.center,
      child: FilledButton(
        style: Consts.buttonStyle,
        onPressed: userMessage.isEmpty
            ? null
            : () {
                final result = widget.cryptoService.encryptData(userMessage);
                setState(() {
                  encrypted = result.aesResult;
                  rsaKey = result.rsaKey;
                  encryptedMessage = result.aesResult
                      .toString()
                      .replaceAll('[', '')
                      .replaceAll(']', '')
                      .replaceAll(',', '')
                      .replaceAll(' ', '');
                });
              },
        child: const Text("Зашифровать сообщение"),
      ),
    );
  }

  Widget _onDecodeButton() {
    return Container(
      alignment: Alignment.center,
      child: FilledButton(
        style: Consts.buttonStyle,
        onPressed: encryptedMessage.isEmpty
            ? null
            : () {
                final result =
                    widget.cryptoService.decryptData(encrypted, rsaKey);
                setState(() {
                  decryptedMessage = result;
                });
              },
        child: const Text("Расшифровать сообщение"),
      ),
    );
  }
}
