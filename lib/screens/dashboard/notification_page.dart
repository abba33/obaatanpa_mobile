import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = 'All';
  
  final List<NotificationItem> todayNotifications = [
    NotificationItem(
      icon: Icons.medication,
      iconColor: Colors.red,
      title: 'Medication Reminder',
      subtitle: 'Daily medicine reminder sent.',
      time: '17m',
      isRead: false,
    ),
    NotificationItem(
      icon: Icons.calendar_today,
      iconColor: Colors.blue,
      title: 'Appointment Success',
      subtitle: 'Appointment booked successfully.',
      time: '24m',
      isRead: true,
    ),
    NotificationItem(
      icon: Icons.calendar_month,
      iconColor: Colors.red,
      title: 'Schedule Changed',
      subtitle: 'Schedule updated successfully.',
      time: '42m',
      isRead: true,
    ),
    NotificationItem(
      icon: Icons.video_call,
      iconColor: Colors.black,
      title: 'Video Call Appointment',
      subtitle: 'Virtual session set with provider.',
      time: '54m',
      isRead: true,
    ),
  ];

  final List<NotificationItem> yesterdayNotifications = [
    NotificationItem(
      icon: Icons.account_circle,
      iconColor: Colors.green,
      title: 'Account Connected',
      subtitle: 'Your account is connected.',
      time: '1d',
      isRead: true,
    ),
    NotificationItem(
      icon: Icons.calendar_today,
      iconColor: Colors.blue,
      title: 'Appointment Canceled',
      subtitle: 'Your booking has been canceled.',
      time: '1d',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Title
                  Text(
                    'Notification',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // More options button
                  Icon(
                    Icons.more_horiz,
                    color: textColor,
                    size: 24,
                  ),
                ],
              ),
            ),
            
            // Filter Section
            Container(
              color: cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // All dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedFilter,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: textColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Filter button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.tune,
                          color: textColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Notifications List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // Today Section
                  _buildSectionHeader('Today', context),
                  const SizedBox(height: 8),
                  
                  // Today notifications
                  ...todayNotifications.map((notification) => 
                    _buildNotificationItem(notification, context),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Yesterday Section
                  _buildSectionHeader('Yesterday', context),
                  const SizedBox(height: 8),
                  
                  // Yesterday notifications
                  ...yesterdayNotifications.map((notification) => 
                    _buildNotificationItem(notification, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          'Mark all as read',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(NotificationItem notification, BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Red dot for unread notifications
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: notification.isRead ? Colors.transparent : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: notification.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              notification.icon,
              color: notification.iconColor,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Time
          Text(
            notification.time,
            style: TextStyle(
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
  });
}