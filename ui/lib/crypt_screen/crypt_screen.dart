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
  var encrypted = <int>[];
  var rsaKey = <int>[];

  // For screen
  var encryptedMessage = "";
  var decryptedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _updateButton(),
                _userMessageBlock(),
                const SizedBox(height: 48),
                const Text(
                  'Результаты',
                  style: Consts.bigTextStyle,
                ),
                SizedBox(height: 16),
                encodeBlock(),
                const SizedBox(height: 16),
                decodeBlock(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmittedTF(String value) {
    setState(() {
      userMessage = value;
    });
  }

  void _onUpdateScreen() {
    setState(() {
      userMessage = "";
      encrypted = <int>[];
      rsaKey = <int>[];
      encryptedMessage = "";
      decryptedMessage = "";
    });
  }

  Widget _updateButton() {
    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerRight,
      child: IconButton(
        color: Colors.orangeAccent,
        onPressed: _onUpdateScreen,
        icon: const Icon(Icons.update),
      ),
    );
  }

  Widget _userMessageBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 32),
        const Text(
          "Введите сообщение",
          style: Consts.bigTextStyle,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: Consts.tfStyle,
          style: Consts.textStyle,
          onSubmitted: _onSubmittedTF,
        ),
        const SizedBox(height: 16),
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
      ],
    );
  }

  Widget encodeBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Зашифрованное сообщение: ',
          style: Consts.textStyle,
        ),
        const SizedBox(height: 8),
        Container(
            decoration: Consts.boxStyle,
            padding: const EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width,
            child: Text(encryptedMessage)),
        const SizedBox(height: 10),
        _onEncodeButton(),
      ],
    );
  }

  Widget decodeBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Расшифрованное сообщение: ',
          style: Consts.textStyle,
        ),
        const SizedBox(height: 8),
        Container(
            decoration: Consts.boxStyle,
            padding: const EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width,
            child: Text(decryptedMessage)),
        const SizedBox(height: 10),
        _onDecodeButton(),
      ],
    );
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
        child: const Text(
          "Зашифровать сообщение",
          style: TextStyle(color: Colors.white),
        ),
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
        child: const Text("Расшифровать сообщение",
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
