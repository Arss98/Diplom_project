import 'dart:math';

class FermatTest {
  // Проверяет, является ли заданное число n вероятно простым с вероятностью ошибки не более 2^(-k).
  static bool isProbablePrime(int n, [int k = 1]) {
    // Если число n равно 2 или 3, то оно является простым.
    if (n == 2 || n == 3) {
      return true;
    }

    // Если число n равно 1 или четное, то оно является составным.
    if (n == 1 || n.isEven) {
      return false;
    }

    // Повторяем тест Ферма k раз.
    for (int i = 0; i < k; i++) {
      // Генерируем случайное число a от 2 до n - 1.
      final a = _randomBetween(2, n - 1);
      // Если a^(n-1) mod n не равно 1, то число n составное.
      if (_modularExp(a, n - 1, n) != 1) {
        return false;
      }
    }

    // Если число n прошло все k тестов, то оно вероятно простое.
    return true;
  }

  // Генерирует случайное число от min до max включительно.
  static int _randomBetween(int min, int max) {
    final random = Random.secure(); // Создаем генератор случайных чисел.
    final bound = max - min; // Вычисляем размер диапазона для генерации чисел.
    final bytes = bound.bitLength ~/ 8 +
        1; // Вычисляем количество байт, которое нужно сгенерировать.
    int result;
    do {
      // Генерируем случайное число размером bytes байт,
      // объединяем его в шестнадцатеричную строку и преобразуем в BigInt.
      result = int.tryParse(
              '0x${List.generate(bytes, (_) => random.nextInt(256)).join()}') ??
          1;
    } while (result > bound); // Если число больше диапазона, генерируем заново.
    return min + result; // Возвращаем случайное число.
  }

  // Вычисляет a^b mod m при помощи алгоритма "Быстрое возведение в степень".
  static int _modularExp(int base, int exponent, int modulus) {
    int localBase = base;
    int localExponent = exponent;

    if (modulus == 1) {
      return 0;
    }
    int result = 1; // Инициализируем результат единицей.
    localBase = localBase % modulus;

    while (localExponent > 0) {
      // Если степень четная, делим ее пополам.
      if ((exponent & 1) == 1) {
        result = (result * localBase) %
            modulus; // Если бит степени равен 1, умножаем текущий результат на основание по модулю.
      }
      localExponent = localExponent >> 1; // Уменьшаем степень вдвое.
      localBase = (localBase * localBase) %
          modulus; // Возводим основание в квадрат по модулю.
    }

    return result; // Возвращаем результат.
  }
}
