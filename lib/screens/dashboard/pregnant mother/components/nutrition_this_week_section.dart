import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/pregnancy_data_provider.dart';


class PersonalizedNutritionSection extends StatelessWidget {
  final List<String> nutritionTips;
  final int currentWeek;

  const PersonalizedNutritionSection({
    Key? key,
    required this.nutritionTips,
    required this.currentWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF90EE90),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant,
                color: Colors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Nutrition - Week $currentWeek',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Personalised for your current stage',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        
        // Nutrition tips based on current week
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getWeekSpecificNutritionAdvice(currentWeek),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ...nutritionTips.take(3).map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF90EE90),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF6B9BFF)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'View Week-Specific Meal Plan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getWeekSpecificNutritionAdvice(int week) {
    if (week <= 12) {
      return 'Focus on folic acid and managing morning sickness. Small, frequent meals work best.';
    } else if (week <= 27) {
      return 'Increase protein and iron intake. Your baby is growing rapidly now.';
    } else {
      return 'Focus on calcium and protein for final growth. Stay well hydrated for delivery prep.';
    }
  }
}

// Personalized Articles Section Component
class PersonalizedArticlesSection extends StatelessWidget {
  final String trimester;
  final int currentWeek;

  const PersonalizedArticlesSection({
    Key? key,
    required this.trimester,
    required this.currentWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articles = _getPersonalizedArticles(trimester, currentWeek);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${trimester} Trimester Articles',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Week $currentWeek specific content for your journey',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildArticleCard(articles[0], _getArticleColor(0)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildArticleCard(articles[1], _getArticleColor(1)),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _getPersonalizedArticles(String trimester, int week) {
    if (trimester == 'First') {
      return [
        'First Trimester Symptoms Guide',
        'Essential Prenatal Vitamins'
      ];
    } else if (trimester == 'Second') {
      return [
        'Feeling Baby\'s First Kicks',
        'Anatomy Scan: What to Expect'
      ];
    } else {
      return [
        'Hospital Bag Checklist',
        'Signs of Labor & When to Go'
      ];
    }
  }

  Color _getArticleColor(int index) {
    final colors = [
      const Color(0xFF6B9BFF),
      const Color(0xFFF8BBD9),
      const Color(0xFF90EE90),
      const Color(0xFFFFB6C1),
    ];
    return colors[index % colors.length];
  }

  Widget _buildArticleCard(String title, Color color) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
