import 'package:check_around_me/core/theme/app_theme.dart';
import 'package:check_around_me/features/booking/booking_screen.dart';
import 'package:flutter/material.dart';

import '../account/account_screen.dart';
import '../home/home_screen.dart';
import '../messages/messages_screen.dart';
import '../services/search_screen.dart';

class CheckNavbar extends StatefulWidget {
  final int selectedTab;

  const CheckNavbar({this.selectedTab = 0, Key? key}) : super(key: key);

  @override
  State<CheckNavbar> createState() => _CheckNavbarState();
}

class _CheckNavbarState extends State<CheckNavbar> {
  late int selectedTab;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.selectedTab;
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: [
          HomeScreen(onNavigateToSearchTab: () => _onTabSelected(1)),
          const SearchScreen(),
          const BookingsScreen(),
          const MessagesScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: FABBottomAppBar(
        currentIndex: selectedTab,
        selectedColor: AppTheme.primary,
        color: Colors.grey,
        onTabSelected: _onTabSelected,
        items: const [
          FABBottomAppBarItem(iconData: Icons.home_outlined, name: "Home"),
          FABBottomAppBarItem(iconData: Icons.search_outlined, name: "Search"),
          FABBottomAppBarItem(iconData: Icons.calendar_month_outlined, name: "Booking"),
          FABBottomAppBarItem(iconData: Icons.message_outlined, name: "Messages"),
          FABBottomAppBarItem(iconData: Icons.person_outline, name: "Account"),
        ],
      ),
    );
  }
}

class FABBottomAppBarItem {
  final IconData iconData;
  final String name;

  const FABBottomAppBarItem({
    required this.iconData,
    required this.name,
  });
}

class FABBottomAppBar extends StatelessWidget {
  final List<FABBottomAppBarItem> items;
  final int currentIndex;
  final Color color;
  final Color selectedColor;
  final Color? backgroundColor;
  final ValueChanged<int> onTabSelected;

  const FABBottomAppBar({
    required this.items,
    required this.currentIndex,
    required this.color,
    required this.selectedColor,
    required this.onTabSelected,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: AppTheme.topSheetRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(index),
                  borderRadius: AppTheme.borderRadiusMd,
                  child: SizedBox(
                    height: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.iconData,
                          color: isSelected ? selectedColor : color,
                          size: 26,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.name,
                          style: TextStyle(
                            color: isSelected ? selectedColor : color,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
