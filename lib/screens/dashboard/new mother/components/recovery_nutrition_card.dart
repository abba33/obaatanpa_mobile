import 'package:flutter/material.dart';

class RecoveryNutritionCard extends StatelessWidget {
  const RecoveryNutritionCard({Key? key}) : super(key: key);

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
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFFFF9800),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Nutrition for Recovery',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to nutrition plan
                },
                child: const Text(
                  'View Plan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF9800),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Daily Goals Progress
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'Today\'s Goals',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildNutritionGoal('Water Intake', '6/8 glasses', 0.75, const Color(0xFF2196F3)),
                const SizedBox(height: 8),
                _buildNutritionGoal('Protein', '45/60g', 0.75, const Color(0xFF4CAF50)),
                const SizedBox(height: 8),
                _buildNutritionGoal('Calcium', '800/1200mg', 0.67, const Color(0xFFFF9800)),
                const SizedBox(height: 8),
                _buildNutritionGoal('Iron', '15/18mg', 0.83, const Color(0xFFE91E63)),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Key Nutrients for Breastfeeding
          const Text(
            'Key Nutrients for Recovery & Breastfeeding',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildNutrientTip('🥛', 'Calcium', 'Supports bone health and milk production'),
          _buildNutrientTip('🥩', 'Iron', 'Prevents fatigue and supports energy levels'),
          _buildNutrientTip('🥑', 'Healthy Fats', 'Essential for baby\'s brain development'),
          _buildNutrientTip('💊', 'Folate', 'Supports continued healing and recovery'),
          
          const SizedBox(height: 16),
          
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to meal planner
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Meal Planner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to recipes
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF9800)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Healthy Recipes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGoal(String nutrient, String progress, double value, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            nutrient,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          progress,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientTip(String emoji, String nutrient, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nutrient,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}