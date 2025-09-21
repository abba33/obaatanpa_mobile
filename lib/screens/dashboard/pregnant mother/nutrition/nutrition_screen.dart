import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  bool _isMenuOpen = false;
  String selectedTrimester = '2nd Trimester';
  final List<String> trimesters = [
    '1st Trimester',
    '2nd Trimester',
    '3rd Trimester',
    'Postpartum',
  ];

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();
    if (routeName != '/nutrition') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Column(
            children: [
              // Custom App Bar
              CustomAppBar(
                isMenuOpen: _isMenuOpen,
                onMenuTap: _toggleMenu,
                title: 'Nutrition',
              ),

              // Nutrition Content
              Expanded(
                child: SingleChildScrollView(
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
              ),
            ],
          ),

          // Side Navigation Menu
          if (_isMenuOpen) _buildNavigationMenu(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF7DA8E6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Color(0xFF7DA8E6),
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Healthy Nutrition for You & Baby',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C2C2C),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Personalized guidance for your pregnancy journey',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Trimester Selection
          SizedBox(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFF59297) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFF59297)
                            : const Color(0xFFE5E7EB),
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: const Color(0xFFF59297).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Text(
                      trimester,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Nutrition Goals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2C2C),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildNutritionGoalItem('Calories', '2,200', '2,500 kcal', 0.88,
                    const Color(0xFF10B981)),
                const SizedBox(height: 20),
                _buildNutritionGoalItem(
                    'Protein', '65g', '75g', 0.87, const Color(0xFFF59297)),
                const SizedBox(height: 20),
                _buildNutritionGoalItem(
                    'Folate', '550μg', '600μg', 0.92, const Color(0xFF7DA8E6)),
                const SizedBox(height: 20),
                _buildNutritionGoalItem(
                    'Iron', '22mg', '27mg', 0.81, const Color(0xFFF59E0B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGoalItem(String nutrient, String current, String target,
      double progress, Color color) {
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
                color: Color(0xFF2C2C2C),
              ),
            ),
            Text(
              '$current / $target',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildRecommendedFoods() {
    final recommendedFoods = [
      {
        'name': 'Leafy Greens',
        'benefit': 'Rich in folate & iron',
        'image': 'assets/images/foods/leafy_greens.png',
        'color': const Color(0xFF10B981),
        'examples': 'Spinach, Kale, Broccoli',
      },
      {
        'name': 'Lean Proteins',
        'benefit': 'Essential for baby growth',
        'image': 'assets/images/foods/lean_proteins.png',
        'color': const Color(0xFFF59297),
        'examples': 'Fish, Chicken, Beans, Eggs',
      },
      {
        'name': 'Whole Grains',
        'benefit': 'Energy & fiber',
        'image': 'assets/images/foods/whole_grains.png',
        'color': const Color(0xFFF59E0B),
        'examples': 'Brown rice, Oats, Quinoa',
      },
      {
        'name': 'Dairy Products',
        'benefit': 'Calcium for bones',
        'image': 'assets/images/foods/dairy_products.png',
        'color': const Color(0xFF7DA8E6),
        'examples': 'Milk, Yogurt, Cheese',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Foods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2C2C),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: recommendedFoods.length,
            itemBuilder: (context, index) {
              final food = recommendedFoods[index];
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (food['color'] as Color).withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image Container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (food['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          food['image'].toString(),
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          // Fallback to icon if image fails to load
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback icons based on food type
                            IconData fallbackIcon;
                            switch (index) {
                              case 0:
                                fallbackIcon = Icons.eco_outlined;
                                break;
                              case 1:
                                fallbackIcon = Icons.food_bank_outlined;
                                break;
                              case 2:
                                fallbackIcon = Icons.grain_outlined;
                                break;
                              case 3:
                                fallbackIcon = Icons.local_drink_outlined;
                                break;
                              default:
                                fallbackIcon = Icons.restaurant_menu;
                            }
                            return Icon(
                              fallbackIcon,
                              color: food['color'] as Color,
                              size: 22,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      food['name'].toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        food['benefit'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        food['examples'].toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: food['color'] as Color,
                          fontWeight: FontWeight.w500,
                        ),
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
        'color': const Color(0xFFF59E0B),
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'meal': 'Mid-Morning',
        'time': '10:00 AM',
        'suggestion': 'Greek yogurt with fruit',
        'calories': '150 cal',
        'color': const Color(0xFF10B981),
        'icon': Icons.local_cafe_outlined,
      },
      {
        'meal': 'Lunch',
        'time': '1:00 PM',
        'suggestion': 'Grilled chicken salad',
        'calories': '450 cal',
        'color': const Color(0xFFF59297),
        'icon': Icons.lunch_dining_outlined,
      },
      {
        'meal': 'Snack',
        'time': '4:00 PM',
        'suggestion': 'Hummus with vegetables',
        'calories': '200 cal',
        'color': const Color(0xFF7DA8E6),
        'icon': Icons.cookie_outlined,
      },
      {
        'meal': 'Dinner',
        'time': '7:00 PM',
        'suggestion': 'Salmon with quinoa',
        'calories': '500 cal',
        'color': const Color(0xFF8B5CF6),
        'icon': Icons.dinner_dining_outlined,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Meal Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                  letterSpacing: -0.3,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.go('/meal-planner');
                },
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Plan'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7DA8E6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: mealPlan.map((meal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (meal['color'] as Color).withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (meal['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        meal['icon'] as IconData,
                        color: meal['color'] as Color,
                        size: 22,
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
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              Text(
                                meal['time'].toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            meal['suggestion'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            meal['calories'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: meal['color'] as Color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      color: const Color(0xFF10B981),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${meal['meal']} marked as completed!'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
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
        'icon': Icons.no_food_outlined,
        'color': const Color(0xFFDC2626),
      },
      {
        'name': 'High Mercury Fish',
        'reason': 'Can affect baby\'s development',
        'icon': Icons.warning_outlined,
        'color': const Color(0xFFF59E0B),
      },
      {
        'name': 'Alcohol',
        'reason': 'No safe amount during pregnancy',
        'icon': Icons.local_bar_outlined,
        'color': const Color(0xFFDC2626),
      },
      {
        'name': 'Excess Caffeine',
        'reason': 'Limit to 200mg per day',
        'icon': Icons.coffee_outlined,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foods to Limit or Avoid',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2C2C),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: avoidFoods.map((food) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (food['color'] as Color).withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (food['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            food['reason'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
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

  Widget _buildNutritionTips() {
    final nutritionVideos = [
      {
        'title': 'Pregnancy Nutrition: What to Eat During Pregnancy',
        'videoId': 'dQw4w9WgXcQ', // Replace with actual video ID
        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      },
      {
        'title': 'Essential Prenatal Vitamins Guide',
        'videoId': 'dQw4w9WgXcQ', // Replace with actual video ID
        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      },
      {
        'title': 'Healthy Pregnancy Diet Tips',
        'videoId': 'dQw4w9WgXcQ', // Replace with actual video ID
        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      },
      {
        'title': 'Managing Morning Sickness Through Diet',
        'videoId': 'dQw4w9WgXcQ', // Replace with actual video ID
        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Essential Nutrition Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2C2C),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7DA8E6).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: nutritionVideos.map((video) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => _launchYouTubeVideo(video['videoId']!),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Video thumbnail
                            Stack(
                              children: [
                                Image.network(
                                  video['thumbnail']!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 180,
                                      color: const Color(0xFF7DA8E6)
                                          .withOpacity(0.1),
                                      child: const Icon(
                                        Icons.play_circle_outline,
                                        size: 50,
                                        color: Color(0xFF7DA8E6),
                                      ),
                                    );
                                  },
                                ),
                                // Play button overlay
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.3),
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Video title
                            Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.white,
                              child: Text(
                                video['title']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C2C2C),
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _launchYouTubeVideo(String videoId) async {
    final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
    final youtubeAppUrl = 'youtube://watch?v=$videoId';

    try {
      // Try to open in YouTube app first
      if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
        await launchUrl(Uri.parse(youtubeAppUrl));
      } else {
        // Fall back to web browser
        await launchUrl(
          Uri.parse(youtubeUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // Handle error - maybe show a snackbar
      print('Could not launch video: $e');
    }
  }

  Widget _buildSupplementsSection() {
    final supplements = [
      {
        'name': 'Prenatal Vitamin',
        'dosage': '1 tablet daily',
        'time': 'With breakfast',
        'color': const Color(0xFFF59297),
        'taken': true,
      },
      {
        'name': 'Iron Supplement',
        'dosage': '30mg daily',
        'time': 'Between meals',
        'color': const Color(0xFFF59E0B),
        'taken': false,
      },
      {
        'name': 'Omega-3 (DHA)',
        'dosage': '200mg daily',
        'time': 'With dinner',
        'color': const Color(0xFF7DA8E6),
        'taken': true,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Supplements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2C2C),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: supplements.map((supplement) {
              final taken = supplement['taken'] as bool;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (supplement['color'] as Color).withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          supplement['taken'] = !taken;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              taken
                                  ? '${supplement['name']} unmarked'
                                  : '${supplement['name']} marked as taken!',
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: taken
                              ? (supplement['color'] as Color)
                              : Colors.transparent,
                          border: Border.all(
                            color: supplement['color'] as Color,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: taken
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
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
                              fontWeight: FontWeight.w600,
                              decoration:
                                  taken ? TextDecoration.lineThrough : null,
                              color: taken
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${supplement['dosage']} • ${supplement['time']}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
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

  Widget _buildNavigationMenu() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // App Bar in Menu
            Container(
              height: 120,
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7DA8E6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pregnant_woman,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Obaatanpa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Pregnancy Dashboard',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleMenu,
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationMenuItem(
                      title: 'Dashboard',
                      onTap: () =>
                          _navigateToPage('/dashboard/pregnant-mother'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      onTap: () => _navigateToPage('/resources'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      onTap: () => _navigateToPage('/appointments'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      isActive: true,
                      onTap: () => _navigateToPage('/nutrition'),
                      textColor: const Color(0xFF7DA8E6),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      onTap: () => _navigateToPage('/health'),
                      textColor: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
