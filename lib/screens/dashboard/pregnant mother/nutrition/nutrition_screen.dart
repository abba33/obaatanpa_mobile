import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String selectedTrimester = '2nd Trimester';
  final List<String> trimesters = [
    '1st Trimester',
    '2nd Trimester',
    '3rd Trimester',
    'Postpartum',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/dashboard/pregnant-mother'),
        ),
        title: const Text(
          'Nutrition Guide',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.black),
            onPressed: () {
              // Add bookmark functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Trimester Selection
            _buildHeaderSection(),
            
            // Daily Nutrition Goals
            _buildDailyNutritionGoals(),
            
            // Recommended Foods Section
            _buildRecommendedFoods(),
            
            // Meal Planning Section
            _buildMealPlanningSection(),
            
            // Foods to Avoid Section
            _buildFoodsToAvoid(),
            
            // Nutrition Tips Section
            _buildNutritionTips(),
            
            // Supplements Section
            _buildSupplementsSection(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8BBD9).withOpacity(0.3),
            const Color(0xFFF8BBD9).withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Healthy Nutrition for You & Baby',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Personalized nutrition guidance for your pregnancy journey',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Trimester Selection
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: trimesters.length,
              itemBuilder: (context, index) {
                final trimester = trimesters[index];
                final isSelected = trimester == selectedTrimester;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTrimester = trimester;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == trimesters.length - 1 ? 0 : 8,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF8BBD9) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFF8BBD9) : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      trimester,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyNutritionGoals() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Nutrition Goals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildNutritionGoalItem('Calories', '2,200', '2,500 kcal', 0.88, const Color(0xFF81C784)),
                const SizedBox(height: 16),
                _buildNutritionGoalItem('Protein', '65g', '75g', 0.87, const Color(0xFFF8BBD9)),
                const SizedBox(height: 16),
                _buildNutritionGoalItem('Folate', '550μg', '600μg', 0.92, const Color(0xFF64B5F6)),
                const SizedBox(height: 16),
                _buildNutritionGoalItem('Iron', '22mg', '27mg', 0.81, const Color(0xFFFFB74D)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGoalItem(String nutrient, String current, String target, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nutrient,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$current / $target',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildRecommendedFoods() {
    final recommendedFoods = [
      {
        'name': 'Leafy Greens',
        'benefit': 'Rich in folate & iron',
        'icon': Icons.eco,
        'color': const Color(0xFF81C784),
        'examples': 'Spinach, Kale, Broccoli',
      },
      {
        'name': 'Lean Proteins',
        'benefit': 'Essential for baby growth',
        'icon': Icons.food_bank,
        'color': const Color(0xFFF8BBD9),
        'examples': 'Fish, Chicken, Beans, Eggs',
      },
      {
        'name': 'Whole Grains',
        'benefit': 'Energy & fiber',
        'icon': Icons.grain,
        'color': const Color(0xFFFFB74D),
        'examples': 'Brown rice, Oats, Quinoa',
      },
      {
        'name': 'Dairy Products',
        'benefit': 'Calcium for bones',
        'icon': Icons.local_drink,
        'color': const Color(0xFF64B5F6),
        'examples': 'Milk, Yogurt, Cheese',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Foods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: recommendedFoods.length,
            itemBuilder: (context, index) {
              final food = recommendedFoods[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (food['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        food['icon'] as IconData,
                        color: food['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      food['name'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food['benefit'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      food['examples'].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: food['color'] as Color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanningSection() {
    final mealPlan = [
      {
        'meal': 'Breakfast',
        'time': '7:00 AM',
        'suggestion': 'Oatmeal with berries and nuts',
        'calories': '350 cal',
        'color': const Color(0xFFFFB74D),
        'icon': Icons.wb_sunny,
      },
      {
        'meal': 'Mid-Morning',
        'time': '10:00 AM',
        'suggestion': 'Greek yogurt with fruit',
        'calories': '150 cal',
        'color': const Color(0xFF81C784),
        'icon': Icons.local_cafe,
      },
      {
        'meal': 'Lunch',
        'time': '1:00 PM',
        'suggestion': 'Grilled chicken salad',
        'calories': '450 cal',
        'color': const Color(0xFFF8BBD9),
        'icon': Icons.lunch_dining,
      },
      {
        'meal': 'Snack',
        'time': '4:00 PM',
        'suggestion': 'Hummus with vegetables',
        'calories': '200 cal',
        'color': const Color(0xFF64B5F6),
        'icon': Icons.cookie,
      },
      {
        'meal': 'Dinner',
        'time': '7:00 PM',
        'suggestion': 'Salmon with quinoa',
        'calories': '500 cal',
        'color': const Color(0xFF9575CD),
        'icon': Icons.dinner_dining,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Meal Plan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: mealPlan.map((meal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (meal['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        meal['icon'] as IconData,
                        color: meal['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                meal['meal'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                meal['time'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meal['suggestion'].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meal['calories'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: meal['color'] as Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsToAvoid() {
    final avoidFoods = [
      {
        'name': 'Raw Fish & Meat',
        'reason': 'Risk of bacterial infection',
        'icon': Icons.no_food,
        'color': Colors.red,
      },
      {
        'name': 'High Mercury Fish',
        'reason': 'Can affect baby\'s development',
        'icon': Icons.warning,
        'color': Colors.orange,
      },
      {
        'name': 'Alcohol',
        'reason': 'No safe amount during pregnancy',
        'icon': Icons.local_bar,
        'color': Colors.red,
      },
      {
        'name': 'Excess Caffeine',
        'reason': 'Limit to 200mg per day',
        'icon': Icons.coffee,
        'color': Colors.orange,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foods to Avoid',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: avoidFoods.map((food) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (food['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (food['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        food['icon'] as IconData,
                        color: food['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['name'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            food['reason'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTips() {
    final tips = [
      'Stay hydrated - drink 8-10 glasses of water daily',
      'Take prenatal vitamins as recommended by your doctor',
      'Eat small, frequent meals to manage nausea',
      'Listen to your body and eat when hungry',
      'Choose colorful fruits and vegetables for variety',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrition Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF8BBD9).withOpacity(0.1),
                  const Color(0xFFF8BBD9).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: tips.map((tip) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8BBD9),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplementsSection() {
    final supplements = [
      {
        'name': 'Prenatal Vitamin',
        'dosage': '1 tablet daily',
        'time': 'With breakfast',
        'color': const Color(0xFFF8BBD9),
        'taken': true,
      },
      {
        'name': 'Iron Supplement',
        'dosage': '30mg daily',
        'time': 'Between meals',
        'color': const Color(0xFFFFB74D),
        'taken': false,
      },
      {
        'name': 'Omega-3 (DHA)',
        'dosage': '200mg daily',
        'time': 'With dinner',
        'color': const Color(0xFF64B5F6),
        'taken': true,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Supplements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: supplements.map((supplement) {
              final taken = supplement['taken'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: taken ? (supplement['color'] as Color) : Colors.transparent,
                        border: Border.all(
                          color: supplement['color'] as Color,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: taken
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplement['name'].toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: taken ? TextDecoration.lineThrough : null,
                              color: taken ? Colors.grey : Colors.black,
                            ),
                          ),
                          Text(
                            '${supplement['dosage']} • ${supplement['time']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}