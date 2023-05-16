import '../AES/aes.dart';

class ConvertDataAes {
  static List<int> encryptData(List<int> data, AES aes) {
    // Определение размера блока данных
    const int blockSize = 16;
    // Дополнение данных, если необходимо
    final int paddingLength = blockSize - (data.length % blockSize);
    final paddedData = List<int>.filled(data.length + paddingLength, 0)
      ..setRange(0, data.length, data);
    paddedData.fillRange(data.length, paddedData.length, paddingLength);

    final List<int> output = List<int>.filled(paddedData.length, 0);

    // Шифрование каждого блока
    for (int i = 0; i < paddedData.length; i += blockSize) {
      final block = paddedData.sublist(i, i + blockSize);
      output.setRange(
          i, i + blockSize, aes.cipher(block).expand((lst) => lst).toList());
    }
    return output;
  }

  static List<int> decryptData(List<int> data, AES aes) {
    // Определение размера блока данных
    const int blockSize = 16;
    final countBlock = (data.length / blockSize).ceil();
    final List<int> output = List<int>.filled(data.length, 0);
    List<int> block = List<int>.filled(0, 0);

    // Расшифрование каждого блока
    for (int i = 0; i < countBlock; i++) {
      if (data.length - blockSize * i >= blockSize) {
        block = data.sublist(i * blockSize, (i + 1) * blockSize);
        output.setRange(i * blockSize, (i + 1) * blockSize,
            aes.invCipher(block).expand((lst) => lst).toList());
      } else {
        block = data.sublist(i * blockSize, data.length);
        output.setRange(i * blockSize, data.length,
            aes.invCipher(block).expand((lst) => lst).toList());
      }
    }

    return output;
  }

  String _convertByteArrayToText(List<int> byteArray) {
    // Если массив байтов пустой, то возращаем пустую строку
    if (byteArray.isEmpty) {
      return '';
    }

    String text = '';

    for (int i = 0; i < byteArray.length; i++) {
      // преобразуем код символа в символ и добавляем в текст
      text += String.fromCharCode(byteArray[i]);
    }

    // удаляем лишние символы в конце текста
    int padding = byteArray.last;
    if (padding > 0 && padding < 4) {
      text = text.substring(0, text.length - padding);
    }

    return text;
  }
}
