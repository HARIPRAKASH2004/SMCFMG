import 'dart:convert';

class Base62 {
  static const String _alphabet = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // Encode the given integer to Base62
  static String encode(int value) {
    StringBuffer result = StringBuffer();
    while (value > 0) {
      result.write(_alphabet[value % 62]);
      value ~/= 62;
    }
    return result.toString().split('').reversed.join(); // Reverse to get correct order
  }

  // Decode the given Base62 string to integer
  static int decode(String encoded) {
    int result = 0;
    for (int i = 0; i < encoded.length; i++) {
      result = result * 62 + _alphabet.indexOf(encoded[i]);
    }
    return result;
  }
}
