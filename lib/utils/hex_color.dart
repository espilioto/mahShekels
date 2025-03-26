import 'package:flutter/material.dart';

abstract class HexColor {
  /// Creates a Color from a hex code string, with optional leading #.
  ///
  /// Usage: `HexColor.fromHex('#FFFFFF')` or `HexColor.fromHex('FFFFFF')`
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
