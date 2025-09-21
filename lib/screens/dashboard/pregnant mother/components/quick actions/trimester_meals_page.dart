import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/providers/pregnancy_data_provider.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';

class TrimesterMealsPage extends StatefulWidget {
  const TrimesterMealsPage({Key? key}) : super(key: key);

  @override
  State<TrimesterMealsPage> createState() => _TrimesterMealsPageState();
}

class _TrimesterMealsPageState extends State<TrimesterMealsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PregnancyDataProvider, ThemeProvider>(
      builder: (context, pregnancyProvider, themeProvider, child) {
        final trimester = pregnancyProvider.trimester;
        final currentWeek = pregnancyProvider.currentWeek;
        final trimesterData = _getTrimesterMealData(trimester);
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.go('/dashboard/pregnant-mother'),
              icon: Icon(Icons.arrow_back_ios,
                  color: isDark ? Colors.white : Colors.black87, size: 20),
            ),
            title: Text(
              '$trimester Trimester Meals',
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_border,
                    color: isDark ? Colors.white : Colors.black87, size: 22),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildTrimesterHeader(trimester, currentWeek, trimesterData),
              _buildMealTypeTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMealsList(
                        'breakfast', trimesterData['meals']['breakfast']),
                    _buildMealsList('lunch', trimesterData['meals']['lunch']),
                    _buildMealsList('dinner', trimesterData['meals']['dinner']),
                    _buildMealsList('snacks', trimesterData['meals']['snacks']),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrimesterHeader(
      String trimester, int currentWeek, Map<String, dynamic> trimesterData) {
    Color trimesterColor = _getTrimesterColor(trimester);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: trimesterColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trimesterColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: trimesterColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Week $currentWeek',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.restaurant_menu,
                color: trimesterColor,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$trimester Trimester Nutrition',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            trimesterData['description'],
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildNutritionHighlights(trimesterData['highlights']),
        ],
      ),
    );
  }

  Widget _buildNutritionHighlights(List<String> highlights) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: highlights
          .map((highlight) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59297).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFF59297).withOpacity(0.3)),
                ),
                child: Text(
                  highlight,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFFF59297),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMealTypeTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF59297),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Breakfast'),
          Tab(text: 'Lunch'),
          Tab(text: 'Dinner'),
          Tab(text: 'Snacks'),
        ],
      ),
    );
  }

  Widget _buildMealsList(String mealType, List<Map<String, dynamic>> meals) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return _buildMealCard(meal, mealType);
      },
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, String mealType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: _getMealTypeColor(mealType).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                _getMealTypeIcon(mealType),
                size: 48,
                color: _getMealTypeColor(mealType),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        meal['name'],
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${meal['calories']} cal',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  meal['description'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Key Benefits:',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                ...meal['benefits']
                    .map<Widget>((benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6, right: 8),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59297),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showIngredientsDialog(context, meal),
                        icon: const Icon(Icons.list_alt, size: 16),
                        label: Text(
                          'Ingredients',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showRecipeDialog(context, meal),
                        icon: const Icon(Icons.restaurant, size: 16),
                        label: Text(
                          'Recipe',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59297),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrimesterColor(String trimester) {
    switch (trimester.toLowerCase()) {
      case 'first':
        return const Color(0xFF4CAF50);
      case 'second':
        return const Color(0xFFF59297);
      case 'third':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFF59297);
    }
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFFF9800);
      case 'lunch':
        return const Color(0xFF4CAF50);
      case 'dinner':
        return const Color(0xFF2196F3);
      case 'snacks':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFFF59297);
    }
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snacks':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  void _showIngredientsDialog(BuildContext context, Map<String, dynamic> meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            '${meal['name']} - Ingredients',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: meal['ingredients']
                .map<Widget>((ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFFF59297))),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.inter(color: const Color(0xFFF59297)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRecipeDialog(BuildContext context, Map<String, dynamic> meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            '${meal['name']} - Recipe',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions:',
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...meal['recipe']
                    .asMap()
                    .entries
                    .map<Widget>((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2, right: 8),
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF59297),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: GoogleFonts.inter(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.inter(color: const Color(0xFFF59297)),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> _getTrimesterMealData(String trimester) {
    switch (trimester.toLowerCase()) {
      case 'first':
        return _getFirstTrimesterMeals();
      case 'second':
        return _getSecondTrimesterMeals();
      case 'third':
        return _getThirdTrimesterMeals();
      default:
        return _getFirstTrimesterMeals();
    }
  }

  Map<String, dynamic> _getFirstTrimesterMeals() {
    return {
      'description':
          'Focus on nausea management, folic acid, and foundational nutrition for early development.',
      'highlights': [
        'Folic Acid',
        'B6 for Nausea',
        'Small Frequent Meals',
        'Hydration'
      ],
      'meals': {
        'breakfast': [
          {
            'name': 'Ginger Oat Smoothie',
            'description':
                'Gentle on the stomach with anti-nausea properties and essential nutrients.',
            'calories': 280,
            'benefits': [
              'Ginger helps reduce morning sickness',
              'Oats provide sustained energy and fiber',
              'Banana adds potassium and natural sweetness'
            ],
            'ingredients': [
              '1/2 cup rolled oats',
              '1 banana',
              '1 cup almond milk',
              '1 tsp fresh ginger',
              '1 tbsp honey',
              '1/4 cup spinach (optional)'
            ],
            'recipe': [
              'Blend oats, banana, almond milk, and ginger until smooth',
              'Add honey and spinach if desired',
              'Blend again until well combined',
              'Serve immediately for best taste'
            ]
          },
          {
            'name': 'Whole Grain Toast with Avocado',
            'description':
                'Simple, nutritious breakfast rich in healthy fats and fiber.',
            'calories': 320,
            'benefits': [
              'Healthy fats support brain development',
              'Fiber aids digestion',
              'Easy to digest when nauseous'
            ],
            'ingredients': [
              '2 slices whole grain bread',
              '1 ripe avocado',
              '1 small tomato',
              'Salt and pepper to taste',
              'Lemon juice',
              'Optional: 1 boiled egg'
            ],
            'recipe': [
              'Toast bread to desired crispness',
              'Mash avocado with lemon juice, salt, and pepper',
              'Spread avocado mixture on toast',
              'Top with sliced tomato and optional egg'
            ]
          }
        ],
        'lunch': [
          {
            'name': 'Quinoa Vegetable Bowl',
            'description':
                'Protein-rich quinoa with colorful vegetables for complete nutrition.',
            'calories': 380,
            'benefits': [
              'Complete protein source',
              'Rich in folate and iron',
              'Colorful vegetables provide antioxidants'
            ],
            'ingredients': [
              '1 cup cooked quinoa',
              '1/2 cup chickpeas',
              '1/2 cup roasted sweet potato',
              '1/4 cup shredded carrots',
              '2 tbsp tahini dressing',
              'Mixed greens'
            ],
            'recipe': [
              'Cook quinoa according to package instructions',
              'Roast sweet potato at 400°F for 25 minutes',
              'Combine all ingredients in a bowl',
              'Drizzle with tahini dressing and serve'
            ]
          }
        ],
        'dinner': [
          {
            'name': 'Gentle Chicken and Rice Soup',
            'description':
                'Comforting, easy-to-digest meal perfect for sensitive stomachs.',
            'calories': 340,
            'benefits': [
              'Easy on sensitive stomach',
              'Provides protein and B vitamins',
              'Warm liquids help with hydration'
            ],
            'ingredients': [
              '4 oz chicken breast',
              '1/2 cup brown rice',
              '2 cups low-sodium chicken broth',
              '1 carrot, diced',
              '1 celery stalk, diced',
              'Fresh herbs'
            ],
            'recipe': [
              'Cook rice separately according to package instructions',
              'Simmer chicken in broth until cooked through',
              'Add vegetables and cook until tender',
              'Shred chicken and combine with rice and broth'
            ]
          }
        ],
        'snacks': [
          {
            'name': 'Crackers with Almond Butter',
            'description':
                'Simple, satisfying snack that helps stabilize blood sugar.',
            'calories': 180,
            'benefits': [
              'Protein helps maintain energy levels',
              'Easy to keep down when nauseous',
              'Provides healthy fats'
            ],
            'ingredients': [
              '6 whole grain crackers',
              '2 tbsp natural almond butter',
              'Optional: sliced apple or banana'
            ],
            'recipe': [
              'Spread almond butter on crackers',
              'Top with fruit slices if desired',
              'Enjoy as needed throughout the day'
            ]
          }
        ]
      }
    };
  }

  Map<String, dynamic> _getSecondTrimesterMeals() {
    return {
      'description':
          'Increased appetite phase - focus on calcium, iron, and healthy weight gain.',
      'highlights': [
        'Calcium',
        'Iron',
        'Omega-3',
        'Protein',
        'Healthy Weight Gain'
      ],
      'meals': {
        'breakfast': [
          {
            'name': 'Greek Yogurt Parfait',
            'description':
                'Calcium-rich breakfast with probiotics and antioxidants.',
            'calories': 350,
            'benefits': [
              'High in calcium for bone development',
              'Probiotics support digestive health',
              'Antioxidants from berries'
            ],
            'ingredients': [
              '1 cup Greek yogurt',
              '1/2 cup mixed berries',
              '1/4 cup granola',
              '2 tbsp chopped walnuts',
              '1 tbsp honey',
              '1 tbsp chia seeds'
            ],
            'recipe': [
              'Layer yogurt in a bowl or glass',
              'Add berries and granola',
              'Top with walnuts and chia seeds',
              'Drizzle with honey and serve'
            ]
          }
        ],
        'lunch': [
          {
            'name': 'Salmon and Spinach Salad',
            'description':
                'Omega-3 rich salmon with iron-packed spinach and colorful vegetables.',
            'calories': 420,
            'benefits': [
              'Omega-3 supports brain development',
              'Iron prevents anemia',
              'Folate from leafy greens'
            ],
            'ingredients': [
              '4 oz grilled salmon',
              '3 cups baby spinach',
              '1/2 cup cherry tomatoes',
              '1/4 avocado, sliced',
              '2 tbsp olive oil vinaigrette',
              '1 tbsp pumpkin seeds'
            ],
            'recipe': [
              'Season and grill salmon until flaky',
              'Combine spinach, tomatoes, and avocado',
              'Top with flaked salmon',
              'Drizzle with vinaigrette and sprinkle seeds'
            ]
          }
        ],
        'dinner': [
          {
            'name': 'Lean Beef Stir-fry',
            'description':
                'Iron-rich beef with colorful vegetables for comprehensive nutrition.',
            'calories': 440,
            'benefits': [
              'High in heme iron for better absorption',
              'Colorful vegetables provide vitamins',
              'Balanced protein and carbohydrates'
            ],
            'ingredients': [
              '4 oz lean beef strips',
              '1 cup mixed vegetables (bell peppers, broccoli)',
              '1/2 cup brown rice',
              '2 tbsp low-sodium soy sauce',
              '1 tbsp sesame oil',
              '1 clove garlic, minced'
            ],
            'recipe': [
              'Cook brown rice according to instructions',
              'Heat sesame oil in wok or large pan',
              'Stir-fry beef until browned',
              'Add vegetables and garlic, cook until tender',
              'Serve over rice with soy sauce'
            ]
          }
        ],
        'snacks': [
          {
            'name': 'Trail Mix Energy Bites',
            'description':
                'Nutrient-dense snack with healthy fats, protein, and natural sweetness.',
            'calories': 160,
            'benefits': [
              'Sustained energy from healthy fats',
              'Protein supports growth',
              'Natural sweetness from dates'
            ],
            'ingredients': [
              '1/2 cup mixed nuts',
              '1/4 cup pitted dates',
              '2 tbsp ground flaxseed',
              '1 tbsp chia seeds',
              '1 tsp vanilla extract'
            ],
            'recipe': [
              'Pulse nuts and dates in food processor',
              'Add flaxseed, chia seeds, and vanilla',
              'Roll into small balls',
              'Refrigerate for 30 minutes before eating'
            ]
          }
        ]
      }
    };
  }

  Map<String, dynamic> _getThirdTrimesterMeals() {
    return {
      'description':
          'Prepare for labor with nutrient-dense foods that support energy and recovery.',
      'highlights': [
        'Iron',
        'Vitamin K',
        'Complex Carbs',
        'Protein',
        'Labor Prep'
      ],
      'meals': {
        'breakfast': [
          {
            'name': 'Steel Cut Oats with Berries',
            'description':
                'Sustained energy breakfast with fiber and antioxidants for labor preparation.',
            'calories': 380,
            'benefits': [
              'Complex carbs provide sustained energy',
              'High fiber aids digestion',
              'Antioxidants support immune system'
            ],
            'ingredients': [
              '1/2 cup steel cut oats',
              '1 cup milk of choice',
              '1/2 cup mixed berries',
              '2 tbsp chopped almonds',
              '1 tbsp maple syrup',
              '1 tsp cinnamon'
            ],
            'recipe': [
              'Cook steel cut oats according to package directions',
              'Stir in milk for creaminess',
              'Top with berries and almonds',
              'Drizzle with maple syrup and sprinkle cinnamon'
            ]
          }
        ],
        'lunch': [
          {
            'name': 'Lentil and Sweet Potato Curry',
            'description':
                'Iron-rich lentils with complex carbohydrates for sustained energy.',
            'calories': 400,
            'benefits': [
              'High in iron to prevent anemia',
              'Plant-based protein and fiber',
              'Complex carbs support energy needs'
            ],
            'ingredients': [
              '1 cup red lentils',
              '1 medium sweet potato, diced',
              '1 can coconut milk',
              '1 tsp curry powder',
              '1 cup spinach',
              '1 tbsp olive oil'
            ],
            'recipe': [
              'Heat oil in large pot',
              'Sauté sweet potato until slightly soft',
              'Add lentils, coconut milk, and curry powder',
              'Simmer 15-20 minutes until lentils are tender',
              'Stir in spinach until wilted'
            ]
          }
        ],
        'dinner': [
          {
            'name': 'Herb-Crusted Chicken with Quinoa',
            'description':
                'Complete protein with complex carbs to fuel late pregnancy needs.',
            'calories': 460,
            'benefits': [
              'Complete protein for muscle and tissue repair',
              'B vitamins support energy metabolism',
              'Quinoa provides all essential amino acids'
            ],
            'ingredients': [
              '5 oz chicken breast',
              '1/2 cup quinoa',
              '2 tbsp fresh herbs (rosemary, thyme)',
              '1 cup roasted vegetables',
              '1 tbsp olive oil',
              'Lemon juice'
            ],
            'recipe': [
              'Season chicken with herbs, salt, and pepper',
              'Bake at 375°F for 25-30 minutes',
              'Cook quinoa according to package instructions',
              'Roast vegetables with olive oil',
              'Serve chicken over quinoa with vegetables'
            ]
          }
        ],
        'snacks': [
          {
            'name': 'Date and Nut Energy Bars',
            'description':
                'Natural energy boost with dates that may help prepare for labor.',
            'calories': 200,
            'benefits': [
              'Dates may help with labor preparation',
              'Natural sugars provide quick energy',
              'Nuts provide healthy fats and protein'
            ],
            'ingredients': [
              '1 cup pitted dates',
              '1/2 cup mixed nuts',
              '2 tbsp almond butter',
              '1 tbsp coconut oil',
              '1 tsp vanilla',
              'Pinch of sea salt'
            ],
            'recipe': [
              'Process dates in food processor until paste forms',
              'Add nuts and pulse until roughly chopped',
              'Mix in almond butter, coconut oil, vanilla, and salt',
              'Press mixture into lined pan and refrigerate 2 hours',
              'Cut into bars and store in refrigerator'
            ]
          }
        ]
      }
    };
  }
}
