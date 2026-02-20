import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/core/widget/text_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final String? hinttitle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? prefixText;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? suffix;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? currentFocusNode; // Kept for compatibility, but consider removing if unused
  final FocusNode? nextFocusNode;
  final Color? cursorColor;
  final bool readOnly;
  final double? fontSize;
  final TextAlign? align;
  final bool obscureText;
  final bool showTittle;
  final bool autofocus;
  final void Function()? onTap;
  final void Function(String)? onchanged;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final EdgeInsets? padding;
  final String? Function(String?)? validator;
  final double borderRadius;
  final String? fontFamily;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    this.onTap,
    this.title,
    this.onchanged,
    this.onFieldSubmitted,
    this.maxLines,
    this.maxLength,
    this.obscureText = false,
    this.autofocus = false,
    this.hinttitle,
    this.controller,
    this.focusNode,
    this.padding,
    this.keyboardType,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.prefixText,
    this.align,
    this.suffixIcon,
    this.inputFormatters,
    this.currentFocusNode,
    this.nextFocusNode,
    this.cursorColor,
    this.showTittle = false,
    this.readOnly = false,
    this.fontSize,
    this.textInputAction,
    this.borderRadius = 100.0,
    this.validator,
    this.fontFamily,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTittle && title != null && title!.isNotEmpty) TextHolder(title: title!, color: Colors.black, size: 14, fontWeight: FontWeight.w500),
        if (showTittle && title != null && title!.isNotEmpty) const Gap(12),
        TextFormField(
          onTap: onTap,
          obscureText: obscureText,
          readOnly: readOnly,
          autofocus: autofocus,
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          onChanged: onchanged,
          obscuringCharacter: '*',
          textCapitalization: TextCapitalization.sentences,
          validator: validator,
          textAlign: align ?? TextAlign.left,
          keyboardType: keyboardType ?? TextInputType.text,
          cursorColor: cursorColor ?? AppTheme.primary,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction ?? TextInputAction.done,
          style: TextStyle(color: AppTheme.primary, fontSize: fontSize ?? 14, fontFamily: fontFamily ?? Theme.of(context).textTheme.bodyMedium?.fontFamily),
          onEditingComplete: () {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          onFieldSubmitted: (value) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!(value);
            }
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          decoration: InputDecoration(
            contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            hintText: hinttitle,
            hintStyle: TextStyle(
              color: AppTheme.primary.withOpacity(0.7),
              fontSize: fontSize ?? 14,
              fontFamily: fontFamily ?? Theme.of(context).textTheme.bodyMedium?.fontFamily,
            ),
            fillColor: AppTheme.primaryLight,
            filled: true,
            suffix: suffix,
            suffixIcon: suffixIcon,

            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: prefix,
                  )
                : prefixIcon,

            prefixText: prefixText,
            prefixStyle: TextStyle(color: AppTheme.primary),
            labelStyle: const TextStyle(fontSize: 16),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.15)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: borderColor ?? AppTheme.primary.withOpacity(0.4)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: borderColor ?? AppTheme.primary),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: borderColor ?? AppTheme.primary),
            ),
          ),

        ),
      ],
    );
  }
}
