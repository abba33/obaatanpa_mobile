import 'package:flutter/material.dart';

class SupportResourcesCard extends StatelessWidget {
  const SupportResourcesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent,
                  color: Color(0xFF9B59B6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Support & Resources',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Support Options
          _buildSupportItem(
            'New Mom Support Groups',
            'Connect with other new mothers in your area',
            Icons.group,
            const Color(0xFF4CAF50),
            () {},
          ),
          const SizedBox(height: 12),
          
          _buildSupportItem(
            'Lactation Support',
            '24/7 breastfeeding help and consultation',
            Icons.baby_changing_station,
            const Color(0xFF2196F3),
            () {},
          ),
          const SizedBox(height: 12),
          
          _buildSupportItem(
            'Mental Health Resources',
            'Postpartum depression and anxiety support',
            Icons.psychology,
            const Color(0xFF9C27B0),
            () {},
          ),
          const SizedBox(height: 12),
          
          _buildSupportItem(
            'Partner Support Guide',
            'Resources to help your partner support you',
            Icons.favorite,
            const Color(0xFFFF5722),
            () {},
          ),
          
          const SizedBox(height: 16),
          
          // Emergency Contact
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Color(0xFFE91E63),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Support',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'If you\'re experiencing thoughts of self-harm',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Call Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Community Features
          const Text(
            'Community & Learning',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: _buildCommunityButton(
                  'Join Forums',
                  Icons.forum,
                  const Color(0xFF9B59B6),
                  () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCommunityButton(
                  'Watch Videos',
                  Icons.play_circle_outline,
                  const Color(0xFF4CAF50),
                  () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCommunityButton(
                  'Read Stories',
                  Icons.auto_stories,
                  const Color(0xFF2196F3),
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}