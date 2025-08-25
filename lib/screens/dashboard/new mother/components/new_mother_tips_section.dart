import 'package:flutter/material.dart';

class NewMotherTipsSection extends StatelessWidget {
  const NewMotherTipsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tips & Articles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to all articles
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9B59B6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Featured Article Card
        _buildFeaturedArticle(),
        
        const SizedBox(height: 16),
        
        // Article List
        _buildArticleItem(
          'Establishing a Sleep Routine',
          'Tips for better sleep for you and your baby',
          '5 min read',
          const Color(0xFF9C27B0),
          Icons.bedtime,
        ),
        const SizedBox(height: 12),
        _buildArticleItem(
          'Breastfeeding Positions',
          'Find the most comfortable position for feeding',
          '7 min read',
          const Color(0xFF4CAF50),
          Icons.baby_changing_station,
        ),
        const SizedBox(height: 12),
        _buildArticleItem(
          'Postpartum Recovery Guide',
          'What to expect in your first few months',
          '10 min read',
          const Color(0xFF2196F3),
          Icons.healing,
        ),
      ],
    );
  }

  Widget _buildFeaturedArticle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B9D), Color(0xFFFF8E9B)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'FEATURED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Self-Care for New Mothers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Taking care of yourself is just as important as caring for your baby. Learn simple ways to prioritize your wellbeing.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              const Text(
                '8 min read',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Read Now',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6B9D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleItem(
    String title,
    String description,
    String readTime,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  readTime,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
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
    );
  }
}