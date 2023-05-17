import 'dart:math';

class FermatTest {
  // Проверяет, является ли заданное число n вероятно простым с вероятностью ошибки не более 2^(-k).
  static bool fermatTest(int n, [int k = 4]) {
    // Если n = 1 или 2, то сразу возвращаем true
    if (n == 1 || n == 2) {
      return true;
    }

    for (int i = 0; i < k; i++) {
      // Генерируем случайное целое число a от 2 до n-1
      int a = Random().nextInt(n - 2) + 2;

      // Вычисляем a^(n-1) mod n при помощи функции возведения в степень по модулю
      int res = a.modPow(n - 1, n);

      // Если a^(n-1) mod n != 1, то число n составное
      if (res != 1) {
        return false;
      }
    }
    // Если условие в цикле выполнилось k раз и не было найдено показательное свидетельство,
    // то число n простое с высокой вероятностью
    return true;
  }

  static bool isPrime(int n) {
    if (n < 2) {
      return false;
    }
    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) {
        return false;
      }
    }
    return true;
  }
}
