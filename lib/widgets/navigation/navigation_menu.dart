import 'package:flutter/material.dart';

// Navigation Menu Item Component
class NavigationMenuItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const NavigationMenuItem({
    super.key,
    required this.title,
    this.isActive = false,
    required this.onTap, required Color textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: isActive ? Color(0xFFF8BBD9) : Colors.black,
        ),
      ),
    );
  }
}










