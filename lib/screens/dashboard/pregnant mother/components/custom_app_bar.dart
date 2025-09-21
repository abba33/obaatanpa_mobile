import 'package:flutter/material.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:obaatanpa_mobile/providers/auth_provider.dart';
import 'package:obaatanpa_mobile/screens/dashboard/help_support_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/preferences_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/profile_settings_page.dart';
import 'package:obaatanpa_mobile/screens/dashboard/notification_page.dart';
import 'package:provider/provider.dart';

// Custom App Bar Component with Dark Mode Support and Profile Dropdown
class CustomAppBar extends StatelessWidget {
  final bool isMenuOpen;
  final VoidCallback onMenuTap;

  const CustomAppBar({
    Key? key,
    required this.isMenuOpen,
    required this.onMenuTap,
    required String title,
  }) : super(key: key);

  void _showProfileMenu(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 120, 0, 0),
      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: isDark ? Colors.white : Colors.black87,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Profile Settings',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'preferences',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: isDark ? Colors.white : Colors.black87,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Preferences',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'help',
          child: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: isDark ? Colors.white : Colors.black87,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Help & Support',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuSelection(context, value);
      }
    });
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileSettingsPage(),
          ),
        );
        break;
      case 'preferences':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PreferencesPage(),
          ),
        );
        break;
      case 'help':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HelpSupportPage(),
          ),
        );
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    duration: Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          // Top row - Logo and title centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.5),
                  child: Image.asset(
                    'assets/images/navbar/maternity-logo.png',
                    fit: BoxFit.cover,
                    width: 45,
                    height: 45,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8BBD9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'OBAA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        TextSpan(
                          text: 'TANPA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF59297),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Your Pregnancy Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom row - Controls and user info
          Row(
            children: [
              // Left side - Menu and dark mode toggle
              Row(
                children: [
                  GestureDetector(
                    onTap: onMenuTap,
                    child: Icon(
                      isMenuOpen ? Icons.close : Icons.menu,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      final themeProvider = context.read<ThemeProvider>();
                      themeProvider.toggleTheme();
                    },
                    child: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                      color: isDark ? const Color(0xFFF8BBD9) : textColor,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Center - Greeting
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final userName = (authProvider.userName?.isNotEmpty == true)
                      ? authProvider.userName!
                      : 'User';
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hello, ',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: userName,
                          style: TextStyle(
                            color: const Color(0xFFF59297),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(),

              // Right side - Notification and profile
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _navigateToNotifications(context),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: textColor,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Profile section with dropdown
                  GestureDetector(
                    onTap: () => _showProfileMenu(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              isDark ? Colors.grey[700] : Colors.grey[300],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              'assets/images/navbar/profile-1.png',
                              fit: BoxFit.cover,
                              width: 36,
                              height: 36,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color:
                                      isDark ? Colors.white : Colors.grey[600],
                                  size: 20,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: textColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
