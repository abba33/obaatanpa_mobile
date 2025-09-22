import 'package:flutter/material.dart';

class RecoveryNutritionPage extends StatelessWidget {
  const RecoveryNutritionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery Nutrition'),
        backgroundColor: const Color(0xFF9B59B6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Postpartum Nutrition Guide'),
            _buildNutritionCard(
              title: 'Essential Nutrients',
              content: 'Focus on iron-rich foods, protein, calcium, and vitamins to support recovery and breastfeeding.',
              icon: Icons.restaurant_menu,
            ),
            _buildNutritionCard(
              title: 'Hydration',
              content: 'Stay hydrated by drinking plenty of water, especially if breastfeeding.',
              icon: Icons.water_drop,
            ),
            _buildNutritionCard(
              title: 'Meal Planning',
              content: 'Plan nutrient-rich, easy-to-prepare meals that support healing and energy levels.',
              icon: Icons.calendar_today,
            ),
            _buildSectionTitle('Recommended Foods'),
            _buildFoodList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9B59B6),
        ),
      ),
    );
  }

  Widget _buildNutritionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF9B59B6), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    final recommendedFoods = [
      {'category': 'Proteins', 'foods': 'Lean meats, fish, eggs, legumes'},
      {'category': 'Iron-Rich Foods', 'foods': 'Dark leafy greens, red meat, fortified cereals'},
      {'category': 'Calcium Sources', 'foods': 'Dairy products, fortified plant milk, leafy greens'},
      {'category': 'Healthy Fats', 'foods': 'Avocados, nuts, olive oil, fatty fish'},
    ];

    return Column(
      children: recommendedFoods.map((food) => ListTile(
        leading: const Icon(Icons.check_circle, color: Color(0xFF9B59B6)),
        title: Text(food['category']!,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(food['foods']!),
      )).toList(),
    );
  }
}
