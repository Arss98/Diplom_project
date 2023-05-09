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
    e = _randomCoPrime(phi);

    // Вычисляем закрытый ключ d (d * e = 1 (mod phi(n)))
    d = _modularMultiplicativeInverse(e, phi);

    return {
      'publicKey': _encodePublicKey(e, n),
      'privateKey': _encodePrivateKey(d, n),
    };
  }

  //Функция для генерации рандомного простого числа
  int _generatePrimeNumber(int bitLength) {
    while (true) {
      final n = 1 << (bitLength - 1) + random.nextInt(1 << (bitLength - 2));
      if (!FermatTest.isProbablePrime(n)) {
        return n;
      }
    }
  }

  // Функция для генерации случайного взаимно простого числа
  int _randomCoPrime(int phi) {
    final random = Random.secure();
    int r;
    do {
      // Генерируем случайное число размером phi.bitLength бит.
      // Это число должно быть меньше phi(n) и нечётным.
      r = int.parse(
          '0x${List.generate(phi.bitLength, (_) => random.nextInt(16)).join()}');
      r = r % phi;

      // Если r равно 0 или имеет общий делитель с phi(n), генерируем его заново.
    } while (r == 0 || _gcd(r, phi) != 0);

    // Возвращаем случайное взаимно простое число.
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

  int _modularMultiplicativeInverse(int a, int m) {
    int localM = m;
    int localA = a;
    int m0 = localM;
    int t = 0;
    int q = 0;
    int x0 = 0;
    int x1 = 1;

    if (localM == 1) {
      return 0;
    }

    while (localA > 1) {
      q = localA ~/ localM;
      t = localM;
      localM = localA % localM;
      localA = t;
      t = x0;
      x0 = x1 - q * x0;
      x1 = t;
    }

    return x1.isNegative ? x1 + m0 : x1;
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
