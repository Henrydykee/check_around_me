import 'dart:ui';

extension StringColorExtension on String {
  Color toColor() {
    String hex = replaceAll("#", "").toUpperCase();

    if (hex.length == 6) {
      hex = "FF$hex";
    } else if (hex.length != 8) {
      throw FormatException("Invalid hex color: $this");
    }

    return Color(int.parse(hex, radix: 16));
  }
}