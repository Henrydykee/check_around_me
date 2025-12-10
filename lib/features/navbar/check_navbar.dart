import 'package:check_around_me/features/booking/booking_screen.dart';
import 'package:flutter/material.dart';

import '../account/account_screen.dart';
import '../home/home_screen.dart';
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
        children:  [
          HomeScreen(),
          SearchScreen(),
          BookingsScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: FABBottomAppBar(
        currentIndex: selectedTab,
        notchedShape: const CircularNotchedRectangle(),
        selectedColor: Colors.black,
        color: Colors.grey,
        onTabSelected: _onTabSelected,
        items: const [
          FABBottomAppBarItem(iconData: Icons.home_outlined, name: "Home"),
          FABBottomAppBarItem(iconData: Icons.search_outlined, name: "Search"),
          FABBottomAppBarItem(iconData: Icons.calendar_month_outlined, name: "Booking"),
          FABBottomAppBarItem(iconData: Icons.person_outline, name: "Account"),
        ],
        centerItemText: '',
        backgroundColor: Colors.white,
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
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final String centerItemText;

  const FABBottomAppBar({
    required this.items,
    required this.currentIndex,
    required this.color,
    required this.selectedColor,
    required this.onTabSelected,
    required this.notchedShape,
    required this.centerItemText,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: notchedShape,
      color: backgroundColor ?? Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              child: SizedBox(
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.iconData,
                      color: isSelected ? selectedColor : color,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      style: TextStyle(
                        color: isSelected ? selectedColor : color,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
