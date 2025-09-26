import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NutritionScreen extends StatefulWidget {
  final int pregnancyWeek;
  final String trimester;

  const NutritionScreen({
    super.key,
    this.pregnancyWeek = 20,
    this.trimester = '2nd Trimester',
  });

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
  
  // API-related variables
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
    selectedTrimester = widget.trimester;
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await _storage.read(key: 'auth_token');
    setState(() {
      authToken = token;
    });
    if (authToken != null) {
      fetchMealPlan();
      fetchRecipes();
    } else {
      setState(() {
        error = 'Please log in to access nutrition data.';
      });
      context.go('/login');
    }
  }

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

  String _getApiTrimester() {
    switch (selectedTrimester) {
      case '1st Trimester':
        return 'first';
      case '2nd Trimester':
        return 'second';
      case '3rd Trimester':
        return 'third';
      default:
        return 'second';
    }
  }

  Future<void> fetchMealPlan() async {
    if (authToken == null) {
      setState(() {
        error = 'Please log in to fetch meal plan.';
      });
      context.go('/login');
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
      
      if (response.statusCode == 200) {
        final mealData = jsonDecode(response.body);
        setState(() {
          todaysMeals = [
            Meal(
              time: 'Breakfast',
              recipe: Recipe.fromJson(mealData['breakfast']),
            ),
            Meal(
              time: 'Snack',
              recipe: Recipe.fromJson(mealData['snack']),
            ),
            Meal(
              time: 'Lunch',
              recipe: Recipe.fromJson(mealData['lunch']),
            ),
            Meal(
              time: 'Snack',
              recipe: Recipe.fromJson(mealData['snack']),
            ),
            Meal(
              time: 'Dinner',
              recipe: Recipe.fromJson(mealData['dinner']),
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
        if (response.statusCode == 401) context.go('/login');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch meal plan: $e';
      });
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
      context.go('/login');
      return;
    }
    setState(() {
      recipesLoading = true;
      recipesError = null;
    });
    try {
      final response = await http.get(
        Uri.parse('https://obaatanpa-backend.onrender.com/recipes/all?page=$page&per_page=5&trimester=${_getApiTrimester()}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'];
          totalPages = (data['total'] / 5).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
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
        if (response.statusCode == 401) context.go('/login');
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to fetch recipes: $e';
      });
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
      context.go('/login');
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
        url = 'https://obaatanpa-backend.onrender.com/recipes/search/name/${Uri.encodeComponent(searchTerm)}';
      } else if (searchType == 'ingredient') {
        url = 'https://obaatanpa-backend.onrender.com/recipes/search/ingredient';
        params['items'] = searchTerm;
      } else {
        url = 'https://obaatanpa-backend.onrender.com/recipes/search/section/${Uri.encodeComponent(searchTerm)}';
      }
      
      final response = await http.get(
        Uri.parse(url).replace(queryParameters: params),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'];
          totalPages = (data['total'] / (searchType == 'section' ? 3 : 5)).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
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
        if (response.statusCode == 401) context.go('/login');
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to search recipes: $e';
        recipes = [];
      });
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
      final response = await http.get(
        Uri.parse(previousUrl!),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'];
          totalPages = (data['total'] / (searchType == 'section' ? 3 : 5)).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
      } else {
        setState(() {
          recipesError = 'Failed to fetch previous page.';
        });
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to fetch previous page: $e';
      });
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
      final response = await http.get(
        Uri.parse(nextUrl!),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recipes = (data['recipes'] as List)
              .map((r) => Recipe.fromJson(r))
              .toList();
          currentPage = data['page'];
          totalPages = (data['total'] / (searchType == 'section' ? 3 : 5)).ceil();
          nextUrl = data['next'];
          previousUrl = data['previous'];
        });
      } else {
        setState(() {
          recipesError = 'Failed to fetch next page.';
        });
      }
    } catch (e) {
      setState(() {
        recipesError = 'Failed to fetch next page: $e';
      });
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
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      if (error != null) _buildErrorMessage(error!),
                      _buildDailyNutritionGoals(),
                      _buildRecipeSearchSection(),
                      if (recipesError != null) _buildErrorMessage(recipesError!),
                      _buildRecommendedFoods(),
                      _buildMealPlanningSection(),
                      _buildFoodsToAvoid(),
                      _buildNutritionTips(),
                      _buildSupplementsSection(),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Healthy Nutrition for You & Baby',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C2C2C),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Week ${widget.pregnancyWeek} • $selectedTrimester',
                      style: const TextStyle(
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
                    fetchMealPlan();
                    fetchRecipes();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == trimesters.length - 1 ? 0 : 8,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF59297) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFF59297) : const Color(0xFFE5E7EB),
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
                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
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

  Widget _buildErrorMessage(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            crossAxisCount: 4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.8,
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
          radius: 20.0,
          lineWidth: 3.0,
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
        const SizedBox(height: 2),
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

  Widget _buildRecipeSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recipe Suggestions',
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

  Widget _buildRecommendedFoods() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Recipes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2C2C),
              letterSpacing: -0.3,
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
                onPressed: isLoading ? null : fetchMealPlan,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7DA8E6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF59297)),
                )
              : todaysMeals.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Center(
                        child: Text(
                          'No meal plan available. Please refresh or try again later.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Column(
                      children: todaysMeals.map((meal) {
                        return GestureDetector(
                          onTap: () => showRecipeDialog(meal.recipe),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFF59297).withOpacity(0.15),
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
                                    color: const Color(0xFFF59297).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_menu,
                                    color: Color(0xFFF59297),
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
                                            meal.time,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2C2C2C),
                                            ),
                                          ),
                                          if (meal.recipe.servings != null)
                                            Text(
                                              meal.recipe.servings!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF6B7280),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        meal.recipe.name,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF4B5563),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
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

  Widget _buildFoodsToAvoid() {
    final avoidFoods = [
      {
        'name': 'Raw Fish & Meat',
        'reason': 'Risk of bacterial infection',
        'color': const Color(0xFFDC2626),
        'videoUrl': 'https://www.youtube.com/watch?v=Qf8pAwGsuF4',
      },
      {
        'name': 'High Mercury Fish',
        'reason': 'Can affect baby\'s development',
        'color': const Color(0xFFF59E0B),
        'videoUrl': 'https://www.youtube.com/watch?v=BQHdBkW8paI',
      },
      {
        'name': 'Alcohol',
        'reason': 'No safe amount during pregnancy',
        'color': const Color(0xFFDC2626),
        'videoUrl': 'https://www.youtube.com/watch?v=YkEuIvP6bHU',
      },
      {
        'name': 'Excess Caffeine',
        'reason': 'Limit to 200mg per day',
        'color': const Color(0xFFF59E0B),
        'videoUrl': 'https://www.youtube.com/watch?v=_YVJEh82PSk',
      },
    ];

    Future<void> _launchYouTubeVideo(String url) async {
      final Uri uri = Uri.parse(url);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
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
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (food['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.no_food_outlined,
                                color: food['color'] as Color,
                                size: 20,
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ),
                            ),
                          ],
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
        'title': 'Pregnancy Nutrition: Essential Foods for Baby\'s Development',
        'videoId': 'zBtJCDi1qRY', // Mayo Clinic pregnancy nutrition
        'thumbnail': 'https://img.youtube.com/vi/zBtJCDi1qRY/maxresdefault.jpg',
        'duration': '4:32',
      },
      {
        'title': 'What to Eat During Pregnancy - Complete Guide',
        'videoId': '9v6I8YLr8lQ', // Cleveland Clinic pregnancy diet
        'thumbnail': 'https://img.youtube.com/vi/9v6I8YLr8lQ/maxresdefault.jpg',
        'duration': '6:18',
      },
      {
        'title': 'Prenatal Vitamins: What You Need to Know',
        'videoId': 'kLcXdKPQhSQ', // Johns Hopkins prenatal vitamins
        'thumbnail': 'https://img.youtube.com/vi/kLcXdKPQhSQ/maxresdefault.jpg',
        'duration': '3:45',
      },
      {
        'title': 'Managing Morning Sickness with Smart Food Choices',
        'videoId': 'QdqZ8QY7pXs', // WebMD morning sickness tips
        'thumbnail': 'https://img.youtube.com/vi/QdqZ8QY7pXs/maxresdefault.jpg',
        'duration': '5:12',
      },
      {
        'title': 'Healthy Weight Gain During Pregnancy',
        'videoId': 'H4YPSVsx_Qo', // ACOG weight gain guidelines
        'thumbnail': 'https://img.youtube.com/vi/H4YPSVsx_Qo/maxresdefault.jpg',
        'duration': '4:56',
      },
      {
        'title': 'Foods to Avoid During Pregnancy',
        'videoId': 'rGlGZ8E8_7s', // BabyCenter safety guide
        'thumbnail': 'https://img.youtube.com/vi/rGlGZ8E8_7s/maxresdefault.jpg',
        'duration': '7:23',
      },
    ];

    void _launchYouTubeVideo(String videoId) async {
      final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
      final youtubeAppUrl = 'youtube://watch?v=$videoId';

      try {
        if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
          await launchUrl(Uri.parse(youtubeAppUrl));
        } else {
          await launchUrl(
            Uri.parse(youtubeUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } catch (e) {
        debugPrint('Could not launch video: $e');
        // Show snackbar or toast with error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open video. Please try again.'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Color(0xFF7DA8E6),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Nutrition Video Library',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Expert advice for healthy pregnancy nutrition',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
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
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: nutritionVideos.length,
              itemBuilder: (context, index) {
                final video = nutritionVideos[index];
                return GestureDetector(
                  onTap: () => _launchYouTubeVideo(video['videoId']!),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Image.network(
                                    video['thumbnail']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: const Color(0xFF7DA8E6).withOpacity(0.1),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.play_circle_outline,
                                              size: 40,
                                              color: Color(0xFF7DA8E6),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Video',
                                              style: TextStyle(
                                                color: Color(0xFF7DA8E6),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.center,
                                        end: Alignment.center,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.3),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      video['duration']!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      video['title']!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C2C2C),
                                        height: 1.3,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.play_circle_outline,
                                        size: 14,
                                        color: Color(0xFF7DA8E6),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Watch now',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF7DA8E6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                              decoration: taken ? TextDecoration.lineThrough : null,
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
                            if (selectedRecipe!.ingredients is List)
                              ...List.generate(
                                (selectedRecipe!.ingredients as List).length,
                                (index) => Text(
                                  '• ${(selectedRecipe!.ingredients as List)[index]}',
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                                ),
                              )
                            else if (selectedRecipe!.ingredients is String)
                              ...[
                                Text(
                                  (selectedRecipe!.ingredients as String).split('\n').map((e) => '• $e').join('\n'),
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                                ),
                              ],
                            const SizedBox(height: 16),
                          ],
                          if (selectedRecipe!.directions != null) ...[
                            const Text(
                              'Directions',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            if (selectedRecipe!.directions is List)
                              ...List.generate(
                                (selectedRecipe!.directions as List).length,
                                (index) => Text(
                                  '${index + 1}. ${(selectedRecipe!.directions as List)[index]}',
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                                ),
                              )
                            else if (selectedRecipe!.directions is String)
                              ...[
                                Text(
                                  (selectedRecipe!.directions as String).split('\n').asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n'),
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                                ),
                              ],
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
                        'Your Pregnancy Dashboard',
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
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/dashboard'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/resources'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/appointments'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      isActive: true,
                      textColor: const Color(0xFFF59297),
                      onTap: () => _navigateToPage('/nutrition'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/health'),
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
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      ingredients: ingredients,
      directions: directions,
      servings: json['servings']?.toString(),
      section: json['section']?.toString() ?? '',
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}