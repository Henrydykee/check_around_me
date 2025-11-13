import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show NumberFormat;

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0", "en_NG");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format digits
    final formatted = _formatter.format(int.parse(digits));

    // Keep cursor at the end
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}