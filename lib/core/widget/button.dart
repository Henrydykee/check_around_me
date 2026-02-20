import 'package:check_around_me/core/theme/app_theme.dart';
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
        ? AppTheme.primary.withOpacity(0.5)
        : (btnColor ?? AppTheme.primary);

    final Color finalTextColor = isDisabled
        ? Colors.black
        : (textColor ?? Colors.white);

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
          borderRadius: AppTheme.borderRadiusPill,
          border: Border.all(color: borderColor ?? AppTheme.primary),
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