import 'dart:math';

import 'fermat_test.dart';

class RSAKeyPair {
  late int n;
  late int e;
  late int d;
  static final random = Random.secure();

  Map<String, String> generateRSAKeys(int bitLength) {
    final p = _generatePrimeNumber(bitLength);
    final q = _generatePrimeNumber(bitLength);
    n = p * q;

    final phi = (p - 1) * (q - 1); //Вычисляем функцию Эйлера

    // Выбираем открытый ключ e (e < phi(n))
    e = _generateRandomCoPrime(phi);

    // Вычисляем закрытый ключ d (d * e = 1 (mod phi(n)))
    d = e.modInverse((p - 1) * (q - 1));

    return {
      'publicKey': _encodePublicKey(e, n),
      'privateKey': _encodePrivateKey(d, n),
    };
  }

  //Функция для генерации рандомного простого числа
  int _generatePrimeNumber(int n) {
    final Random random = Random.secure();
    int p = (1 << n) + random.nextInt(1 << (n - 1));
    while (!FermatTest.fermatTest(p, 10)) {
      p = (1 << n) + random.nextInt(1 << (n - 1));
    }
    return p;
  }

  // Функция для генерации случайного взаимно простого числа

  int _generateRandomCoPrime(int phi) {
    final Random random = Random.secure();
    int r;
    do {
      r = random.nextInt(phi - 1) + 1;
    } while (_gcd(r, phi) != 1);
    return r;
  }

  int _gcd(int a, int b) {
    int localA = a.abs(); // Берем абсолютное значение a.
    int localB = b.abs(); // Берем абсолютное значение b.

    // Пока b не станет равным нулю, находим остаток от деления a на b
    // и присваиваем оставшееся значение b, а a присваиваем значение b.
    while (localB != 0) {
      final r = localA % localB;
      localA = localB;
      localB = r;
    }

    // Возвращаем наибольший общий делитель a.
    return localA;
  }

  // Кодирование открытого ключа (e, n)
  String _encodePublicKey(int e, int n) => '$e:$n'.toString();

  // Декодирование открытого ключа из строки
  Map<String, int> decodePublicKey(String publicKey) {
    List<String> parts = publicKey.split(':');
    final int e = int.parse(parts[0]);
    final int n = int.parse(parts[1]);
    return {'n': n, 'e': e};
  }

  // Кодирование закрытого ключа (d, n)
  String _encodePrivateKey(int d, int n) => '$d:$n'.toString();

  // Декодирование закрытого ключа из строки
  Map<String, int> decodePrivateKey(String privateKey) {
    List<String> parts = privateKey.split(':');
    final int d = int.parse(parts[0]);
    final int n = int.parse(parts[1]);
    return {'d': d, 'n': n};
  }
}
