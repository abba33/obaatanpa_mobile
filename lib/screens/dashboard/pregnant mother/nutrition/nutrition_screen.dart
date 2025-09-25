import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Bigger image
        Expanded(
          flex: 2, // give more space to the image
          child: Container(
            height: 160, // increased from 120
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/foods/food.png', // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Text content
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Healthy Nutrition for You & Baby',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Personalized guidance for your pregnancy journey',
                style: TextStyle(
                  fontSize: 15,
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
}


Widget _buildDailyNutritionGoals() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Nutrition Goals',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2C2C2C),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4, // 4 items in a row instead of 2
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 0.8, // more compact ratio
          children: [
            _buildNutritionGoalItem(
              'Calories',
              '2,200/2,500',
              0.88,
              const Color(0xFF10B981),
            ),
            _buildNutritionGoalItem(
              'Protein',
              '65g/75g',
              0.87,
              const Color(0xFFF59297),
            ),
            _buildNutritionGoalItem(
              'Folate',
              '550μg/600μg',
              0.92,
              const Color(0xFF7DA8E6),
            ),
            _buildNutritionGoalItem(
              'Iron',
              '22mg/27mg',
              0.81,
              const Color(0xFFF59E0B),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildNutritionGoalItem(
  String title,
  String goal,
  double progress,
  Color color,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularPercentIndicator(
        radius: 20.0, // much smaller circle
        lineWidth: 3.0, // thinner line
        percent: progress,
        progressColor: color,
        backgroundColor: color.withOpacity(0.2),
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C2C2C),
          ),
        ),
      ),
      const SizedBox(height: 2), // minimal gap
      Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C2C),
        ),
      ),
      Text(
        goal,
        style: const TextStyle(
          fontSize: 8,
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
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
      'infoUrl': 'https://www.mayoclinic.org/healthy-lifestyle/pregnancy-and-parenting/in-depth/pregnancy-nutrition/art-20043844',
    },
    {
      'name': 'Lean Proteins',
      'benefit': 'Essential for baby growth',
      'image': 'assets/images/foods/lean_proteins.png',
      'color': const Color(0xFFF59297),
      'examples': 'Fish, Chicken, Beans, Eggs',
      'infoUrl': 'https://www.babycenter.com/pregnancy/diet-and-fitness/protein-in-your-pregnancy-diet_1690',
    },
    {
      'name': 'Whole Grains',
      'benefit': 'Energy & fiber',
      'image': 'assets/images/foods/whole_grains.png',
      'color': const Color(0xFFF59E0B),
      'examples': 'Brown rice, Oats, Quinoa',
      'infoUrl': 'https://www.healthline.com/health/pregnancy/whole-grains-during-pregnancy',
    },
    {
      'name': 'Dairy Products',
      'benefit': 'Calcium for bones',
      'image': 'assets/images/foods/dairy_products.png',
      'color': const Color(0xFF7DA8E6),
      'examples': 'Milk, Yogurt, Cheese',
      'infoUrl': 'https://www.whattoexpect.com/pregnancy/eating-well/nutrients/calcium/',
    },
  ];

  Future<void> _launchInfoPage(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in browser
        );
      } else {
        // Handle error - maybe show a snackbar
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

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
            return GestureDetector(
              onTap: () => _launchInfoPage(food['infoUrl'].toString()),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Image.asset(
                          food['image'].toString(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.restaurant_menu,
                                color: food['color'] as Color,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient overlay for readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),

                      // Info icon indicator
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: food['color'] as Color,
                            size: 16,
                          ),
                        ),
                      ),

                      // Text info
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['name'].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food['benefit'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food['examples'].toString(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: food['color'] as Color,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
      'suggestion': 'Oatmeal with berries',
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
      'suggestion': 'Hummus with veggies',
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
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Meal Plan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C2C2C),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                context.go('/meal-planner');
              },
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF7DA8E6),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: mealPlan.map((meal) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (meal['color'] as Color).withOpacity(0.15),
                  width: 0.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: (meal['color'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      meal['icon'] as IconData,
                      color: meal['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            Text(
                              meal['time'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                meal['suggestion'].toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4B5563),
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: (meal['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                meal['calories'].toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: meal['color'] as Color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    color: const Color(0xFF10B981),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${meal['meal']} marked as completed!'),
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
      'image': 'assets/images/raw_fish_meat.jpg', // Add your image path
      'color': const Color(0xFFDC2626),
      'videoUrl': 'https://www.youtube.com/watch?v=Qf8pAwGsuF4', // Example: pregnancy food safety
    },
    {
      'name': 'High Mercury Fish',
      'reason': 'Can affect baby\'s development',
      'image': 'assets/images/mercury_fish.jpg', // Add your image path
      'color': const Color(0xFFF59E0B),
      'videoUrl': 'https://www.youtube.com/watch?v=BQHdBkW8paI', // Example: mercury in fish during pregnancy
    },
    {
      'name': 'Alcohol',
      'reason': 'No safe amount during pregnancy',
      'image': 'assets/images/alcohol.jpg', // Add your image path
      'color': const Color(0xFFDC2626),
      'videoUrl': 'https://www.youtube.com/watch?v=YkEuIvP6bHU', // Example: alcohol during pregnancy
    },
    {
      'name': 'Excess Caffeine',
      'reason': 'Limit to 200mg per day',
      'image': 'assets/images/coffee.jpg', // Add your image path
      'color': const Color(0xFFF59E0B),
      'videoUrl': 'https://www.youtube.com/watch?v=_YVJEh82PSk', // Example: caffeine during pregnancy
    },
  ];

  Future<void> _launchYouTubeVideo(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in YouTube app or browser
        );
      } else {
        // Handle error - maybe show a snackbar
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

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
            return GestureDetector(
              onTap: () => _launchYouTubeVideo(food['videoUrl'].toString()),
              child: Container(
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
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (food['color'] as Color).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            // The main image
                            Image.asset(
                              food['image'].toString(),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to a placeholder if image fails to load
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: (food['color'] as Color).withOpacity(0.12),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: food['color'] as Color,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                            // Play button overlay
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  food['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                              ),
                            ],
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
                          const SizedBox(height: 4),
                          Text(
                            'Tap to watch explanation video',
                            style: TextStyle(
                              fontSize: 11,
                              color: (food['color'] as Color).withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
