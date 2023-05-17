import 'dart:math';

class DiffieHellman {
  late int _privateKey;
  late int _publicKey;
  late int _sharedKey;

  DiffieHellman(int p, int g) {
    _privateKey =
        Random().nextInt(p - 2) + 2; // генерируем случайный приватный ключ
    _publicKey = _modularExponentiation(
        g, _privateKey, p); // вычисляем соответствующий открытый ключ
  }

  int getPublicKey() => _publicKey;

  void setSharedKey(int publicKey) {
    _sharedKey = _modularExponentiation(publicKey, _privateKey);
  }

  int getSharedKey() => _sharedKey;

  int _modularExponentiation(int base, int exponent, [int modulus = 0]) {
    var localModulus = modulus;
    var localBase = base;
    var localExponent = exponent;

    if (localModulus == 0) {
      localModulus = (pow(2, 31) - 1).toInt();
    }
    int result = 1;
    while (localExponent > 0) {
      if (localExponent % 2 == 1) {
        result = (result * localBase) % localModulus;
      }
      localBase = (localBase * localBase) % localModulus;
      localExponent = localExponent ~/ 2;
    }
    return result;
  }
}
