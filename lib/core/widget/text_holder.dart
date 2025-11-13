import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextHolder extends StatelessWidget {
  final String? title;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final Function? onTap;
  final double? fontHeight;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final Color? decorationColor;

  TextHolder(
      {required this.title,
      this.color,
      this.size,
      this.fontWeight,
      this.align,
      this.textStyle,
      this.fontHeight,
      this.decoration,
      this.maxLines,
      this.textOverflow,
      this.onTap,
      this.decorationColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Text(
        title!,
        maxLines: maxLines,
        overflow: textOverflow,
        textAlign: align,
        style: textStyle ??
            TextStyle(
                color: color ?? Colors.black,
                fontSize: size ?? 16,
                height: fontHeight,
                fontWeight: fontWeight ?? FontWeight.w400,
                decoration: decoration,
                decorationColor: decorationColor,
                decorationThickness: 2),
      ),
    );
  }
}

class MoneyTextHolder extends StatelessWidget {
  final String? amount;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? align;
  final Function? onTap;
  final double? fontHeight;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final String? locale;

  MoneyTextHolder({
    required this.amount,
    this.color,
    this.size,
    this.fontWeight,
    this.align,
    this.textStyle,
    this.fontHeight,
    this.decoration,
    this.maxLines,
    this.textOverflow,
    this.onTap,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    // Create number formatter without currency symbol
    final NumberFormat numberFormatter = NumberFormat.currency(
      locale: locale ?? 'en_US',
      customPattern: '#,##0.00',
    )..maximumFractionDigits = 2;

    // Parse and format the amount
    String formattedAmount = '0.00';
    if (amount != null && amount!.isNotEmpty) {
      try {
        final double parsedAmount = double.parse(amount!);
        formattedAmount = numberFormatter.format(parsedAmount);
      } catch (e) {
        // Handle invalid number format
        formattedAmount = 'Invalid Amount';
      }
    }

    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Text(
        formattedAmount,
        maxLines: maxLines,
        overflow: textOverflow,
        textAlign: align,
        style: textStyle ??
            TextStyle(
              color: color ?? Colors.white,
              fontSize: size ?? 16,
              height: fontHeight,
              fontWeight: fontWeight ?? FontWeight.w400,
              decoration: decoration,
            ),
      ),
    );
  }
}
