import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class NewMotherNutritionPage extends StatefulWidget {
  const NewMotherNutritionPage({super.key});

  @override
  State<NewMotherNutritionPage> createState() => _NewMotherNutritionPageState();
}

class _NewMotherNutritionPageState extends State<NewMotherNutritionPage> {
  bool _isMenuOpen = false;
  String selectedStage = 'Early Postpartum';
  final List<String> stages = [
    'Early Postpartum',
    'Late Postpartum',
    'Breastfeeding',
  ];
  String? authToken;
  bool isLoading = false;
  String? error;
  List<Meal> todaysMeals = [];
  List<Recipe> recipes = [];
  bool recipesLoading = false;
  String? recipesError;
  String searchTerm = '';
  String searchType = 'name';
  int currentPage = 1;
  int totalPages = 1;
  String? nextUrl;
  String? previousUrl;
  Recipe? selectedRecipe;
  bool showRecipeModal = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await _storage.read(key: 'auth_token');
    setState(() {
      authToken = token;
      debugPrint('Auth Token: $authToken');
    });
    if (authToken != null) {
      fetchMealPlan();
      fetchRecipes();
    } else {
      setState(() {
        error = 'Please log in to access nutrition data.';
      });
      context.go('/auth/login');
    }
  }

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

  String _getApiStage() {
    switch (selectedStage) {
      case 'Early Postpartum':
        return 'early_postpartum';
      case 'Late Postpartum':
        return 'late_postpartum';
      case 'Breastfeeding':
        return 'breastfeeding';
      default:
        return 'early_postpartum';
    }
  }

  Future<void> fetchMealPlan() async {
    if (authToken == null) {
      setState(() {
        error = 'Please log in to fetch meal plan.';
      });
      context.go('/auth/login');
      return;
    }
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await http.get(
        Uri.parse('https://obaatanpa-backend.onrender.com/recipes/meal/plan/daily'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      debugPrint('Meal Plan API response status: ${response.statusCode}');
      debugPrint('Meal Plan API response body: ${response.body}');
      if (response.statusCode == 200) {
        final mealData = jsonDecode(response.body);
        setState(() {
          todaysMeals = [
            Meal(
              time: 'Breakfast',
              recipe: Recipe.fromJson(mealData['breakfast'] ?? {}),
            ),
            Meal(
              time: 'Snack',
              recipe: Recipe.fromJson(mealData['snack'] ?? {}),
            ),
            Meal(
              time: 'Lunch',
              recipe: Recipe.fromJson(mealData['lunch'] ?? {}),
            ),
            Meal(
              time: 'Snack',
              recipe: Recipe.fromJson(mealData['snack'] ?? {}),
            ),
            Meal(
              time: 'Dinner',
              recipe: Recipe.fromJson(mealData['dinner'] ?? {}),
            ),
          ];
          error = null;
        });
      } else {
        setState(() {
          error = response.statusCode == 401
              ? 'Unauthorized access. Please log in again.'
              : response.statusCode == 404
                  ? 'Meal plan service not found.'
                  : 'Failed to fetch meal plan.';
        });
        if (response.statusCode == 401) context.go('/auth/login');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch meal plan: $e';
      });
      debugPrint('Error fetching meal plan: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchRecipes({int page = 1}) async {
    if (authToken == null) {
      setState(() {
        recipesError = 'Please log in to fetch recipes.';
      });
      context.go('/auth/login');
      return;
    }
    setState(() {
      recipesLoading = true;
      recipesError = null;
    });
    try {
      debugPrint('Fetching recipes for page $page, stage: ${_getApiStage()}');
      final response = await http.get(
        Uri.parse(
            'https://obaatanpa-backend.onrender.com/recipes/all?page=$page&per_page=5&stage=${_getApiStage()}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      debugPrint('Recipes API response status: ${response.statusCode}');
      debugPrint('Recipes API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'] ?? page;
          totalPages = (data['total'] / 5).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
        debugPrint('Successfully fetched ${recipes.length} recipes');
      } else {
        setState(() {
          recipesError = response.statusCode == 401
              ? 'Unauthorized access. Please log in again.'
              : response.statusCode == 404
                  ? 'Recipes service not found.'
                  : response.statusCode == 422
                      ? 'Invalid request parameters.'
                      : 'Failed to fetch recipes.';
        });
        if (response.statusCode == 401) context.go('/auth/login');
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to fetch recipes: $e';
      });
      debugPrint('Error fetching recipes: $e');
    } finally {
      setState(() {
        recipesLoading = false;
      });
    }
  }

  Future<void> handleSearch() async {
    if (authToken == null) {
      setState(() {
        recipesError = 'Please log in to search for recipes.';
      });
      context.go('/auth/login');
      return;
    }
    if (searchTerm.trim().isEmpty) {
      setState(() {
        recipesError = 'Please enter a search term.';
      });
      return;
    }
    setState(() {
      recipesLoading = true;
      recipesError = null;
    });
    try {
      String url;
      Map<String, String> params = {'page': '1', 'per_page': searchType == 'section' ? '3' : '5'};
      if (searchType == 'name') {
        url =
            'https://obaatanpa-backend.onrender.com/recipes/search/name/${Uri.encodeComponent(searchTerm)}';
      } else if (searchType == 'ingredient') {
        url = 'https://obaatanpa-backend.onrender.com/recipes/search/ingredient';
        params['items'] = searchTerm;
      } else {
        url =
            'https://obaatanpa-backend.onrender.com/recipes/search/section/${Uri.encodeComponent(searchTerm)}';
      }
      debugPrint('Searching recipes with type: $searchType, term: $searchTerm, url: $url');
      final response = await http.get(
        Uri.parse(url).replace(queryParameters: params),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      debugPrint('Search API response status: ${response.statusCode}');
      debugPrint('Search API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'] ?? 1;
          totalPages = (data['total'] / (searchType == 'section' ? 3 : 5)).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
        debugPrint('Successfully fetched ${recipes.length} search results');
      } else {
        setState(() {
          recipesError = response.statusCode == 401
              ? 'Unauthorized access. Please log in again.'
              : response.statusCode == 404
                  ? 'Search service not found.'
                  : response.statusCode == 422
                      ? 'Invalid search parameters.'
                      : 'Failed to search recipes.';
          recipes = [];
        });
        if (response.statusCode == 401) context.go('/auth/login');
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to search recipes: $e';
        recipes = [];
      });
      debugPrint('Error searching recipes: $e');
    } finally {
      setState(() {
        recipesLoading = false;
      });
    }
  }

  Future<void> handlePreviousPage() async {
    if (previousUrl == null || authToken == null) return;
    setState(() {
      recipesLoading = true;
      recipesError = null;
    });
    try {
      debugPrint('Fetching previous page: $previousUrl');
      final response = await http.get(
        Uri.parse(previousUrl!),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      debugPrint('Previous page API response status: ${response.statusCode}');
      debugPrint('Previous page API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'] ?? currentPage;
          totalPages = (data['total'] / (searchType == 'section' ? 3 : 5)).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
        debugPrint('Successfully fetched ${recipes.length} recipes for previous page');
      } else {
        setState(() {
          recipesError = 'Failed to fetch previous page.';
        });
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to fetch previous page: $e';
      });
      debugPrint('Error fetching previous page: $e');
    } finally {
      setState(() {
        recipesLoading = false;
      });
    }
  }

  Future<void> handleNextPage() async {
    if (nextUrl == null || authToken == null) return;
    setState(() {
      recipesLoading = true;
      recipesError = null;
    });
    try {
      debugPrint('Fetching next page: $nextUrl');
      final response = await http.get(
        Uri.parse(nextUrl!),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      debugPrint('Next page API response status: ${response.statusCode}');
      debugPrint('Next page API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'] ?? currentPage;
          totalPages = (data['total'] / (searchType == 'section' ? 3 : 5)).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
        debugPrint('Successfully fetched ${recipes.length} recipes for next page');
      } else {
        setState(() {
          recipesError = 'Failed to fetch next page.';
        });
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to fetch next page: $e';
      });
      debugPrint('Error fetching next page: $e');
    } finally {
      setState(() {
        recipesLoading = false;
      });
    }
  }

  void showRecipeDialog(Recipe recipe) {
    setState(() {
      selectedRecipe = recipe;
      showRecipeModal = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                isMenuOpen: _isMenuOpen,
                onMenuTap: _toggleMenu,
                title: 'Nutrition',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 16),
                      _buildStageSelector(),
                      const SizedBox(height: 24),
                      _buildNutritionCategories(),
                      _buildDailyNutritionSection(),
                      const SizedBox(height: 24),
                      _buildRecipeSearchSection(),
                      if (recipesError != null) _buildErrorMessage(recipesError!),
                      _buildRecommendedRecipes(),
                      const SizedBox(height: 24),
                      _buildMealPlanningSection(),
                      const SizedBox(height: 24),
                      _buildKeyNutrientsSection(),
                      const SizedBox(height: 24),
                      _buildHydrationSection(),
                      const SizedBox(height: 24),
                      _buildQuickMealsSection(),
                      const SizedBox(height: 24),
                      _buildNutritionTips(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isMenuOpen) _buildNavigationMenu(),
          if (showRecipeModal && selectedRecipe != null) _buildRecipeDialog(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Guide for New Mothers',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Text(
          'Nourish yourself and your baby',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStageSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stages.length,
        itemBuilder: (context, index) {
          final stage = stages[index];
          final isSelected = stage == selectedStage;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStage = stage;
              });
              fetchMealPlan();
              fetchRecipes();
            },
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 8,
                right: index == stages.length - 1 ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF59297) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF59297) : Colors.grey[300]!,
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
                stage,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCategories() {
    return Column(
      children: [
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
      ],
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

  Widget _buildRecipeSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recipe Suggestions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
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
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => searchTerm = value),
                        decoration: InputDecoration(
                          hintText: 'Search by ${searchType.capitalize()}',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: searchType,
                      items: ['name', 'ingredient', 'section']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.capitalize()),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => searchType = value!),
                      style: const TextStyle(color: Color(0xFF2C2C2C), fontSize: 14),
                      underline: const SizedBox(),
                      dropdownColor: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: recipesLoading ? null : handleSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59297),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: recipesLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Search'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: recipesLoading ? null : () => fetchRecipes(page: 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59297),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: recipesLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Browse All Recipes', style: TextStyle(fontSize: 16)),
                ),
                if (recipes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: previousUrl != null && !recipesLoading ? handlePreviousPage : null,
                        icon: const Icon(Icons.chevron_left, color: Color(0xFFF59297)),
                        disabledColor: Colors.grey,
                      ),
                      Text(
                        'Page $currentPage of $totalPages',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                      IconButton(
                        onPressed: nextUrl != null && !recipesLoading ? handleNextPage : null,
                        icon: const Icon(Icons.chevron_right, color: Color(0xFFF59297)),
                        disabledColor: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedRecipes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Recipes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          recipesLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF59297)),
                )
              : recipes.isEmpty
                  ? const Center(
                      child: Text(
                        'No recipes available. Try searching or browsing all recipes.',
                        style: TextStyle(color: Color(0xFF6B7280)),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return GestureDetector(
                          onTap: () => showRecipeDialog(recipe),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFF59297).withOpacity(0.3),
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
                              children: [
                                Flexible(
                                  child: Text(
                                    recipe.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C2C2C),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.restaurant_menu, color: Color(0xFFF59297), size: 16),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        recipe.servings ?? 'N/A servings',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => showRecipeDialog(recipe),
                                    child: const Text(
                                      'View Recipe',
                                      style: TextStyle(
                                        color: Color(0xFFF59297),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: isLoading ? null : fetchMealPlan,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7DA8E6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF59297)),
                )
              : Column(
                  children: todaysMeals.map((meal) {
                    return GestureDetector(
                      onTap: () => showRecipeDialog(meal.recipe),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF59297).withOpacity(0.2),
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
                                color: const Color(0xFFF59297).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                color: Color(0xFFF59297),
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
                                        meal.time,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2C2C2C),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          meal.recipe.description ?? 'No description available',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFFF59297),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    meal.recipe.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4B5563),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFFF59297),
                              size: 16,
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

  Widget _buildKeyNutrientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Nutrients for New Mothers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
            color: Colors.black87,
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

  Widget _buildNutritionTips() {
    final tips = [
      'Stay hydrated - drink 8-10 glasses of water daily',
      'Take postnatal vitamins as recommended by your doctor',
      'Eat small, frequent meals to maintain energy',
      'Listen to your body and eat when hungry',
      'Choose colorful fruits and vegetables for variety',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Essential Nutrition Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
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
              children: tips.map((tip) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
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

  Widget _buildRecipeDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59297), Color(0xFF7DA8E6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            selectedRecipe!.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => showRecipeModal = false),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedRecipe!.section.isNotEmpty) ...[
                            const Text(
                              'Section',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              selectedRecipe!.section.capitalize(),
                              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (selectedRecipe!.description != null) ...[
                            const Text(
                              'Description',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              selectedRecipe!.description!,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (selectedRecipe!.servings != null) ...[
                            const Text(
                              'Servings',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              selectedRecipe!.servings!,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (selectedRecipe!.ingredients != null) ...[
                            const Text(
                              'Ingredients',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            ...selectedRecipe!.ingredients!.map(
                              (ingredient) => Text(
                                '• $ingredient',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (selectedRecipe!.directions != null) ...[
                            const Text(
                              'Directions',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            ...selectedRecipe!.directions!.asMap().entries.map(
                                  (entry) => Text(
                                    '${entry.key + 1}. ${entry.value}',
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                                  ),
                                ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => showRecipeModal = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFF59297),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.white,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF59297),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
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
                      textColor: const Color(0xFFF59297),
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

class Meal {
  final String time;
  final Recipe recipe;

  Meal({required this.time, required this.recipe});
}

class Recipe {
  final String name;
  final String? description;
  final List<String>? ingredients;
  final List<String>? directions;
  final String? servings;
  final String section;

  Recipe({
    required this.name,
    this.description,
    this.ingredients,
    this.directions,
    this.servings,
    required this.section,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String>? ingredients;
    if (json['ingredients'] is List) {
      ingredients = (json['ingredients'] as List).map((e) => e.toString()).toList();
    } else if (json['ingredients'] is String) {
      ingredients = (json['ingredients'] as String)
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();
    } else {
      ingredients = null;
    }

    List<String>? directions;
    if (json['directions'] is List) {
      directions = (json['directions'] as List).map((e) => e.toString()).toList();
    } else if (json['directions'] is String) {
      directions = (json['directions'] as String)
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList();
    } else {
      directions = null;
    }

    return Recipe(
      name: json['name']?.toString() ?? 'Unknown Recipe',
      description: json['description']?.toString(),
      ingredients: ingredients,
      directions: directions,
      servings: json['servings']?.toString(),
      section: json['section']?.toString() ?? 'Unknown',
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}