import 'package:flutter/material.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I track my pregnancy progress?',
      answer: 'You can track your pregnancy progress through the dashboard. The app automatically calculates your current week based on your due date and shows your progress with visual indicators.',
    ),
    FAQItem(
      question: 'How do I schedule an appointment?',
      answer: 'Go to the Appointments section from the main menu. Tap the "+" button to add a new appointment, select your healthcare provider, choose a date and time, and add any notes.',
    ),
    FAQItem(
      question: 'Can I set medication reminders?',
      answer: 'Yes! Go to the Medications section and tap "Add Medication". Set the name, dosage, and timing. The app will send you notifications when it\'s time to take your medication.',
    ),
    FAQItem(
      question: 'How do I backup my data?',
      answer: 'Your data is automatically backed up if you have enabled auto-backup in Preferences. You can also manually export your data from the Preferences > Data & Storage section.',
    ),
    FAQItem(
      question: 'What if I need emergency help?',
      answer: 'In case of emergency, use the emergency contact you\'ve set in your profile settings or call your local emergency services immediately.',
    ),
    FAQItem(
      question: 'How do I change my due date?',
      answer: 'You can update your due date by going to Profile Settings > Medical Information. Make sure to consult with your healthcare provider before making changes.',
    ),
  ];

  final _messageController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  void dispose() {
    _messageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Actions Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.support_agent,
                      color: const Color(0xFFF8BBD9),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.phone,
                        title: 'Call Support',
                        subtitle: '24/7 Available',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calling support: +233 XXX XXX XXX'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.chat,
                        title: 'Live Chat',
                        subtitle: 'Chat with us',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Live chat feature coming soon!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // FAQ Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: const Color(0xFFF8BBD9),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                ...(_faqs.map((faq) => _buildFAQItem(faq)).toList()),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Contact Us Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.contact_support,
                      color: const Color(0xFFF8BBD9),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Contact form
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _messageController,
                  style: TextStyle(color: textColor),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'How can we help you?',
                    labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.message_outlined,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _messageController.text.isNotEmpty) {
                        // Send message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Message sent successfully! We\'ll get back to you soon.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        _nameController.clear();
                        _emailController.clear();
                        _messageController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8BBD9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // App Info Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFFF8BBD9),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'App Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                _buildInfoTile(
                  title: 'App Version',
                  value: '1.0.0',
                  icon: Icons.update,
                ),
                _buildInfoTile(
                  title: 'Terms of Service',
                  value: 'View our terms',
                  icon: Icons.description,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Terms of Service...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _buildInfoTile(
                  title: 'Privacy Policy',
                  value: 'View privacy policy',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Privacy Policy...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _buildInfoTile(
                  title: 'Rate the App',
                  value: 'Leave a review',
                  icon: Icons.star_rate,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8BBD9).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF8BBD9).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFFF8BBD9),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[300] : Colors.black54;

    return ExpansionTile(
      title: Text(
        faq.question,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            faq.answer,
            style: TextStyle(
              color: subtitleColor,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: subtitleColor,
          fontSize: 12,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 16,
            )
          : null,
      onTap: onTap,
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}