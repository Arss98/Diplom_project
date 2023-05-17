import 'consts_aes.dart';
import 'secondary_functions_aes.dart';

class AESKeyExpansion {
  void keyExpansion(List<int> key, List<int> w, int nk, int nb, int nr) {
    int iTemp = 0;
    int i = 0;

    while (i < nk) {
      w[i] = toWord(key[4 * i], key[4 * i + 1], key[4 * i + 2], key[4 * i + 3]);
      i++;
    }

    i = nk;

    while (i < nb * (nr + 1)) {
      iTemp = w[i - 1];
      if (i % nk == 0) {
        iTemp = subWord(rotWord(iTemp)) ^ ConstsAES.rcon[i ~/ nk];
      } else if (nk > 6 && i % nk == 4) {
        iTemp = subWord(iTemp);
      }
      w[i] = w[i - nk] ^ iTemp;
      i++;
    }
  }

  /* 
  Функция выполняет замену элементов 4-байтного слова word с помощью таблицы 
  подстановки (S-Box) и возвращает новое слово.
  */
  int subWord(int word) =>
      SecondaryFunctionsAES.sboxTransform(word >> 24 & 0xff) |
      (SecondaryFunctionsAES.sboxTransform(word >> 16 & 0xff) << 8) |
      (SecondaryFunctionsAES.sboxTransform(word >> 8 & 0xff) << 16) |
      (SecondaryFunctionsAES.sboxTransform(word & 0xff) << 24);

  int rotWord(int word) => (word << 8 | ((word >> 24) & 0xff));

  int toWord(int b1, int b2, int b3, int b4) =>
      (b1 << 24) | (b2 << 16) | (b3 << 8) | b4;
}
