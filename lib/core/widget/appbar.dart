



import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// Whether to show the page counter (e.g. “1/5”)
  final bool showPageCounter;

  final bool showBackButton;

  /// Current page number (1-based)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// The main title text
  final String? title;

  /// Callback when the back button is tapped
  final VoidCallback? onBack;

  final Color? color;

  const CustomAppbar({
    Key? key,
    this.showPageCounter = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.title,
    this.color,
    this.showBackButton = true,
    this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color ?? Colors.white,
      elevation: 0,
      leading:showBackButton ? GestureDetector(
        onTap: onBack ?? () => Navigator.of(context).pop(),
        child: Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 30,
        ),
      ) : const SizedBox.shrink(),
      title: title != null
          ? Text(
        title!,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      )
          : const SizedBox.shrink(),
      centerTitle: true,
      actions: [
      ],
    );
  }
}