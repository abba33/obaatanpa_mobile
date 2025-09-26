import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  bool isMenuOpen = false;
  String? authToken;
  bool isLoading = false;
  String? errorMessage;
  bool showDueDateModal = false;
  String? dueDateMethod;
  String lastPeriodDate = '';
  String cycleLength = '28';
  String conceptionDate = '';
  Map<String, dynamic>? dueDateResult;
  String? dueDateError;
  bool dueDateLoading = false;
  bool showWeightModal = false;
  String prePregnancyWeight = '';
  String height = '';
  String gestationalAge = '';
  Map<String, dynamic>? weightResult;
  String? weightError;
  bool weightLoading = false;
  bool showBabyProductsModal = false;
  List<dynamic> categories = [];
  dynamic selectedCategory;
  List<dynamic> categoryItems = [];
  String? productsError;
  bool productsLoading = false;
  final int pregnancyWeek = 20;
  final String trimester = 'second';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    print('ResourcesScreen: Initializing ResourcesScreen');
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    print('ResourcesScreen: Loading auth token');
    final token = await _storage.read(key: 'auth_token');
    setState(() {
      authToken = token;
      if (authToken == null) {
        errorMessage = 'Please log in to access features like calculators and product guides.';
        print('ResourcesScreen: No auth token found, errorMessage set: $errorMessage');
      } else {
        print('ResourcesScreen: Auth token loaded successfully');
      }
    });
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      print('ResourcesScreen: Navigation menu toggled: isMenuOpen=$isMenuOpen');
    });
  }

  void _navigateToPage(String routeName) {
    print('ResourcesScreen: Navigating to route: $routeName');
    _toggleMenu();
    if (routeName != '/resources') {
      context.go(routeName);
    } else {
      print('ResourcesScreen: Navigation ignored: Already on /resources');
    }
  }

  Future<void> _launchYouTubeVideo(String videoId) async {
    print('ResourcesScreen: Launching YouTube video: videoId=$videoId');
    final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final youtubeAppUrl = Uri.parse('youtube://www.youtube.com/watch?v=$videoId');

    try {
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl);
        print('ResourcesScreen: Opened YouTube video in app: $youtubeAppUrl');
      } else {
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
        print('ResourcesScreen: Opened YouTube video in browser: $youtubeUrl');
      }
    } catch (e) {
      print('ResourcesScreen: Error launching YouTube video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open video')),
      );
    }
  }

  Future<void> _fetchCategories() async {
    if (authToken == null) {
      setState(() {
        productsError = 'Please log in to view baby products.';
        print('ResourcesScreen: Fetch Categories: User not authenticated, productsError set: $productsError');
      });
      return;
    }
    setState(() {
      productsLoading = true;
      productsError = null;
      print('ResourcesScreen: Starting fetch categories, productsLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/baby_products/categories';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('ResourcesScreen: Fetch Categories Request: URL=$url, Headers=$headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('ResourcesScreen: Fetch Categories Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('ResourcesScreen: Fetch Categories Parsed Data: $data');
        setState(() {
          categories = data['categories'] ?? [];
          if (categories.isEmpty) {
            productsError = 'No categories available.';
            print('ResourcesScreen: No categories found, productsError set: $productsError');
          } else {
            print('ResourcesScreen: Categories loaded: ${categories.length} categories');
          }
        });
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        productsError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : 'Failed to fetch product categories: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
        }
        print('ResourcesScreen: Fetch Categories Error: $e, productsError set: $productsError');
      });
    } finally {
      setState(() {
        productsLoading = false;
        print('ResourcesScreen: Fetch categories completed, productsLoading set to false');
      });
    }
  }

  Future<void> _fetchCategoryItems(int categoryId) async {
    if (authToken == null) {
      setState(() {
        productsError = 'Please log in to view baby products.';
        print('ResourcesScreen: Fetch Category Items: User not authenticated, productsError set: $productsError');
      });
      return;
    }
    setState(() {
      productsLoading = true;
      productsError = null;
      print('ResourcesScreen: Starting fetch category items for categoryId=$categoryId, productsLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/baby_products/categories/items/$categoryId';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('ResourcesScreen: Fetch Category Items Request: URL=$url, Headers=$headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('ResourcesScreen: Fetch Category Items Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('ResourcesScreen: Fetch Category Items Parsed Data: $data');
        final category = categories.firstWhere(
          (cat) => cat['id'] == categoryId,
          orElse: () => null,
        );
        if (category == null) {
          throw Exception('Category with ID $categoryId not found');
        }
        final categoryName = category['name'] as String? ?? 'Unknown';
        print('ResourcesScreen: Processing items for category: $categoryName');
        setState(() {
          print('ResourcesScreen: Checking data structure: has items=${data.containsKey('items')}');
          if (data.containsKey('items')) {
            print('ResourcesScreen: Items array length=${data['items'].length}');
            if (data['items'].isNotEmpty) {
              print('ResourcesScreen: Checking categoryName in first item: ${data['items'][0].containsKey(categoryName)}');
              if (data['items'][0].containsKey(categoryName)) {
                print('ResourcesScreen: Category array length=${data['items'][0][categoryName].length}');
                if (data['items'][0][categoryName].isNotEmpty && data['items'][0][categoryName][0].containsKey('items')) {
                  categoryItems = data['items'][0][categoryName][0]['items'] ?? [];
                  print('ResourcesScreen: Category items assigned: ${categoryItems.length} items');
                } else {
                  categoryItems = [];
                  productsError = 'No items found in category structure.';
                  print('ResourcesScreen: No items in category structure, productsError set: $productsError');
                }
              } else {
                categoryItems = [];
                productsError = 'Category $categoryName not found in response.';
                print('ResourcesScreen: Category not in response, productsError set: $productsError');
              }
            } else {
              categoryItems = [];
              productsError = 'Items array is empty.';
              print('ResourcesScreen: Items array empty, productsError set: $productsError');
            }
          } else {
            categoryItems = [];
            productsError = 'No items key in response.';
            print('ResourcesScreen: No items key, productsError set: $productsError');
          }
          if (categoryItems.isEmpty && productsError == null) {
            productsError = 'No items available for this category.';
            print('ResourcesScreen: No items found for categoryId=$categoryId, productsError set: $productsError');
          } else if (categoryItems.isNotEmpty) {
            print('ResourcesScreen: Category items loaded: ${categoryItems.length} items for categoryId=$categoryId');
          }
        });
      } else {
        throw Exception('Failed to fetch category items: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        productsError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : 'Failed to fetch category items: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
        }
        print('ResourcesScreen: Fetch Category Items Error: $e, productsError set: $productsError');
      });
    } finally {
      setState(() {
        productsLoading = false;
        print('ResourcesScreen: Fetch category items completed, productsLoading set to false');
      });
    }
  }

  Future<void> _handleDueDateSubmit() async {
    print('ResourcesScreen: Due Date Calculator Submit Initiated, dueDateMethod=$dueDateMethod');
    if (authToken == null) {
      setState(() {
        dueDateError = 'Please log in to use the Due Date Calculator.';
        print('ResourcesScreen: Due Date Submit: User not authenticated, dueDateError set: $dueDateError');
      });
      return;
    }
    if (dueDateMethod == 'menstrual' && (lastPeriodDate.isEmpty || cycleLength.isEmpty)) {
      setState(() {
        dueDateError = 'Please provide both last period date and cycle length.';
        print('ResourcesScreen: Due Date Submit Validation Failed: lastPeriodDate=$lastPeriodDate, cycleLength=$cycleLength, dueDateError set: $dueDateError');
      });
      return;
    }
    if (dueDateMethod == 'conception' && conceptionDate.isEmpty) {
      setState(() {
        dueDateError = 'Please provide the conception date.';
        print('ResourcesScreen: Due Date Submit Validation Failed: conceptionDate=$conceptionDate, dueDateError set: $dueDateError');
      });
      return;
    }
    setState(() {
      dueDateLoading = true;
      dueDateError = null;
      print('ResourcesScreen: Due Date Submit: Starting API call, dueDateLoading set to true');
    });
    try {
      final url = dueDateMethod == 'menstrual'
          ? 'https://obaatanpa-backend.onrender.com/due_date/menstrual_cycle/calculate'
          : 'https://obaatanpa-backend.onrender.com/due_date/conception_date/calculate';
      final body = dueDateMethod == 'menstrual'
          ? {
              'last_period_date': lastPeriodDate,
              'cycle_length': int.parse(cycleLength),
            }
          : {
              'conception_date': conceptionDate,
            };
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      print('ResourcesScreen: Due Date Calculator Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      print('ResourcesScreen: Due Date Calculator Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          dueDateResult = jsonDecode(response.body);
          print('ResourcesScreen: Due Date Submit Success: dueDateResult=$dueDateResult');
        });
      } else {
        throw Exception('Failed to calculate due date: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        dueDateError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : 'Failed to calculate due date: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
        }
        print('ResourcesScreen: Due Date Calculator Error: $e, dueDateError set: $dueDateError');
      });
    } finally {
      setState(() {
        dueDateLoading = false;
        print('ResourcesScreen: Due Date Submit Completed: dueDateLoading set to false');
      });
    }
  }

  Future<void> _handleWeightRecommendation() async {
    print('ResourcesScreen: Weight Recommendation Submit Initiated');
    if (authToken == null) {
      setState(() {
        weightError = 'Please log in to use the Weight Recommendation tool.';
        print('ResourcesScreen: Weight Recommendation: User not authenticated, weightError set: $weightError');
      });
      return;
    }
    if (prePregnancyWeight.isEmpty || height.isEmpty || gestationalAge.isEmpty) {
      setState(() {
        weightError = 'Please provide pre-pregnancy weight, height, and gestational age.';
        print('ResourcesScreen: Weight Recommendation Validation Failed: prePregnancyWeight=$prePregnancyWeight, height=$height, gestationalAge=$gestationalAge, weightError set: $weightError');
      });
      return;
    }
    setState(() {
      weightLoading = true;
      weightError = null;
      print('ResourcesScreen: Weight Recommendation: Starting API call, weightLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/recommend/weight/';
      final body = {
        'pre_pregnancy_weight': double.parse(prePregnancyWeight),
        'height': double.parse(height),
        'gestational_age': int.parse(gestationalAge),
      };
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      print('ResourcesScreen: Weight Recommendation Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      print('ResourcesScreen: Weight Recommendation Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          weightResult = jsonDecode(response.body);
          print('ResourcesScreen: Weight Recommendation Success: weightResult=$weightResult');
        });
      } else {
        throw Exception('Failed to fetch weight recommendation: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        weightError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : 'Failed to fetch weight recommendation: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
        }
        print('ResourcesScreen: Weight Recommendation Error: $e, weightError set: $weightError');
      });
    } finally {
      setState(() {
        weightLoading = false;
        print('ResourcesScreen: Weight Recommendation Completed: weightLoading set to false');
      });
    }
  }

  void _clearAuthToken() async {
    await _storage.delete(key: 'auth_token');
    setState(() {
      authToken = null;
      errorMessage = 'Please log in to access features like calculators and product guides.';
      print('ResourcesScreen: Auth Token Cleared, errorMessage set: $errorMessage');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ResourcesScreen: Building ResourcesScreen');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                isMenuOpen: isMenuOpen,
                onMenuTap: _toggleMenu,
                title: 'Resources',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Tools & Calculators'),
                      const SizedBox(height: 12),
                      _buildToolsGrid(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Video Resources'),
                      const SizedBox(height: 12),
                      _buildYouTubeVideoResources(),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Emergency Contacts'),
                      const SizedBox(height: 12),
                      _buildEmergencyContacts(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isMenuOpen) _buildNavigationMenu(),
          if (showDueDateModal) _buildDueDateModal(),
          if (showWeightModal) _buildWeightModal(),
          if (showBabyProductsModal) _buildBabyProductsModal(),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    print('ResourcesScreen: Rendering Navigation Menu');
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
              height: 120,
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8BBD9),
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
                      onTap: () => _navigateToPage('/dashboard/pregnant-mother'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      isActive: true,
                      textColor: const Color(0xFFF8BBD9),
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
                      textColor: Colors.black87,
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

  Widget _buildSectionHeader(String title) {
    print('ResourcesScreen: Rendering Section Header: $title');
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildToolsGrid() {
    print('ResourcesScreen: Rendering Tools Grid');
    final tools = [
      {
        'id': 'due-date-calculator',
        'title': 'Due Date Calculator',
        'description': 'Calculate your estimated due date',
        'icon': Icons.calendar_today,
        'color': const Color(0xFF81C784),
        'available': true,
        'popular': true,
      },
      {
        'id': 'weight-recommendation',
        'title': 'Weight Recommendation',
        'description': 'Get personalized weight gain recommendations',
        'icon': Icons.fitness_center,
        'color': const Color(0xFF64B5F6),
        'available': true,
        'popular': true,
      },
      {
        'id': 'baby-registry',
        'title': 'Baby Registry',
        'description': 'Create your baby wish list',
        'icon': Icons.card_giftcard,
        'color': const Color(0xFFF8BBD9),
        'available': pregnancyWeek >= 20,
        'popular': false,
      },
      {
        'id': 'baby-products',
        'title': 'Baby Products Guide',
        'description': 'Trimester-safe products',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFFFFB74D),
        'available': true,
        'popular': false,
      },
      {
        'id': 'gender-predictor',
        'title': 'Chinese Gender Predictor',
        'description': 'Traditional gender prediction',
        'icon': Icons.child_care,
        'color': const Color(0xFFBA68C8),
        'available': pregnancyWeek >= 12,
        'popular': false,
      },
      {
        'id': 'ovulation-calculator',
        'title': 'Ovulation Calculator',
        'description': 'Track your fertile days',
        'icon': Icons.calculate,
        'color': const Color(0xFFE57373),
        'available': pregnancyWeek <= 4,
        'popular': false,
      },
      {
        'id': 'ivf-calculator',
        'title': 'IVF Due Date Calculator',
        'description': 'Special calculator for IVF',
        'icon': Icons.timer,
        'color': const Color(0xFF4DD0E1),
        'available': true,
        'popular': false,
      },
      {
        'id': 'feeding-tracker',
        'title': 'Baby Feeding Tracker',
        'description': 'Prepare for feeding schedule',
        'icon': Icons.local_drink,
        'color': const Color(0xFF80CBC4),
        'available': pregnancyWeek >= 28,
        'popular': false,
      },
    ].where((tool) => tool['available'] as bool).toList();

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            print('ResourcesScreen: Rendering Tool: ${tool['title']}');
            return GestureDetector(
              onTap: () {
                print('ResourcesScreen: Tool Tapped: ${tool['title']}, id=${tool['id']}');
                if (tool['id'] == 'due-date-calculator') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Due Date Calculator.';
                      print('ResourcesScreen: Due Date Calculator: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showDueDateModal = true;
                      print('ResourcesScreen: Opening Due Date Calculator Modal');
                    });
                  }
                } else if (tool['id'] == 'weight-recommendation') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Weight Recommendation tool.';
                      print('ResourcesScreen: Weight Recommendation: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showWeightModal = true;
                      print('ResourcesScreen: Opening Weight Recommendation Modal');
                    });
                  }
                } else if (tool['id'] == 'baby-products') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Baby Products Guide.';
                      print('ResourcesScreen: Baby Products Guide: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showBabyProductsModal = true;
                      print('ResourcesScreen: Opening Baby Products Guide Modal');
                    });
                    _fetchCategories();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${tool['title']} is not implemented yet.')),
                  );
                  print('ResourcesScreen: Tool Not Implemented: ${tool['title']}');
                }
              },
              child: Container(
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
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: (tool['color'] as Color).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            tool['icon'] as IconData,
                            color: tool['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tool['title'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tool['description'].toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    if (tool['popular'] as bool)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8BBD9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Popular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
        if (errorMessage != null && authToken == null)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              border: Border.all(color: Colors.yellow[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.yellow, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.yellow),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print('ResourcesScreen: Go to Login Button Pressed');
                    context.go('/login');
                  },
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(color: Color(0xFFF8BBD9)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildYouTubeVideoResources() {
    print('ResourcesScreen: Rendering YouTube Video Resources');
    final videos = [
      {
        'title': "A Dietitian's Guide To Eating During Each Trimester of Pregnancy",
        'duration': '15:20',
        'videoId': 'dq7ovxsAfX8',
        'channel': 'Healthy Pregnancy',
        'thumbnail': 'https://img.youtube.com/vi/dq7ovxsAfX8/maxresdefault.jpg',
        'category': 'Nutrition',
      },
      {
        'title': '10 minute PRENATAL YOGA for Beginners (Safe for ALL Trimesters)',
        'duration': '10:00',
        'videoId': '4NwQKXpWN_A',
        'channel': 'Prenatal Yoga',
        'thumbnail': 'https://img.youtube.com/vi/4NwQKXpWN_A/maxresdefault.jpg',
        'category': 'Exercise',
      },
      {
        'title': 'How to Breathe and Push During Labor | Lamaze',
        'duration': '8:30',
        'videoId': '0pNldTVh5B4',
        'channel': 'Bridget Teyler',
        'thumbnail': 'https://img.youtube.com/vi/0pNldTVh5B4/maxresdefault.jpg',
        'category': 'Childbirth',
      },
      {
        'title': 'Baby Care Essentials for New Parents',
        'duration': '12:15',
        'videoId': 'kDvkYvK3M2Q',
        'channel': 'Baby Care Guide',
        'thumbnail': 'https://img.youtube.com/vi/kDvkYvK3M2Q/maxresdefault.jpg',
        'category': 'Baby Care',
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          print('ResourcesScreen: Rendering Video: ${video['title']}');
          return GestureDetector(
            onTap: () => _launchYouTubeVideo(video['videoId'].toString()),
            child: Container(
              width: 280,
              margin: EdgeInsets.only(right: index < videos.length - 1 ? 16 : 0),
              decoration: BoxDecoration(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[100]!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Image.network(
                        video['thumbnail'].toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('ResourcesScreen: Video Thumbnail Error: ${video['title']}, error=$error');
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.video_library,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          print('ResourcesScreen: Video Thumbnail Loading: ${video['title']}');
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video['duration'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              video['title'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8BBD9).withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    video['category'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    video['channel'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildEmergencyContacts() {
    print('ResourcesScreen: Rendering Emergency Contacts');
    final contacts = [
      {
        'title': 'Emergency',
        'number': '911',
        'icon': Icons.emergency,
        'color': Colors.red,
      },
      {
        'title': 'Mental Health',
        'number': '+233 30 765 4321',
        'icon': Icons.psychology,
        'color': const Color(0xFF81C784),
      },
    ];

    return Column(
      children: contacts.map((contact) {
        print('ResourcesScreen: Rendering Contact: ${contact['title']}');
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                print('ResourcesScreen: Emergency Contact Tapped: ${contact['title']}, number=${contact['number']}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${contact['number']}...'),
                    backgroundColor: contact['color'] as Color,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (contact['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        contact['icon'] as IconData,
                        color: contact['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['title'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            contact['number'].toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (contact['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.call,
                        color: contact['color'] as Color,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDueDateModal() {
    print('ResourcesScreen: Rendering Due Date Modal, showDueDateModal=$showDueDateModal, dueDateMethod=$dueDateMethod');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Due Date Calculator',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    print('ResourcesScreen: Closing Due Date Modal');
                    setState(() {
                      showDueDateModal = false;
                      dueDateMethod = null;
                      dueDateResult = null;
                      dueDateError = null;
                      lastPeriodDate = '';
                      cycleLength = '28';
                      conceptionDate = '';
                      print('ResourcesScreen: Due Date Modal State Reset: showDueDateModal=$showDueDateModal, dueDateMethod=$dueDateMethod');
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (authToken == null) ...[
              const Text(
                'Please log in to use the Due Date Calculator.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print('ResourcesScreen: Due Date Modal: Log In Button Pressed');
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log In'),
              ),
            ] else if (dueDateMethod == null) ...[
              const Text('Choose a method to calculate your due date:'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dueDateMethod = 'menstrual';
                    print('ResourcesScreen: Due Date Method Selected: menstrual');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Last Menstrual Period'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dueDateMethod = 'conception';
                    print('ResourcesScreen: Due Date Method Selected: conception');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DA8E6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Conception Date'),
              ),
            ] else if (dueDateMethod == 'menstrual') ...[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Last Menstrual Period Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  print('ResourcesScreen: Opening Date Picker for Last Menstrual Period');
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      lastPeriodDate = date.toIso8601String().split('T')[0];
                      print('ResourcesScreen: Last Menstrual Period Date Selected: $lastPeriodDate');
                    });
                  } else {
                    print('ResourcesScreen: Last Menstrual Period Date Picker Cancelled');
                  }
                },
                readOnly: true,
                controller: TextEditingController(text: lastPeriodDate),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cycle Length (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    cycleLength = value;
                    print('ResourcesScreen: Cycle Length Updated: $cycleLength');
                  });
                },
                controller: TextEditingController(text: cycleLength),
              ),
              if (dueDateError != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(dueDateError!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              ],
              if (dueDateResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Due Date Results', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Due Date: ${dueDateResult!['due_date'] ?? 'Unknown'}'),
                      Text('Gestational Age: ${dueDateResult!['gestational_age'] ?? 'Unknown'}'),
                      Text('Trimester: ${dueDateResult!['trimester'] ?? 'Unknown'}'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: dueDateLoading || lastPeriodDate.isEmpty || cycleLength.isEmpty
                    ? null
                    : _handleDueDateSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: dueDateLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Calculate'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  print('ResourcesScreen: Due Date Modal: Back Button Pressed');
                  setState(() {
                    dueDateMethod = null;
                    dueDateResult = null;
                    dueDateError = null;
                    lastPeriodDate = '';
                    cycleLength = '28';
                    print('ResourcesScreen: Due Date Modal: Reset to method selection');
                  });
                },
                child: const Text('Back'),
              ),
            ] else ...[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Conception Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  print('ResourcesScreen: Opening Date Picker for Conception Date');
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      conceptionDate = date.toIso8601String().split('T')[0];
                      print('ResourcesScreen: Conception Date Selected: $conceptionDate');
                    });
                  } else {
                    print('ResourcesScreen: Conception Date Picker Cancelled');
                  }
                },
                readOnly: true,
                controller: TextEditingController(text: conceptionDate),
              ),
              if (dueDateError != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(dueDateError!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              ],
              if (dueDateResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Due Date Results', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Due Date: ${dueDateResult!['due_date'] ?? 'Unknown'}'),
                      Text('Gestational Age: ${dueDateResult!['gestational_age'] ?? 'Unknown'}'),
                      Text('Trimester: ${dueDateResult!['trimester'] ?? 'Unknown'}'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: dueDateLoading || conceptionDate.isEmpty ? null : _handleDueDateSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: dueDateLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Calculate'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  print('ResourcesScreen: Due Date Modal: Back Button Pressed');
                  setState(() {
                    dueDateMethod = null;
                    dueDateResult = null;
                    dueDateError = null;
                    conceptionDate = '';
                    print('ResourcesScreen: Due Date Modal: Reset to method selection');
                  });
                },
                child: const Text('Back'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeightModal() {
    print('ResourcesScreen: Rendering Weight Modal, showWeightModal=$showWeightModal');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weight Recommendation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    print('ResourcesScreen: Closing Weight Modal');
                    setState(() {
                      showWeightModal = false;
                      prePregnancyWeight = '';
                      height = '';
                      gestationalAge = '';
                      weightResult = null;
                      weightError = null;
                      print('ResourcesScreen: Weight Modal State Reset: showWeightModal=$showWeightModal');
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (authToken == null) ...[
              const Text(
                'Please log in to use the Weight Recommendation tool.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print('ResourcesScreen: Weight Modal: Log In Button Pressed');
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log In'),
              ),
            ] else ...[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Pre-Pregnancy Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    prePregnancyWeight = value;
                    print('ResourcesScreen: Pre-Pregnancy Weight Updated: $prePregnancyWeight');
                  });
                },
                controller: TextEditingController(text: prePregnancyWeight),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Height (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    height = value;
                    print('ResourcesScreen: Height Updated: $height');
                  });
                },
                controller: TextEditingController(text: height),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Gestational Age (weeks)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    gestationalAge = value;
                    print('ResourcesScreen: Gestational Age Updated: $gestationalAge');
                  });
                },
                controller: TextEditingController(text: gestationalAge),
              ),
              if (weightError != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(weightError!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              ],
              if (weightResult != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Weight Recommendation', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Type: ${weightResult!['recommendation_type'] ?? 'Unknown'}'),
                      Text('Recommended Weight Change: ${weightResult!['recommended_weight_change'] ?? 'Unknown'}'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: weightLoading || prePregnancyWeight.isEmpty || height.isEmpty || gestationalAge.isEmpty
                          ? null
                          : _handleWeightRecommendation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8BBD9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: weightLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Calculate'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        print('ResourcesScreen: Weight Modal: Cancel Button Pressed');
                        setState(() {
                          showWeightModal = false;
                          prePregnancyWeight = '';
                          height = '';
                          gestationalAge = '';
                          weightResult = null;
                          weightError = null;
                          print('ResourcesScreen: Weight Modal State Reset: showWeightModal=$showWeightModal');
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBabyProductsModal() {
    print('ResourcesScreen: Rendering Baby Products Modal, showBabyProductsModal=$showBabyProductsModal, selectedCategory=$selectedCategory, categoryItems.length=${categoryItems.length}');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Baby Products Guide',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      print('ResourcesScreen: Closing Baby Products Modal');
                      setState(() {
                        showBabyProductsModal = false;
                        categories = [];
                        selectedCategory = null;
                        categoryItems = [];
                        productsError = null;
                        print('ResourcesScreen: Baby Products Modal State Reset: showBabyProductsModal=$showBabyProductsModal');
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (authToken == null) ...[
                const Text(
                  'Please log in to use the Baby Products Guide.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    print('ResourcesScreen: Baby Products Modal: Log In Button Pressed');
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8BBD9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Log In'),
                ),
              ] else ...[
                if (productsError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(productsError!, style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (productsLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 16),
                  const Center(child: Text('Loading...')),
                ] else ...[
                  const Text(
                    'Product Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final categoryName = category['name'] as String? ?? 'Unknown Category';
                      final categoryDescription = category['description'] as String? ?? 'No description available';
                      print('ResourcesScreen: Rendering Category: ID=${category['id']}, Name=$categoryName, Description=$categoryDescription');
                      return GestureDetector(
                        onTap: () {
                          if (category['id'] != null) {
                            setState(() {
                              selectedCategory = category['id'];
                              print('ResourcesScreen: Category Clicked: ID=${category['id']}, Name=$categoryName');
                            });
                            _fetchCategoryItems(category['id'] as int);
                          } else {
                            print('ResourcesScreen: Category Click Ignored: Missing ID for category $categoryName');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid category selected')),
                            );
                          }
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedCategory == category['id'] ? const Color(0xFFF8BBD9) : Colors.grey[200]!,
                              width: selectedCategory == category['id'] ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedCategory == category['id'] ? const Color(0xFFF8BBD9) : Colors.black,
                                ),
                              ),
                              Text(
                                categoryDescription,
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (categories.isEmpty)
                    const Text(
                      'No categories available.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  if (selectedCategory != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Items in ${categories.firstWhere((cat) => cat['id'] == selectedCategory, orElse: () => {'name': 'Unknown Category'})['name'] as String? ?? 'Unknown Category'}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300, // Explicit height for items list
                      child: categoryItems.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: categoryItems.length,
                              itemBuilder: (context, index) {
                                final item = categoryItems[index];
                                final itemName = item['name'] as String? ?? 'Unknown Item';
                                final itemQuantity = item['quantity']?.toString() ?? 'N/A';
                                final itemNotes = item['notes'] as String? ?? 'No notes';
                                print('ResourcesScreen: Building Item Widget: Name=$itemName, Quantity=$itemQuantity, Notes=$itemNotes');
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemName,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('Quantity: $itemQuantity'),
                                      if (itemNotes.isNotEmpty && itemNotes != 'No notes')
                                        Text(
                                          'Notes: $itemNotes',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Text(
                              productsError ?? 'No items available for this category.',
                              style: const TextStyle(color: Colors.grey),
                            ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print('ResourcesScreen: Baby Products Modal: Close Button Pressed');
                      setState(() {
                        showBabyProductsModal = false;
                        categories = [];
                        selectedCategory = null;
                        categoryItems = [];
                        productsError = null;
                        print('ResourcesScreen: Baby Products Modal State Reset: showBabyProductsModal=$showBabyProductsModal');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}