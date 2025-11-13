import 'package:check_around_me/core/utils/color_util.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? btnColor;
  final String? title;
  final Function()? onTap;
  final Color? textColor;
  final bool isDisabled;
  final double? textSize;
  final double? height;
  final double? width;
  final String? assetImage;
  final Color? borderColor;

  const CustomButton({
    super.key,
    this.btnColor,
    this.title,
    this.onTap,
    this.isDisabled = false,
    this.textColor,
    this.textSize,
    this.assetImage,
    this.height,
    this.width,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDisabled
        ? "7F12C8".toColor().withOpacity(0.5) // Disabled background
        : (btnColor ?? "7F12C8".toColor());   // Active background

    final Color finalTextColor = isDisabled
        ? Colors.black // Disabled text
        : (textColor ?? Colors.white); // Active text

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        onTap?.call();
      },
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderColor ?? "7F12C8".toColor()),
          // optional rounded corners
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            title ?? "",
            style: TextStyle(
              fontSize: textSize ?? 18,
              color: finalTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}