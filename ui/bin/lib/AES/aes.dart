import 'dart:typed_data';

import 'key_expansion.dart';
import 'secondary_functions_aes.dart';

class AES {
  final int nb = 4;
  final int nr;
  final List<int> w;

  AES(Uint8List key)
      : nr = (key.length == 32) ? 14 : ((key.length == 24) ? 12 : 10),
        w = List.filled(
          (key.length == 32)
              ? 60
              : (key.length == 24)
                  ? 52
                  : 44,
          0,
        ) {
    final keysExpansion = AESKeyExpansion();
    // ignore: cascade_invocations
    keysExpansion.keyExpansion(key, w, key.length ~/ 4, nb, nr);
  }

  List<List<int>> cipher(List<int> bytesMessage) {
    var state = convertIntListToByteList(bytesMessage);

    state = SecondaryFunctionsAES.addRoundKey(state, w, 0, nb);

    for (var round = 1; round <= nr - 1; round++) {
      state = SecondaryFunctionsAES.subBytes(state);
      state = SecondaryFunctionsAES.shiftRows(state, nb);
      state = SecondaryFunctionsAES.mixColumns(state, nb);
      state = SecondaryFunctionsAES.addRoundKey(state, w, round * nb, nb);
    }

    state = SecondaryFunctionsAES.subBytes(state);
    state = SecondaryFunctionsAES.shiftRows(state, nb);
    state = SecondaryFunctionsAES.addRoundKey(state, w, nr * nb, nb);
    return state;
  }

  List<List<int>> invCipher(List<int> bytesMessage) {
    var state = convertIntListToByteList(bytesMessage);

    state = SecondaryFunctionsAES.addRoundKey(state, w, nr * nb, nb);

    for (var round = nr - 1; round >= 1; round--) {
      state = SecondaryFunctionsAES.invShiftRows(state, nb);
      state = SecondaryFunctionsAES.invSubBytes(state);
      state = SecondaryFunctionsAES.addRoundKey(state, w, round * nb, nb);
      state = SecondaryFunctionsAES.invMixColumns(state, nb);
    }
    state = SecondaryFunctionsAES.invShiftRows(state, nb);
    state = SecondaryFunctionsAES.invSubBytes(state);
    state = SecondaryFunctionsAES.addRoundKey(state, w, 0, nb);

    return state;
  }

  List<List<int>> convertIntListToByteList(List<int> intList) {
    const int bytesPerInt = 4;
    final List<List<int>> output = [];

    for (var i = 0; i < intList.length; i += bytesPerInt) {
      final sublist = intList.sublist(i, i + bytesPerInt);
      output.add(sublist);
    }

    return output;
  }
}
