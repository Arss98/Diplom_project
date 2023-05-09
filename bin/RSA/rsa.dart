import 'dart:math';

import '../config/utils.dart';
import 'consts.dart';

class RSA {
  static List<String> encode(String message, int e, int n) {
    List<String> result = [];
    int number;

    String upperMessage = message.toUpperCase();

    for (int i = 0; i < upperMessage.length; i++) {
      int index = Consts.characters.indexOf(upperMessage[i]);
      int resultNumber = pow(index, e).toInt() % n;
      result.add(resultNumber.toString());
    }

    return result;
  }

  static String decode(List<String> message, int d, int n) {
    String result = '';
    late int number;

    for (var item in message) {
      int tmp = int.parse(item);
      number = tmp;

      int resultNumber = tmp.modPow(d, n);

      int index = resultNumber.toInt();
      print(index);
      result += Consts.characters[index].toString();
    }

    return result;
  }
}
