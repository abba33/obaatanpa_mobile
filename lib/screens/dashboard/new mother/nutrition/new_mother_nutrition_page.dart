import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class NewMotherNutritionPage extends StatefulWidget {
  const NewMotherNutritionPage({Key? key}) : super(key: key);

  @override
  State<NewMotherNutritionPage> createState() => _NewMotherNutritionPageState();
}

class _NewMotherNutritionPageState extends State<NewMotherNutritionPage> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();
    if (routeName != '/new-mother/nutrition') {
      context.go(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Header
                      const Text(
                        'Nutrition Guide',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Nourish yourself and your baby',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Nutrition Categories
                      _buildNutritionCard(
                        'Postpartum Recovery',
                        'Nutrition for healing and energy',
                        Icons.healing,
                        const Color(0xFF7DA8E6),
                        () => context.go('/new-mother/nutrition/recovery'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildNutritionCard(
                        'Breastfeeding Nutrition',
                        'Supporting milk production and quality',
                        Icons.child_friendly,
                        const Color(0xFF4CAF50),
                        () => context.go('/new-mother/nutrition/breastfeeding'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildNutritionCard(
                        'Meal Planning',
                        'Easy, nutritious meal ideas',
                        Icons.restaurant_menu,
                        const Color(0xFFFF9800),
                        () => context.go('/new-mother/nutrition/meal-planning'),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildNutritionCard(
                        'Supplements',
                        'Essential vitamins and minerals',
                        Icons.medication,
                        const Color(0xFF9C27B0),
                        () => context.go('/new-mother/nutrition/supplements'),
                      ),
                      const SizedBox(height: 24),
                      
                      // Daily Nutrition Overview
                      _buildDailyNutritionSection(),
                      const SizedBox(height: 24),
                      
                      // Key Nutrients Section
                      _buildKeyNutrientsSection(),
                      const SizedBox(height: 24),
                      
                      // Hydration Section
                      _buildHydrationSection(),
                      const SizedBox(height: 24),
                      
                      // Quick Meal Ideas
                      _buildQuickMealsSection(),
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

  Widget _buildNutritionCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyNutritionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pie_chart,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Nutrition',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Track your daily intake',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionStat('Calories', '1,800 / 2,200'),
              _buildNutritionStat('Water', '6 / 8 glasses'),
              _buildNutritionStat('Protein', '65g / 75g'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Log Meal'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyNutrientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Nutrients for New Mothers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildNutrientCard(
          'Iron',
          'Prevents anemia, supports energy',
          'Lean meat, spinach, beans',
          Icons.favorite,
          Colors.red,
        ),
        const SizedBox(height: 12),
        _buildNutrientCard(
          'Calcium',
          'Bone health for you and baby',
          'Dairy, leafy greens, almonds',
          Icons.sports_soccer,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildNutrientCard(
          'Omega-3',
          'Brain development, mood support',
          'Fish, walnuts, flaxseeds',
          Icons.psychology,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildNutrientCard(
          'Protein',
          'Tissue repair, milk production',
          'Eggs, chicken, quinoa',
          Icons.fitness_center,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildNutrientCard(String nutrient, String benefit, String sources, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nutrient,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  benefit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sources: $sources',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue, size: 24),
              SizedBox(width: 8),
              Text(
                'Stay Hydrated',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Breastfeeding mothers need extra fluids. Aim for 8-10 glasses of water daily, plus other healthy beverages.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHydrationTip('Water with every feeding'),
              const SizedBox(width: 16),
              _buildHydrationTip('Herbal teas count too'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationTip(String tip) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.blue, size: 16),
        const SizedBox(width: 4),
        Text(
          tip,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickMealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick & Nutritious Meal Ideas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildMealCard(
          'Breakfast',
          'Overnight oats with berries and nuts',
          '5 min prep • High in fiber & protein',
          Icons.breakfast_dining,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildMealCard(
          'Lunch',
          'Quinoa salad with grilled chicken',
          '15 min • Complete protein source',
          Icons.lunch_dining,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildMealCard(
          'Snack',
          'Greek yogurt with almonds',
          '2 min • Calcium & protein rich',
          Icons.cookie,
          Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildMealCard(
          'Dinner',
          'Salmon with roasted vegetables',
          '25 min • Omega-3 & vitamins',
          Icons.dinner_dining,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildMealCard(String mealType, String description, String details, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$mealType: $description',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
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
                      Icons.baby_changing_station,
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
                        'New Mother Dashboard',
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
                      onTap: () => _navigateToPage('/new-mother/dashboard'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      onTap: () => _navigateToPage('/new-mother/resources'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      onTap: () => _navigateToPage('/new-mother/appointments'),
                      textColor: Colors.black87,
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      isActive: true,
                      onTap: () => _navigateToPage('/new-mother/nutrition'),
                      textColor: const Color(0xFF7DA8E6),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      onTap: () => _navigateToPage('/new-mother/health'),
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