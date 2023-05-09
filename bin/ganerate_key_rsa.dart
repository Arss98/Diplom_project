import 'dart:math';

import 'fermat_test.dart';

class RSAKeyPairr {
  late BigInt n;
  late BigInt e;
  late BigInt d;
  static final random = Random.secure();

  Map<String, String> generateRSAKeys(int bitLength) {
    final p = _generatePrimeNumber(bitLength);
    final q = _generatePrimeNumber(bitLength);
    n = p * q;

    final phi = (p - BigInt.one) * (q - BigInt.one); //Вычисляем функцию Эйлера

    // Выбираем открытый ключ e (e < phi(n))
    e = _randomCoPrime(phi);

    // Вычисляем закрытый ключ d (d * e = 1 (mod phi(n)))
    d = _modularMultiplicativeInverse(e, phi);

    return {
      'publicKey': _encodePublicKey(e, n),
      'privateKey': _encodePrivateKey(d, n),
      'pairPrime': _encodePairPrime(p, q)
    };
  }

  //Функция для генерации рандомного простого числа
  BigInt _generatePrimeNumber(int bitLength) {
    while (true) {
      final n = BigInt.from(1) <<
          (bitLength - 1) + random.nextInt(1 << (bitLength - 2));
      if (!FermatTest.isProbablePrime(n)) {
        return n;
      }
    }
  }

  // Функция для генерации случайного взаимно простого числа
  BigInt _randomCoPrime(BigInt phi) {
    final random = Random.secure();
    BigInt r;
    do {
      // Генерируем случайное число размером phi.bitLength бит.
      // Это число должно быть меньше phi(n) и нечётным.
      r = BigInt.parse(
          '0x${List.generate(phi.bitLength, (_) => random.nextInt(16)).join()}');
      r = r % phi;

      // Если r равно 0 или имеет общий делитель с phi(n), генерируем его заново.
    } while (r == BigInt.zero || _gcd(r, phi) != BigInt.one);

    // Возвращаем случайное взаимно простое число.
    return r;
  }

  BigInt _gcd(BigInt a, BigInt b) {
    BigInt localA = a.abs(); // Берем абсолютное значение a.
    BigInt localB = b.abs(); // Берем абсолютное значение b.

    // Пока b не станет равным нулю, находим остаток от деления a на b
    // и присваиваем оставшееся значение b, а a присваиваем значение b.
    while (localB != BigInt.zero) {
      final r = localA % localB;
      localA = localB;
      localB = r;
    }

    // Возвращаем наибольший общий делитель a.
    return localA;
  }

  BigInt _modularMultiplicativeInverse(BigInt a, BigInt m) {
    BigInt localM = m;
    BigInt localA = a;
    BigInt m0 = localM;
    BigInt t = BigInt.zero;
    BigInt q = BigInt.zero;
    BigInt x0 = BigInt.zero;
    BigInt x1 = BigInt.one;

    if (localM == BigInt.one) {
      return BigInt.zero;
    }

    while (localA > BigInt.one) {
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
  String _encodePublicKey(BigInt e, BigInt n) => '$e:$n'.toString();

  // Декодирование открытого ключа из строки
  Map<String, BigInt> decodePublicKey(String publicKey) {
    List<String> parts = publicKey.split(':');
    final BigInt e = BigInt.parse(parts[0]);
    final BigInt n = BigInt.parse(parts[1]);
    return {'n': n, 'e': e};
  }

  // Кодирование закрытого ключа (d, n)
  String _encodePrivateKey(BigInt d, BigInt n) => '$d:$n'.toString();

  // Декодирование закрытого ключа из строки
  Map<String, BigInt> decodePrivateKey(String privateKey) {
    List<String> parts = privateKey.split(':');
    final BigInt d = BigInt.parse(parts[0]);
    final BigInt n = BigInt.parse(parts[1]);
    return {'d': d, 'n': n};
  }

  String _encodePairPrime(BigInt p, BigInt q) => '$p:$q'.toString();

  List<BigInt> decodePairPrime(String pairPrime) {
    List<String> parts = pairPrime.split(':');
    final BigInt p = BigInt.parse(parts[0]);
    final BigInt q = BigInt.parse(parts[1]);
    return [p, q];
  }
}
