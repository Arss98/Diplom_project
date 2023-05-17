import 'consts_aes.dart';

class SecondaryFunctionsAES {
  static int getBit(int value, int i) {
    final List<int> bMasks = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80];
    int bBit = value & bMasks[i];
    return (bBit >> i) & 0x01;
  }

  static int xtime(int value) {
    int iResult = (value & 0x000000ff) * 2;
    return ((iResult & 0x100) != 0) ? iResult ^ 0x11b : iResult;
  }

  static int finiteMultiplication(int v1, int v2) =>
      finiteMultiplicationInt(v1.toUnsigned(8), v2.toUnsigned(8));

  static int finiteMultiplicationInt(int v1, int v2) {
    List<int> bTemps = List<int>.filled(8, 0);
    int bResult = 0;
    bTemps[0] = v1;
    for (int i = 1; i < bTemps.length; i++) {
      bTemps[i] = xtime(bTemps[i - 1]);
    }
    for (int i = 0; i < bTemps.length; i++) {
      if (getBit(v2, i) != 1) {
        bTemps[i] = 0;
      }
      bResult ^= bTemps[i];
    }
    return bResult;
  }

  static int sboxTransform(int value) {
    int bUpper = 0, bLower = 0;
    bUpper = ((value >> 4) & 0x0f);
    bLower = (value & 0x0f);
    return ConstsAES.sbox[bUpper][bLower];
  }

  /*
  Функция `subBytes` заменяет каждый байт текущего состояния `state` новым
  байтом, вычисленным с помощью таблицы подстановки (S-Box). 
  */
  static List<List<int>> subBytes(List<List<int>> state) {
    for (int i = 0; i < state.length; i++) {
      for (int j = 0; j < state[i].length; j++) {
        state[i][j] = sboxTransform(state[i][j]);
      }
    }
    return state;
  }

/*
Функция `shiftRows` выполняет циклический сдвиг каждой строки состояния `state` 
на определенное количество позиций влево. 
 */
  static List<List<int>> shiftRows(List<List<int>> state, int nb) {
    List<List<int>> stateNew = List.generate(
        state.length, (i) => List.generate(state[i].length, (j) => 0));

    // r=0 is not shifted
    stateNew[0] = state[0];

    for (int r = 1; r < state.length; r++) {
      for (int c = 0; c < state[r].length; c++) {
        stateNew[r][c] = state[r][(c + shift(r, nb)) % nb];
      }
    }

    return stateNew;
  }

  static int shift(int r, int iNb) => r;

/*
Функция `mixColumns` перемножает каждый столбец состояния `state` на
фиксированную матрицу. 
 */
  static List<List<int>> mixColumns(List<List<int>> state, int nb) {
    final stateNew = List.generate(
        state.length, (i) => List.generate(state[i].length, (_) => 0));

    for (var c = 0; c < nb; c++) {
      stateNew[0][c] = (xtime(state[0][c]) ^
          (state[1][c] ^ xtime(state[1][c])) ^
          state[2][c] ^
          state[3][c]);
      stateNew[1][c] = (state[0][c] ^
          xtime(state[1][c]) ^
          (state[2][c] ^ xtime(state[2][c])) ^
          state[3][c]);
      stateNew[2][c] = (state[0][c] ^
          state[1][c] ^
          xtime(state[2][c]) ^
          (state[3][c] ^ xtime(state[3][c])));
      stateNew[3][c] = ((state[0][c] ^ xtime(state[0][c])) ^
          state[1][c] ^
          state[2][c] ^
          xtime(state[3][c]));
    }

    return stateNew;
  }

  static int xor4Bytes(int b1, int b2, int b3, int b4) {
    int bResult = 0;
    bResult ^= b1;
    bResult ^= b2;
    bResult ^= b3;
    bResult ^= b4;
    return bResult;
  }

  /*
  Функция `addRoundKey` применяет операцию побитового исключающего ИЛИ (XOR) 
  между состоянием `state` и ключом развертки `w` для соответствующего раунда. 
  */
  static List<List<int>> addRoundKey(
      List<List<int>> state, List<int> w, int l, int nb) {
    List<List<int>> stateNew = List.generate(
        state.length, (i) => List.generate(state[i].length, (j) => 0));

    for (int c = 0; c < nb; c++) {
      stateNew[0][c] = (state[0][c] ^ getByte(w[l + c], 3));
      stateNew[1][c] = (state[1][c] ^ getByte(w[l + c], 2));
      stateNew[2][c] = (state[2][c] ^ getByte(w[l + c], 1));
      stateNew[3][c] = (state[3][c] ^ getByte(w[l + c], 0));
    }
    return stateNew;
  }

  static int getByte(int value, int iByte) =>
      (value >> (iByte * 8)) & 0x000000ff;

  static List<List<int>> invShiftRows(List<List<int>> state, int nb) {
    List<List<int>> stateNew = List.generate(
        state.length, (_) => List<int>.filled(state[0].length, 0));
    // r=0 is not shifted
    stateNew[0] = state[0];
    for (int r = 1; r < state.length; r++) {
      for (int c = 0; c < state[r].length; c++) {
        stateNew[r][(c + shift(r, nb)) % nb] = state[r][c];
      }
    }
    return stateNew;
  }

  static List<List<int>> invSubBytes(List<List<int>> state) {
    for (int i = 0; i < state.length; i++) {
      for (int j = 0; j < state[i].length; j++) {
        state[i][j] = invSboxTransform(state[i][j]);
      }
    }
    return state;
  }

  static int invSboxTransform(int value) {
    int bUpper = 0;
    int bLower = 0;
    bUpper = ((value >> 4) & 0x0f);
    bLower = (value & 0x0f);
    return ConstsAES.sboxInv[bUpper][bLower];
  }

  static List<List<int>> invMixColumns(List<List<int>> state, int nb) {
    List<List<int>> stateNew = List.generate(
        state.length, (_) => List<int>.filled(state[0].length, 0));

    for (int c = 0; c < nb; c++) {
      stateNew[0][c] = xor4Bytes(
          finiteMultiplication(state[0][c], 0x0e),
          finiteMultiplication(state[1][c], 0x0b),
          finiteMultiplication(state[2][c], 0x0d),
          finiteMultiplication(state[3][c], 0x09));
      stateNew[1][c] = xor4Bytes(
          finiteMultiplication(state[0][c], 0x09),
          finiteMultiplication(state[1][c], 0x0e),
          finiteMultiplication(state[2][c], 0x0b),
          finiteMultiplication(state[3][c], 0x0d));
      stateNew[2][c] = xor4Bytes(
          finiteMultiplication(state[0][c], 0x0d),
          finiteMultiplication(state[1][c], 0x09),
          finiteMultiplication(state[2][c], 0x0e),
          finiteMultiplication(state[3][c], 0x0b));
      stateNew[3][c] = xor4Bytes(
          finiteMultiplication(state[0][c], 0x0b),
          finiteMultiplication(state[1][c], 0x0d),
          finiteMultiplication(state[2][c], 0x09),
          finiteMultiplication(state[3][c], 0x0e));
    }

    return stateNew;
  }
}
