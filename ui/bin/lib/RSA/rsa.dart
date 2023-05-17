import 'dart:convert';

class RSA {
  static List<int> encode(String message, int e, int n) {
    List<int> result = [];
    final utf8ByteMessage = utf8.encode(message);

    for (final index in utf8ByteMessage) {
      int resultNumber = index.modPow(e, n);
      result.add(resultNumber.toInt());
    }

    return result;
  }

  static String decode(List<int> message, int d, int n) {
    final String result;
    final List<int> listByteDecode = [];

    for (final item in message) {
      int tmp = item;

      listByteDecode.add(tmp.modPow(d, n));
    }

    result = utf8.decode(listByteDecode);

    return result;
  }
}
