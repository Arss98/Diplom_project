import 'dart:math';

class RSAKeys {
  // comment
  final int p;
  final int q;
  late int e;
  late int d;

  RSAKeys({required this.p, required this.q}) {
    generateRandomCoprime(getTotN());
    modInverse(e);
  }

  int getN() => p * q;
  int getTotN() => (p - 1) * (q - 1);

  int gcd(int a, int b) {
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

  void generateRandomCoprime(int phi) {
    final Random random = Random.secure();
    int r;

    do {
      r = random.nextInt(phi - 1) + 1;
    } while (gcd(r, phi) != 1);

    this.e = r;
  }

  void modInverse(int e) {
    this.d = e.modInverse(getTotN());
  }
}

// final keys = RSAKeys(p: 3557, q: 2579);

//   const message = 'я люблю кушать';
//   final n = keys.getN();
//   final e = keys.e;
//   final d = keys.d;
