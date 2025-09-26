import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class NewMotherResourcesPage extends StatefulWidget {
  const NewMotherResourcesPage({super.key});

  @override
  State<NewMotherResourcesPage> createState() => _NewMotherResourcesPageState();
}

class _NewMotherResourcesPageState extends State<NewMotherResourcesPage> {
  bool _isMenuOpen = false;
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
  // Symptom Tracker
  bool showSymptomModal = false;
  String symptomsInput = '';
  Map<String, dynamic>? analysisResult;
  String? symptomError;
  bool symptomLoading = false;
  List<dynamic> journalEntries = [];
  bool showPastEntries = false;
  Set<int> expandedEntries = {};

  // Journal
  bool showJournalModal = false;
  String journalEntry = '';
  String? journalError;
  bool journalLoading = false;

  // Chatbot
  bool showChatbotModal = false;
  String chatbotQuestion = '';
  Map<String, dynamic>? chatbotResponse;
  String? chatbotError;
  bool chatbotLoading = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

@override
  void initState() {
    super.initState();
    print('NewMotherResourcesPage: Initializing NewMotherResourcesPage');
    _loadAuthToken().then((_) {
      if (authToken != null) {
        _fetchJournalEntries();
        _fetchSymptomEntries();
      }
    });
  }

  Future<void> _loadAuthToken() async {
    print('NewMotherResourcesPage: Loading auth token');
    final token = await _storage.read(key: 'auth_token');
    setState(() {
      authToken = token;
      if (authToken == null) {
        errorMessage = 'Please log in to access features like calculators and product guides.';
        print('NewMotherResourcesPage: No auth token found, errorMessage set: $errorMessage');
      } else {
        print('NewMotherResourcesPage: Auth token loaded successfully');
      }
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      print('NewMotherResourcesPage: Navigation menu toggled: isMenuOpen=$_isMenuOpen');
    });
  }

  void _navigateToPage(String routeName) {
    print('NewMotherResourcesPage: Navigating to route: $routeName');
    _toggleMenu();
    if (routeName != '/new-mother/resources') {
      context.go(routeName);
    } else {
      print('NewMotherResourcesPage: Navigation ignored: Already on /new-mother/resources');
    }
  }

  Future<void> _launchYouTubeVideo(String videoId) async {
    print('NewMotherResourcesPage: Launching YouTube video: videoId=$videoId');
    final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final youtubeAppUrl = Uri.parse('youtube://www.youtube.com/watch?v=$videoId');

    try {
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl);
        print('NewMotherResourcesPage: Opened YouTube video in app: $youtubeAppUrl');
      } else {
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
        print('NewMotherResourcesPage: Opened YouTube video in browser: $youtubeUrl');
      }
    } catch (e) {
      print('NewMotherResourcesPage: Error launching YouTube video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open video')),
      );
    }
  }

  Future<void> _fetchCategories() async {
    if (authToken == null) {
      setState(() {
        productsError = 'Please log in to view baby products.';
        print('NewMotherResourcesPage: Fetch Categories: User not authenticated, productsError set: $productsError');
      });
      return;
    }
    setState(() {
      productsLoading = true;
      productsError = null;
      print('NewMotherResourcesPage: Starting fetch categories, productsLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/baby_products/categories';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('NewMotherResourcesPage: Fetch Categories Request: URL=$url, Headers=$headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('NewMotherResourcesPage: Fetch Categories Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('NewMotherResourcesPage: Fetch Categories Parsed Data: $data');
        setState(() {
          categories = data['categories'] ?? [];
          if (categories.isEmpty) {
            productsError = 'No categories available.';
            print('NewMotherResourcesPage: No categories found, productsError set: $productsError');
          } else {
            print('NewMotherResourcesPage: Categories loaded: ${categories.length} categories');
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
        print('NewMotherResourcesPage: Fetch Categories Error: $e, productsError set: $productsError');
      });
    } finally {
      setState(() {
        productsLoading = false;
        print('NewMotherResourcesPage: Fetch categories completed, productsLoading set to false');
      });
    }
  }

  Future<void> _fetchCategoryItems(int categoryId) async {
    if (authToken == null) {
      setState(() {
        productsError = 'Please log in to view baby products.';
        print('NewMotherResourcesPage: Fetch Category Items: User not authenticated, productsError set: $productsError');
      });
      return;
    }
    setState(() {
      productsLoading = true;
      productsError = null;
      print('NewMotherResourcesPage: Starting fetch category items for categoryId=$categoryId, productsLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/baby_products/categories/items/$categoryId';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('NewMotherResourcesPage: Fetch Category Items Request: URL=$url, Headers=$headers');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('NewMotherResourcesPage: Fetch Category Items Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('NewMotherResourcesPage: Fetch Category Items Parsed Data: $data');
        final category = categories.firstWhere(
          (cat) => cat['id'] == categoryId,
          orElse: () => null,
        );
        if (category == null) {
          throw Exception('Category with ID $categoryId not found');
        }
        final categoryName = category['name'] as String? ?? 'Unknown';
        print('NewMotherResourcesPage: Processing items for category: $categoryName');
        setState(() {
          print('NewMotherResourcesPage: Checking data structure: has items=${data.containsKey('items')}');
          if (data.containsKey('items')) {
            print('NewMotherResourcesPage: Items array length=${data['items'].length}');
            if (data['items'].isNotEmpty) {
              print('NewMotherResourcesPage: Checking categoryName in first item: ${data['items'][0].containsKey(categoryName)}');
              if (data['items'][0].containsKey(categoryName)) {
                print('NewMotherResourcesPage: Category array length=${data['items'][0][categoryName].length}');
                if (data['items'][0][categoryName].isNotEmpty && data['items'][0][categoryName][0].containsKey('items')) {
                  categoryItems = data['items'][0][categoryName][0]['items'] ?? [];
                  print('NewMotherResourcesPage: Category items assigned: ${categoryItems.length} items');
                } else {
                  categoryItems = [];
                  productsError = 'No items found in category structure.';
                  print('NewMotherResourcesPage: No items in category structure, productsError set: $productsError');
                }
              } else {
                categoryItems = [];
                productsError = 'Category $categoryName not found in response.';
                print('NewMotherResourcesPage: Category not in response, productsError set: $productsError');
              }
            } else {
              categoryItems = [];
              productsError = 'Items array is empty.';
              print('NewMotherResourcesPage: Items array empty, productsError set: $productsError');
            }
          } else {
            categoryItems = [];
            productsError = 'No items key in response.';
            print('NewMotherResourcesPage: No items key, productsError set: $productsError');
          }
          if (categoryItems.isEmpty && productsError == null) {
            productsError = 'No items available for this category.';
            print('NewMotherResourcesPage: No items found for categoryId=$categoryId, productsError set: $productsError');
          } else if (categoryItems.isNotEmpty) {
            print('NewMotherResourcesPage: Category items loaded: ${categoryItems.length} items for categoryId=$categoryId');
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
        print('NewMotherResourcesPage: Fetch Category Items Error: $e, productsError set: $productsError');
      });
    } finally {
      setState(() {
        productsLoading = false;
        print('NewMotherResourcesPage: Fetch category items completed, productsLoading set to false');
      });
    }
  }

  Future<void> _handleDueDateSubmit() async {
    print('NewMotherResourcesPage: Due Date Calculator Submit Initiated, dueDateMethod=$dueDateMethod');
    if (authToken == null) {
      setState(() {
        dueDateError = 'Please log in to use the Due Date Calculator.';
        print('NewMotherResourcesPage: Due Date Submit: User not authenticated, dueDateError set: $dueDateError');
      });
      return;
    }
    if (dueDateMethod == 'menstrual' && (lastPeriodDate.isEmpty || cycleLength.isEmpty)) {
      setState(() {
        dueDateError = 'Please provide both last period date and cycle length.';
        print('NewMotherResourcesPage: Due Date Submit Validation Failed: lastPeriodDate=$lastPeriodDate, cycleLength=$cycleLength, dueDateError set: $dueDateError');
      });
      return;
    }
    if (dueDateMethod == 'conception' && conceptionDate.isEmpty) {
      setState(() {
        dueDateError = 'Please provide the conception date.';
        print('NewMotherResourcesPage: Due Date Submit Validation Failed: conceptionDate=$conceptionDate, dueDateError set: $dueDateError');
      });
      return;
    }
    setState(() {
      dueDateLoading = true;
      dueDateError = null;
      print('NewMotherResourcesPage: Due Date Submit: Starting API call, dueDateLoading set to true');
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
      print('NewMotherResourcesPage: Due Date Calculator Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      print('NewMotherResourcesPage: Due Date Calculator Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          dueDateResult = jsonDecode(response.body);
          print('NewMotherResourcesPage: Due Date Submit Success: dueDateResult=$dueDateResult');
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
        print('NewMotherResourcesPage: Due Date Calculator Error: $e, dueDateError set: $dueDateError');
      });
    } finally {
      setState(() {
        dueDateLoading = false;
        print('NewMotherResourcesPage: Due Date Submit Completed: dueDateLoading set to false');
      });
    }
  }

  Future<void> _handleWeightRecommendation() async {
    print('NewMotherResourcesPage: Weight Recommendation Submit Initiated');
    if (authToken == null) {
      setState(() {
        weightError = 'Please log in to use the Weight Recommendation tool.';
        print('NewMotherResourcesPage: Weight Recommendation: User not authenticated, weightError set: $weightError');
      });
      return;
    }
    if (prePregnancyWeight.isEmpty || height.isEmpty || gestationalAge.isEmpty) {
      setState(() {
        weightError = 'Please provide pre-pregnancy weight, height, and gestational age.';
        print('NewMotherResourcesPage: Weight Recommendation Validation Failed: prePregnancyWeight=$prePregnancyWeight, height=$height, gestationalAge=$gestationalAge, weightError set: $weightError');
      });
      return;
    }
    setState(() {
      weightLoading = true;
      weightError = null;
      print('NewMotherResourcesPage: Weight Recommendation: Starting API call, weightLoading set to true');
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
      print('NewMotherResourcesPage: Weight Recommendation Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      print('NewMotherResourcesPage: Weight Recommendation Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          weightResult = jsonDecode(response.body);
          print('NewMotherResourcesPage: Weight Recommendation Success: weightResult=$weightResult');
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
        print('NewMotherResourcesPage: Weight Recommendation Error: $e, weightError set: $weightError');
      });
    } finally {
      setState(() {
        weightLoading = false;
        print('NewMotherResourcesPage: Weight Recommendation Completed: weightLoading set to false');
      });
    }
  }

  void _clearAuthToken() async {
    await _storage.delete(key: 'auth_token');
    setState(() {
      authToken = null;
      errorMessage = 'Please log in to access features like calculators and product guides.';
      print('NewMotherResourcesPage: Auth Token Cleared, errorMessage set: $errorMessage');
    });
  }

  Future<void> _fetchSymptomEntries() async {
    print('NewMotherResourcesPage: Fetch Symptom Entries Initiated');
    if (authToken == null) {
      setState(() {
        symptomError = 'Please log in to view symptom entries.';
        print('NewMotherResourcesPage: Fetch Symptom Entries: User not authenticated, symptomError set: $symptomError');
      });
      return;
    }
    setState(() {
      journalLoading = true;
      symptomError = null;
      print('NewMotherResourcesPage: Starting fetch symptom entries, journalLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/symptom_tracker';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('NewMotherResourcesPage: Fetch Symptom Entries Request: URL=$url, Headers=$headers');
      final response = await http.get(Uri.parse(url), headers: headers);
      print('NewMotherResourcesPage: Fetch Symptom Entries Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('NewMotherResourcesPage: Fetch Symptom Entries Parsed Data: $data');
        setState(() {
          final symptomEntries = data['symptom_entries'] ?? [];
          final existingEntries = journalEntries.where((entry) => entry['type'] != 'symptom').toList();
          journalEntries = [...symptomEntries.map((e) => {...e, 'type': 'symptom'}), ...existingEntries];
          if (journalEntries.isEmpty) {
            symptomError = 'No symptom entries found.';
            print('NewMotherResourcesPage: No symptom entries, symptomError set: $symptomError');
          } else {
            print('NewMotherResourcesPage: Symptom entries loaded: ${journalEntries.length} entries');
          }
        });
      } else {
        throw Exception('Failed to fetch symptom entries: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        symptomError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : e.toString().contains('404')
                ? 'No symptom entries found.'
                : 'Failed to fetch symptom entries: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
          context.go('/login');
        }
        print('NewMotherResourcesPage: Fetch Symptom Entries Error: $e, symptomError set: $symptomError');
      });
    } finally {
      setState(() {
        journalLoading = false;
        print('NewMotherResourcesPage: Fetch symptom entries completed, journalLoading set to false');
      });
    }
  }

  Future<void> _handleSymptomSubmit() async {
    print('NewMotherResourcesPage: Symptom Tracker Submit Initiated');
    if (authToken == null) {
      setState(() {
        symptomError = 'Please log in to submit symptoms.';
        print('NewMotherResourcesPage: Symptom Submit: User not authenticated, symptomError set: $symptomError');
      });
      return;
    }
    if (symptomsInput.trim().isEmpty) {
      setState(() {
        symptomError = 'Please provide valid symptoms.';
        print('NewMotherResourcesPage: Symptom Submit Validation Failed: symptomsInput=$symptomsInput, symptomError set: $symptomError');
      });
      return;
    }
    setState(() {
      symptomLoading = true;
      symptomError = null;
      print('NewMotherResourcesPage: Symptom Submit: Starting API call, symptomLoading set to true');
    });
    try {
      final symptoms = symptomsInput.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      final url = 'https://obaatanpa-backend.onrender.com/symptom_tracker';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'symptoms': symptoms});
      print('NewMotherResourcesPage: Symptom Tracker Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('NewMotherResourcesPage: Symptom Tracker Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          analysisResult = jsonDecode(response.body)['symptoms'];
          symptomsInput = '';
          showSymptomModal = false;
          print('NewMotherResourcesPage: Symptom Submit Success: analysisResult=$analysisResult');
          _fetchSymptomEntries();
        });
      } else {
        throw Exception('Failed to submit symptoms: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        symptomError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : e.toString().contains('400')
                ? 'Please provide valid symptoms.'
                : 'Failed to submit symptoms: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
          context.go('/login');
        }
        print('NewMotherResourcesPage: Symptom Tracker Error: $e, symptomError set: $symptomError');
      });
    } finally {
      setState(() {
        symptomLoading = false;
        print('NewMotherResourcesPage: Symptom Submit Completed: symptomLoading set to false');
      });
    }
  }

  Future<void> _handleDeleteEntry(int entryId) async {
    print('NewMotherResourcesPage: Delete Entry Initiated: entryId=$entryId');
    if (authToken == null) {
      setState(() {
        journalError = 'Please log in to delete entries.';
        print('NewMotherResourcesPage: Delete Entry: User not authenticated, journalError set: $journalError');
      });
      return;
    }
    setState(() {
      journalLoading = true;
      journalError = null;
      print('NewMotherResourcesPage: Delete Entry: Starting API call, journalLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/journal/$entryId';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('NewMotherResourcesPage: Delete Entry Request: URL=$url, Headers=$headers');
      final response = await http.delete(Uri.parse(url), headers: headers);
      print('NewMotherResourcesPage: Delete Entry Response: Status=${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          journalEntries.removeWhere((entry) => entry['id'] == entryId);
          expandedEntries.remove(entryId);
          print('NewMotherResourcesPage: Delete Entry Success: entryId=$entryId removed');
        });
      } else {
        throw Exception('Failed to delete entry: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        journalError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : e.toString().contains('404')
                ? 'Entry not found.'
                : 'Failed to delete entry: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
          context.go('/login');
        }
        print('NewMotherResourcesPage: Delete Entry Error: $e, journalError set: $journalError');
      });
    } finally {
      setState(() {
        journalLoading = false;
        print('NewMotherResourcesPage: Delete Entry Completed: journalLoading set to false');
      });
    }
  }

  Future<void> _fetchJournalEntries() async {
    print('NewMotherResourcesPage: Fetch Journal Entries Initiated');
    if (authToken == null) {
      setState(() {
        journalError = 'Please log in to view journal entries.';
        print('NewMotherResourcesPage: Fetch Journal Entries: User not authenticated, journalError set: $journalError');
      });
      return;
    }
    setState(() {
      journalLoading = true;
      journalError = null;
      print('NewMotherResourcesPage: Starting fetch journal entries, journalLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/journal';
      final headers = {'Authorization': 'Bearer $authToken'};
      print('NewMotherResourcesPage: Fetch Journal Entries Request: URL=$url, Headers=$headers');
      final response = await http.get(Uri.parse(url), headers: headers);
      print('NewMotherResourcesPage: Fetch Journal Entries Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('NewMotherResourcesPage: Fetch Journal Entries Parsed Data: $data');
        setState(() {
          final newEntries = data['journal_entries']?.map((e) => {...e, 'type': 'journal'})?.toList() ?? [];
          final existingSymptomEntries = journalEntries.where((entry) => entry['type'] == 'symptom').toList();
          journalEntries = [...newEntries, ...existingSymptomEntries];
          if (journalEntries.isEmpty) {
            journalError = 'No journal entries found.';
            print('NewMotherResourcesPage: No journal entries, journalError set: $journalError');
          } else {
            print('NewMotherResourcesPage: Journal entries loaded: ${journalEntries.length} entries');
          }
        });
      } else {
        throw Exception('Failed to fetch journal entries: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        journalError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : e.toString().contains('404')
                ? 'No journal entries found.'
                : 'Failed to fetch journal entries: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
          context.go('/login');
        }
        print('NewMotherResourcesPage: Fetch Journal Entries Error: $e, journalError set: $journalError');
      });
    } finally {
      setState(() {
        journalLoading = false;
        print('NewMotherResourcesPage: Fetch journal entries completed, journalLoading set to false');
      });
    }
  }

  Future<void> _handleJournalSubmit() async {
    print('NewMotherResourcesPage: Journal Submit Initiated');
    if (authToken == null) {
      setState(() {
        journalError = 'Please log in to submit journal entries.';
        print('NewMotherResourcesPage: Journal Submit: User not authenticated, journalError set: $journalError');
      });
      return;
    }
    if (journalEntry.trim().isEmpty) {
      setState(() {
        journalError = 'Please provide a valid journal entry.';
        print('NewMotherResourcesPage: Journal Submit Validation Failed: journalEntry=$journalEntry, journalError set: $journalError');
      });
      return;
    }
    setState(() {
      journalLoading = true;
      journalError = null;
      print('NewMotherResourcesPage: Journal Submit: Starting API call, journalLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/journal';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'entry': journalEntry});
      print('NewMotherResourcesPage: Journal Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('NewMotherResourcesPage: Journal Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          final newEntry = {...jsonDecode(response.body), 'type': 'journal'};
          journalEntries.insert(0, newEntry);
          journalEntry = '';
          showJournalModal = false;
          print('NewMotherResourcesPage: Journal Submit Success: newEntry=$newEntry');
        });
      } else {
        throw Exception('Failed to submit journal entry: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        journalError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : e.toString().contains('400')
                ? 'Please provide a valid journal entry.'
                : 'Failed to submit journal entry: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
          context.go('/login');
        }
        print('NewMotherResourcesPage: Journal Submit Error: $e, journalError set: $journalError');
      });
    } finally {
      setState(() {
        journalLoading = false;
        print('NewMotherResourcesPage: Journal Submit Completed: journalLoading set to false');
      });
    }
  }

  Future<void> _handleChatbotSubmit() async {
    print('NewMotherResourcesPage: Chatbot Submit Initiated');
    if (authToken == null) {
      setState(() {
        chatbotError = 'Please log in to use the Pregnancy Assistant.';
        print('NewMotherResourcesPage: Chatbot Submit: User not authenticated, chatbotError set: $chatbotError');
      });
      return;
    }
    if (chatbotQuestion.trim().isEmpty) {
      setState(() {
        chatbotError = 'Please provide a valid question.';
        print('NewMotherResourcesPage: Chatbot Submit Validation Failed: chatbotQuestion=$chatbotQuestion, chatbotError set: $chatbotError');
      });
      return;
    }
    setState(() {
      chatbotLoading = true;
      chatbotError = null;
      print('NewMotherResourcesPage: Chatbot Submit: Starting API call, chatbotLoading set to true');
    });
    try {
      final url = 'https://obaatanpa-backend.onrender.com/chatbot';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'message': chatbotQuestion});
      print('NewMotherResourcesPage: Chatbot Request: URL=$url, Headers=$headers, Body=$body');
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      print('NewMotherResourcesPage: Chatbot Response: Status=${response.statusCode}, Body=${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response']?['message'] != null) {
          setState(() {
            chatbotResponse = {
              'message': data['response']['message'],
              'recommendations': [],
              'warnings': [],
              'followUp': [],
            };
            chatbotQuestion = '';
            print('NewMotherResourcesPage: Chatbot Submit Success: chatbotResponse=$chatbotResponse');
          });
        } else {
          throw Exception('Invalid response structure from server');
        }
      } else {
        throw Exception('Failed to get chatbot response: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        chatbotError = e.toString().contains('401')
            ? 'Your session has expired. Please log in again.'
            : e.toString().contains('400')
                ? 'Please provide a valid question.'
                : 'Failed to get response: ${e.toString()}';
        if (e.toString().contains('401')) {
          _clearAuthToken();
          context.go('/login');
        }
        print('NewMotherResourcesPage: Chatbot Submit Error: $e, chatbotError set: $chatbotError');
      });
    } finally {
      setState(() {
        chatbotLoading = false;
        print('NewMotherResourcesPage: Chatbot Submit Completed: chatbotLoading set to false');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('NewMotherResourcesPage: Building NewMotherResourcesPage');
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
                title: 'Resources',
              ),
              // Resources Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Header
                      const Text(
                        'Postpartum Resources',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Essential guides and support for your journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tools & Calculators
                      _buildSectionHeader('Tools & Calculators'),
                      const SizedBox(height: 12),
                      _buildToolsGrid(),
                      const SizedBox(height: 32),
                      // Resource Categories
                      _buildSectionHeader('Resource Categories'),
                      const SizedBox(height: 12),
                      _buildResourceCard(
                        'Recovery Guide',
                        'Comprehensive postpartum recovery information',
                        Icons.healing,
                        const Color(0xFF7DA8E6),
                        () => context.go('/new-mother/resources/recovery'),
                      ),
                      const SizedBox(height: 16),
                      _buildResourceCard(
                        'Baby Care',
                        'Essential baby care tips and guidelines',
                        Icons.child_care,
                        const Color(0xFFFFB6C1),
                        () => context.go('/new-mother/resources/baby-care'),
                      ),
                      const SizedBox(height: 16),
                      _buildResourceCard(
                        'Breastfeeding Support',
                        'Feeding guides, tips, and troubleshooting',
                        Icons.child_friendly,
                        const Color(0xFF4CAF50),
                        () => context.go('/new-mother/resources/breastfeeding'),
                      ),
                      const SizedBox(height: 16),
                      _buildResourceCard(
                        'Mental Health',
                        'Emotional wellness and support resources',
                        Icons.psychology,
                        const Color(0xFF9C27B0),
                        () => context.go('/new-mother/resources/mental-health'),
                      ),
                      const SizedBox(height: 32),
                      // Video Resources
                      _buildSectionHeader('Video Resources'),
                      const SizedBox(height: 12),
                      _buildYouTubeVideoResources(),
                      const SizedBox(height: 32),
                      // Educational Articles
                      _buildEducationalSection(),
                      const SizedBox(height: 32),
                      // Support Groups
                      _buildSupportGroupsSection(),
                      const SizedBox(height: 32),
                      // Emergency Contacts
                      _buildEmergencyContactsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Side Navigation Menu
          if (_isMenuOpen) _buildNavigationMenu(),
          // Modals
          if (showDueDateModal) _buildDueDateModal(),
          if (showWeightModal) _buildWeightModal(),
          if (showBabyProductsModal) _buildBabyProductsModal(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    print('NewMotherResourcesPage: Rendering Section Header: $title');
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildResourceCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
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

Widget _buildToolsGrid() {
    print('NewMotherResourcesPage: Rendering Tools Grid');
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
        'id': 'baby-products',
        'title': 'Baby Products Guide',
        'description': 'Postpartum-safe products',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFFFFB74D),
        'available': true,
        'popular': false,
      },
      {
        'id': 'symptom-tracker',
        'title': 'Symptom Tracker',
        'description': 'Log and analyze pregnancy symptoms',
        'icon': Icons.health_and_safety,
        'color': const Color(0xFFF06292),
        'available': true,
        'popular': true,
      },
      {
        'id': 'journal',
        'title': 'Journal',
        'description': 'Document your pregnancy journey',
        'icon': Icons.book,
        'color': const Color(0xFFAB47BC),
        'available': true,
        'popular': false,
      },
      {
        'id': 'chatbot',
        'title': 'Pregnancy Assistant',
        'description': 'Ask questions about your pregnancy',
        'icon': Icons.chat_bubble,
        'color': const Color(0xFF26A69A),
        'available': true,
        'popular': true,
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
            print('NewMotherResourcesPage: Rendering Tool: ${tool['title']}');
            return GestureDetector(
              onTap: () {
                print('NewMotherResourcesPage: Tool Tapped: ${tool['title']}, id=${tool['id']}');
                if (tool['id'] == 'due-date-calculator') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Due Date Calculator.';
                      print('NewMotherResourcesPage: Due Date Calculator: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showDueDateModal = true;
                      print('NewMotherResourcesPage: Opening Due Date Calculator Modal');
                    });
                  }
                } else if (tool['id'] == 'weight-recommendation') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Weight Recommendation tool.';
                      print('NewMotherResourcesPage: Weight Recommendation: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showWeightModal = true;
                      print('NewMotherResourcesPage: Opening Weight Recommendation Modal');
                    });
                  }
                } else if (tool['id'] == 'baby-products') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Baby Products Guide.';
                      print('NewMotherResourcesPage: Baby Products Guide: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showBabyProductsModal = true;
                      print('NewMotherResourcesPage: Opening Baby Products Guide Modal');
                    });
                    _fetchCategories();
                  }
                } else if (tool['id'] == 'symptom-tracker') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Symptom Tracker.';
                      print('NewMotherResourcesPage: Symptom Tracker: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showSymptomModal = true;
                      print('NewMotherResourcesPage: Opening Symptom Tracker Modal');
                    });
                    _fetchSymptomEntries();
                  }
                } else if (tool['id'] == 'journal') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Journal.';
                      print('NewMotherResourcesPage: Journal: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showJournalModal = true;
                      print('NewMotherResourcesPage: Opening Journal Modal');
                    });
                    _fetchJournalEntries();
                  }
                } else if (tool['id'] == 'chatbot') {
                  if (authToken == null) {
                    setState(() {
                      errorMessage = 'Please log in to use the Pregnancy Assistant.';
                      print('NewMotherResourcesPage: Chatbot: User not authenticated, errorMessage set: $errorMessage');
                    });
                  } else {
                    setState(() {
                      showChatbotModal = true;
                      print('NewMotherResourcesPage: Opening Chatbot Modal');
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${tool['title']} is not implemented yet.')),
                  );
                  print('NewMotherResourcesPage: Tool Not Implemented: ${tool['title']}');
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
                            color: const Color(0xFF7DA8E6),
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
                    print('NewMotherResourcesPage: Go to Login Button Pressed');
                    context.go('/login');
                  },
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(color: Color(0xFF7DA8E6)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildYouTubeVideoResources() {
    print('NewMotherResourcesPage: Rendering YouTube Video Resources');
    final videos = [
      {
        'title': 'Postpartum Recovery Tips for New Moms',
        'duration': '10:45',
        'videoId': 'X9Y2B0n4Z2A',
        'channel': 'New Mom Guide',
        'thumbnail': 'https://img.youtube.com/vi/X9Y2B0n4Z2A/maxresdefault.jpg',
        'category': 'Recovery',
      },
      {
        'title': 'Breastfeeding Basics for Beginners',
        'duration': '12:30',
        'videoId': 'Y5K3C7B8P1Q',
        'channel': 'Lactation Support',
        'thumbnail': 'https://img.youtube.com/vi/Y5K3C7B8P1Q/maxresdefault.jpg',
        'category': 'Breastfeeding',
      },
      {
        'title': 'Caring for Your Newborn: The First Month',
        'duration': '15:00',
        'videoId': 'M2P9D4F6N8R',
        'channel': 'Baby Care Basics',
        'thumbnail': 'https://img.youtube.com/vi/M2P9D4F6N8R/maxresdefault.jpg',
        'category': 'Baby Care',
      },
      {
        'title': 'Postpartum Mental Health: Coping Strategies',
        'duration': '9:20',
        'videoId': 'Q7W1K9L3T5Y',
        'channel': 'Mental Wellness',
        'thumbnail': 'https://img.youtube.com/vi/Q7W1K9L3T5Y/maxresdefault.jpg',
        'category': 'Mental Health',
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          print('NewMotherResourcesPage: Rendering Video: ${video['title']}');
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
                          print('NewMotherResourcesPage: Video Thumbnail Error: ${video['title']}, error=$error');
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
                          print('NewMotherResourcesPage: Video Thumbnail Loading: ${video['title']}');
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
                                    color: const Color(0xFF7DA8E6).withOpacity(0.8),
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

  Widget _buildEducationalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Educational Articles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          'Understanding Baby\'s Sleep Patterns',
          'Learn about newborn sleep cycles',
          'Dr. Sarah Johnson',
          '5 min read',
        ),
        _buildArticleCard(
          'Postpartum Depression: Signs & Support',
          'Recognizing and addressing mental health',
          'Dr. Emily Chen',
          '8 min read',
        ),
        _buildArticleCard(
          'Establishing Breastfeeding Success',
          'Tips for a successful feeding journey',
          'Lactation Consultant Mary',
          '6 min read',
        ),
      ],
    );
  }

  Widget _buildArticleCard(String title, String subtitle, String author, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: const Color(0xFF7DA8E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.article, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$author • $duration',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support Groups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildSupportGroupCard(
          'New Mom Circle',
          'Weekly virtual meetings for new mothers',
          'Tuesdays, 7:00 PM',
          Icons.group,
        ),
        _buildSupportGroupCard(
          'Breastfeeding Support',
          'Get help with breastfeeding challenges',
          'Daily online chat',
          Icons.chat,
        ),
        _buildSupportGroupCard(
          'Postpartum Wellness',
          'Focus on mental and physical recovery',
          'Thursdays, 6:00 PM',
          Icons.favorite,
        ),
      ],
    );
  }

  Widget _buildSupportGroupCard(String name, String description, String schedule, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
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
                const SizedBox(height: 4),
                Text(
                  schedule,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              print('NewMotherResourcesPage: Join Support Group: $name');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Joining $name...')),
              );
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsSection() {
    print('NewMotherResourcesPage: Rendering Emergency Contacts');
    final contacts = [
      {
        'title': 'Emergency Services',
        'number': '911',
        'icon': Icons.emergency,
        'color': Colors.red,
      },
      {
        'title': 'Postpartum Crisis Line',
        'number': '+1-800-PPD-MOMS',
        'icon': Icons.psychology,
        'color': const Color(0xFF9C27B0),
      },
      {
        'title': 'Lactation Helpline',
        'number': '+1-800-LALECHE',
        'icon': Icons.child_friendly,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Your Healthcare Provider',
        'number': 'Call clinic directly',
        'icon': Icons.local_hospital,
        'color': const Color(0xFF7DA8E6),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emergency, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Emergency Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...contacts.map((contact) {
            print('NewMotherResourcesPage: Rendering Contact: ${contact['title']}');
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
                    print('NewMotherResourcesPage: Emergency Contact Tapped: ${contact['title']}, number=${contact['number']}');
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
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    print('NewMotherResourcesPage: Rendering Navigation Menu');
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationMenuItem(
                      title: 'Dashboard',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/dashboard'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      isActive: true,
                      textColor: const Color(0xFF7DA8E6),
                      onTap: () => _navigateToPage('/new-mother/resources'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Appointments',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/appointments'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Nutrition',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/nutrition'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Health',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/new-mother/health'),
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

  Widget _buildDueDateModal() {
    print('NewMotherResourcesPage: Rendering Due Date Modal, showDueDateModal=$showDueDateModal, dueDateMethod=$dueDateMethod');
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
                    print('NewMotherResourcesPage: Closing Due Date Modal');
                    setState(() {
                      showDueDateModal = false;
                      dueDateMethod = null;
                      dueDateResult = null;
                      dueDateError = null;
                      lastPeriodDate = '';
                      cycleLength = '28';
                      conceptionDate = '';
                      print('NewMotherResourcesPage: Due Date Modal State Reset: showDueDateModal=$showDueDateModal, dueDateMethod=$dueDateMethod');
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
                  print('NewMotherResourcesPage: Due Date Modal: Log In Button Pressed');
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DA8E6),
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
                    print('NewMotherResourcesPage: Due Date Method Selected: menstrual');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DA8E6),
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
                    print('NewMotherResourcesPage: Due Date Method Selected: conception');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
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
                  print('NewMotherResourcesPage: Opening Date Picker for Last Menstrual Period');
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      lastPeriodDate = date.toIso8601String().split('T')[0];
                      print('NewMotherResourcesPage: Last Menstrual Period Date Selected: $lastPeriodDate');
                    });
                  } else {
                    print('NewMotherResourcesPage: Last Menstrual Period Date Picker Cancelled');
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
                    print('NewMotherResourcesPage: Cycle Length Updated: $cycleLength');
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
                  backgroundColor: const Color(0xFF7DA8E6),
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
                  print('NewMotherResourcesPage: Due Date Modal: Back Button Pressed');
                  setState(() {
                    dueDateMethod = null;
                    dueDateResult = null;
                    dueDateError = null;
                    lastPeriodDate = '';
                    cycleLength = '28';
                    print('NewMotherResourcesPage: Due Date Modal: Reset to method selection');
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
                  print('NewMotherResourcesPage: Opening Date Picker for Conception Date');
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      conceptionDate = date.toIso8601String().split('T')[0];
                      print('NewMotherResourcesPage: Conception Date Selected: $conceptionDate');
                    });
                  } else {
                    print('NewMotherResourcesPage: Conception Date Picker Cancelled');
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
                  backgroundColor: const Color(0xFF7DA8E6),
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
                  print('NewMotherResourcesPage: Due Date Modal: Back Button Pressed');
                  setState(() {
                    dueDateMethod = null;
                    dueDateResult = null;
                    dueDateError = null;
                    conceptionDate = '';
                    print('NewMotherResourcesPage: Due Date Modal: Reset to method selection');
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
    print('NewMotherResourcesPage: Rendering Weight Modal, showWeightModal=$showWeightModal');
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
                    print('NewMotherResourcesPage: Closing Weight Modal');
                    setState(() {
                      showWeightModal = false;
                      prePregnancyWeight = '';
                      height = '';
                      gestationalAge = '';
                      weightResult = null;
                      weightError = null;
                      print('NewMotherResourcesPage: Weight Modal State Reset: showWeightModal=$showWeightModal');
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
                  print('NewMotherResourcesPage: Weight Modal: Log In Button Pressed');
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7DA8E6),
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
                    print('NewMotherResourcesPage: Pre-Pregnancy Weight Updated: $prePregnancyWeight');
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
                    print('NewMotherResourcesPage: Height Updated: $height');
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
                    print('NewMotherResourcesPage: Gestational Age Updated: $gestationalAge');
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
                        backgroundColor: const Color(0xFF7DA8E6),
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
                        print('NewMotherResourcesPage: Weight Modal: Cancel Button Pressed');
                        setState(() {
                          showWeightModal = false;
                          prePregnancyWeight = '';
                          height = '';
                          gestationalAge = '';
                          weightResult = null;
                          weightError = null;
                          print('NewMotherResourcesPage: Weight Modal State Reset: showWeightModal=$showWeightModal');
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
    print('NewMotherResourcesPage: Rendering Baby Products Modal, showBabyProductsModal=$showBabyProductsModal, selectedCategory=$selectedCategory, categoryItems.length=${categoryItems.length}');
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
                      print('NewMotherResourcesPage: Closing Baby Products Modal');
                      setState(() {
                        showBabyProductsModal = false;
                        categories = [];
                        selectedCategory = null;
                        categoryItems = [];
                        productsError = null;
                        print('NewMotherResourcesPage: Baby Products Modal State Reset: showBabyProductsModal=$showBabyProductsModal');
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
                    print('NewMotherResourcesPage: Baby Products Modal: Log In Button Pressed');
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
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
                      print('NewMotherResourcesPage: Rendering Category: ID=${category['id']}, Name=$categoryName, Description=$categoryDescription');
                      return GestureDetector(
                        onTap: () {
                          if (category['id'] != null) {
                            setState(() {
                              selectedCategory = category['id'];
                              print('NewMotherResourcesPage: Category Clicked: ID=${category['id']}, Name=$categoryName');
                            });
                            _fetchCategoryItems(category['id'] as int);
                          } else {
                            print('NewMotherResourcesPage: Category Click Ignored: Missing ID for category $categoryName');
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
                              color: selectedCategory == category['id'] ? const Color(0xFF7DA8E6) : Colors.grey[200]!,
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
                                  color: selectedCategory == category['id'] ? const Color(0xFF7DA8E6) : Colors.black,
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
                      height: 300,
                      child: categoryItems.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: categoryItems.length,
                              itemBuilder: (context, index) {
                                final item = categoryItems[index];
                                final itemName = item['name'] as String? ?? 'Unknown Item';
                                final itemQuantity = item['quantity']?.toString() ?? 'N/A';
                                final itemNotes = item['notes'] as String? ?? 'No notes';
                                print('NewMotherResourcesPage: Building Item Widget: Name=$itemName, Quantity=$itemQuantity, Notes=$itemNotes');
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
                      print('NewMotherResourcesPage: Baby Products Modal: Close Button Pressed');
                      setState(() {
                        showBabyProductsModal = false;
                        categories = [];
                        selectedCategory = null;
                        categoryItems = [];
                        productsError = null;
                        print('NewMotherResourcesPage: Baby Products Modal State Reset: showBabyProductsModal=$showBabyProductsModal');
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

  Widget _buildSymptomModal() {
    print('NewMotherResourcesPage: Rendering Symptom Modal, showSymptomModal=$showSymptomModal');
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
                    'Symptom Tracker',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      print('NewMotherResourcesPage: Closing Symptom Modal');
                      setState(() {
                        showSymptomModal = false;
                        symptomsInput = '';
                        analysisResult = null;
                        symptomError = null;
                        print('NewMotherResourcesPage: Symptom Modal State Reset: showSymptomModal=$showSymptomModal');
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (authToken == null) ...[
                const Text(
                  'Please log in to use the Symptom Tracker.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    print('NewMotherResourcesPage: Symptom Modal: Log In Button Pressed');
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Log In'),
                ),
              ] else ...[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter symptoms (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      symptomsInput = value;
                      print('NewMotherResourcesPage: Symptoms Input Updated: $symptomsInput');
                    });
                  },
                  controller: TextEditingController(text: symptomsInput),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: symptomLoading || symptomsInput.trim().isEmpty
                      ? null
                      : _handleSymptomSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: symptomLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Analyze Symptoms'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showPastEntries = !showPastEntries;
                          print('NewMotherResourcesPage: Toggle Past Entries: showPastEntries=$showPastEntries');
                        });
                      },
                      child: Text(showPastEntries ? 'Hide Past Entries' : 'View Past Entries'),
                    ),
                    TextButton(
                      onPressed: () {
                        print('NewMotherResourcesPage: Symptom Modal: Cancel Button Pressed');
                        setState(() {
                          showSymptomModal = false;
                          symptomsInput = '';
                          analysisResult = null;
                          symptomError = null;
                          print('NewMotherResourcesPage: Symptom Modal State Reset: showSymptomModal=$showSymptomModal');
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                if (symptomError != null) ...[
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
                        Expanded(child: Text(symptomError!, style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ],
                if (analysisResult != null) ...[
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
                        const Text('Symptom Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Possible Conditions:', style: TextStyle(fontWeight: FontWeight.w600)),
                        if (analysisResult!['possible_conditions']?.isEmpty ?? true)
                          const Text('No conditions identified based on your symptoms.')
                        else
                          ...analysisResult!['possible_conditions'].map<Widget>((condition) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Condition: ${condition['condition'] ?? 'Unknown'}'),
                                  Text('Description: ${condition['description'] ?? 'No description'}'),
                                  Text('Matching Symptoms: ${condition['matchingSymptoms']?.join(', ') ?? 'None'}'),
                                  Text('Risk Level: ${condition['riskLevel'] ?? 'Unknown'}'),
                                  Text('Additional Info: ${condition['additionalInfo'] ?? 'None'}'),
                                  const SizedBox(height: 8),
                                ],
                              )),
                        const SizedBox(height: 8),
                        const Text('General Advice:', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('Recommended Actions: ${analysisResult!['general_advice']?['recommendedActions']?.join(', ') ?? 'None'}'),
                        Text('Lifestyle Considerations: ${analysisResult!['general_advice']?['lifestyleConsiderations']?.join(', ') ?? 'None'}'),
                        Text('When to Seek Medical Attention: ${analysisResult!['general_advice']?['whenToSeekMedicalAttention']?.join(', ') ?? 'None'}'),
                      ],
                    ),
                  ),
                ],
                if (showPastEntries) ...[
                  const SizedBox(height: 16),
                  const Text('Past Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  journalLoading
                      ? const Center(child: CircularProgressIndicator())
                      : journalEntries.isEmpty
                          ? const Text('No entries available.', style: TextStyle(color: Colors.grey))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: journalEntries.length,
                              itemBuilder: (context, index) {
                                final entry = journalEntries[index];
                                final isExpanded = expandedEntries.contains(entry['id']);
                                final isSymptom = entry['type'] == 'symptom';
                                final summary = isSymptom
                                    ? 'Symptom Analysis'
                                    : (entry['entry']?.substring(0, entry['entry'].length > 50 ? 50 : entry['entry'].length) ?? 'No content') + (entry['entry']?.length > 50 ? '...' : '');
                                print('NewMotherResourcesPage: Rendering Entry: id=${entry['id']}, type=${entry['type']}, summary=$summary');
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
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isExpanded) {
                                              expandedEntries.remove(entry['id']);
                                            } else {
                                              expandedEntries.add(entry['id']);
                                            }
                                            print('NewMotherResourcesPage: Entry Toggled: id=${entry['id']}, isExpanded=$isExpanded');
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text(summary, style: const TextStyle(fontWeight: FontWeight.bold))),
                                            Text(
                                              entry['created_at']?.split('T')[0] ?? 'Unknown Date',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isExpanded) ...[
                                        const SizedBox(height: 8),
                                        if (isSymptom && entry['analysis'] != null) ...[
                                          const Text('Symptom Analysis:', style: TextStyle(fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 4),
                                          const Text('Possible Conditions:', style: TextStyle(fontWeight: FontWeight.w500)),
                                          if (entry['analysis']['possible_conditions']?.isEmpty ?? true)
                                            const Text('No conditions identified.')
                                          else
                                            ...entry['analysis']['possible_conditions'].map<Widget>((condition) => Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Condition: ${condition['condition'] ?? 'Unknown'}'),
                                                    Text('Description: ${condition['description'] ?? 'No description'}'),
                                                    Text('Matching Symptoms: ${condition['matchingSymptoms']?.join(', ') ?? 'None'}'),
                                                    Text('Risk Level: ${condition['riskLevel'] ?? 'Unknown'}'),
                                                    Text('Additional Info: ${condition['additionalInfo'] ?? 'None'}'),
                                                    const SizedBox(height: 8),
                                                  ],
                                                )),
                                          const SizedBox(height: 4),
                                          const Text('General Advice:', style: TextStyle(fontWeight: FontWeight.w500)),
                                          Text('Recommended Actions: ${entry['analysis']['general_advice']?['recommendedActions']?.join(', ') ?? 'None'}'),
                                          Text('Lifestyle Considerations: ${entry['analysis']['general_advice']?['lifestyleConsiderations']?.join(', ') ?? 'None'}'),
                                          Text('When to Seek Medical Attention: ${entry['analysis']['general_advice']?['whenToSeekMedicalAttention']?.join(', ') ?? 'None'}'),
                                        ] else
                                          Text(entry['entry'] ?? 'No content'),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: () => _handleDeleteEntry(entry['id']),
                                          child: const Text('Delete Entry', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJournalModal() {
    print('NewMotherResourcesPage: Rendering Journal Modal, showJournalModal=$showJournalModal');
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
                    'Journal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      print('NewMotherResourcesPage: Closing Journal Modal');
                      setState(() {
                        showJournalModal = false;
                        journalEntry = '';
                        journalError = null;
                        print('NewMotherResourcesPage: Journal Modal State Reset: showJournalModal=$showJournalModal');
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (authToken == null) ...[
                const Text(
                  'Please log in to use the Journal.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    print('NewMotherResourcesPage: Journal Modal: Log In Button Pressed');
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Log In'),
                ),
              ] else ...[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Write your journal entry',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      journalEntry = value;
                      print('NewMotherResourcesPage: Journal Entry Updated: $journalEntry');
                    });
                  },
                  controller: TextEditingController(text: journalEntry),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: journalLoading || journalEntry.trim().isEmpty
                      ? null
                      : _handleJournalSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: journalLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Journal'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showPastEntries = !showPastEntries;
                          print('NewMotherResourcesPage: Toggle Past Entries: showPastEntries=$showPastEntries');
                        });
                      },
                      child: Text(showPastEntries ? 'Hide Past Entries' : 'View Past Entries'),
                    ),
                    TextButton(
                      onPressed: () {
                        print('NewMotherResourcesPage: Journal Modal: Cancel Button Pressed');
                        setState(() {
                          showJournalModal = false;
                          journalEntry = '';
                          journalError = null;
                          print('NewMotherResourcesPage: Journal Modal State Reset: showJournalModal=$showJournalModal');
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                if (journalError != null) ...[
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
                        Expanded(child: Text(journalError!, style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ],
                if (showPastEntries) ...[
                  const SizedBox(height: 16),
                  const Text('Past Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  journalLoading
                      ? const Center(child: CircularProgressIndicator())
                      : journalEntries.isEmpty
                          ? const Text('No entries available.', style: TextStyle(color: Colors.grey))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: journalEntries.length,
                              itemBuilder: (context, index) {
                                final entry = journalEntries[index];
                                final isExpanded = expandedEntries.contains(entry['id']);
                                final isSymptom = entry['type'] == 'symptom';
                                final summary = isSymptom
                                    ? 'Symptom Analysis'
                                    : (entry['entry']?.substring(0, entry['entry'].length > 50 ? 50 : entry['entry'].length) ?? 'No content') + (entry['entry']?.length > 50 ? '...' : '');
                                print('NewMotherResourcesPage: Rendering Entry: id=${entry['id']}, type=${entry['type']}, summary=$summary');
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
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isExpanded) {
                                              expandedEntries.remove(entry['id']);
                                            } else {
                                              expandedEntries.add(entry['id']);
                                            }
                                            print('NewMotherResourcesPage: Entry Toggled: id=${entry['id']}, isExpanded=$isExpanded');
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text(summary, style: const TextStyle(fontWeight: FontWeight.bold))),
                                            Text(
                                              entry['created_at']?.split('T')[0] ?? 'Unknown Date',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isExpanded) ...[
                                        const SizedBox(height: 8),
                                        if (isSymptom && entry['analysis'] != null) ...[
                                          const Text('Symptom Analysis:', style: TextStyle(fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 4),
                                          const Text('Possible Conditions:', style: TextStyle(fontWeight: FontWeight.w500)),
                                          if (entry['analysis']['possible_conditions']?.isEmpty ?? true)
                                            const Text('No conditions identified.')
                                          else
                                            ...entry['analysis']['possible_conditions'].map<Widget>((condition) => Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Condition: ${condition['condition'] ?? 'Unknown'}'),
                                                    Text('Description: ${condition['description'] ?? 'No description'}'),
                                                    Text('Matching Symptoms: ${condition['matchingSymptoms']?.join(', ') ?? 'None'}'),
                                                    Text('Risk Level: ${condition['riskLevel'] ?? 'Unknown'}'),
                                                    Text('Additional Info: ${condition['additionalInfo'] ?? 'None'}'),
                                                    const SizedBox(height: 8),
                                                  ],
                                                )),
                                          const SizedBox(height: 4),
                                          const Text('General Advice:', style: TextStyle(fontWeight: FontWeight.w500)),
                                          Text('Recommended Actions: ${entry['analysis']['general_advice']?['recommendedActions']?.join(', ') ?? 'None'}'),
                                          Text('Lifestyle Considerations: ${entry['analysis']['general_advice']?['lifestyleConsiderations']?.join(', ') ?? 'None'}'),
                                          Text('When to Seek Medical Attention: ${entry['analysis']['general_advice']?['whenToSeekMedicalAttention']?.join(', ') ?? 'None'}'),
                                        ] else
                                          Text(entry['entry'] ?? 'No content'),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: () => _handleDeleteEntry(entry['id']),
                                          child: const Text('Delete Entry', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatbotModal() {
    print('NewMotherResourcesPage: Rendering Chatbot Modal, showChatbotModal=$showChatbotModal');
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
                    'Pregnancy Assistant',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      print('NewMotherResourcesPage: Closing Chatbot Modal');
                      setState(() {
                        showChatbotModal = false;
                        chatbotQuestion = '';
                        chatbotResponse = null;
                        chatbotError = null;
                        chatbotLoading = false;
                        print('NewMotherResourcesPage: Chatbot Modal State Reset: showChatbotModal=$showChatbotModal');
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (authToken == null) ...[
                const Text(
                  'Please log in to use the Pregnancy Assistant.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    print('NewMotherResourcesPage: Chatbot Modal: Log In Button Pressed');
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Log In'),
                ),
              ] else ...[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Ask a question',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      chatbotQuestion = value;
                      print('NewMotherResourcesPage: Chatbot Question Updated: $chatbotQuestion');
                    });
                  },
                  controller: TextEditingController(text: chatbotQuestion),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: chatbotLoading || chatbotQuestion.trim().isEmpty
                      ? null
                      : _handleChatbotSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7DA8E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: chatbotLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Ask Now'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    print('NewMotherResourcesPage: Chatbot Modal: Cancel Button Pressed');
                    setState(() {
                      showChatbotModal = false;
                      chatbotQuestion = '';
                      chatbotResponse = null;
                      chatbotError = null;
                      chatbotLoading = false;
                      print('NewMotherResourcesPage: Chatbot Modal State Reset: showChatbotModal=$showChatbotModal');
                    });
                  },
                  child: const Text('Cancel'),
                ),
                if (chatbotError != null) ...[
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
                        Expanded(child: Text(chatbotError!, style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ],
                if (chatbotResponse != null && chatbotResponse!['message'] != null) ...[
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
                        const Text('Response', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(chatbotResponse!['message'] ?? 'No response'),
                        if (chatbotResponse!['recommendations']?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          const Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.w600)),
                          ...chatbotResponse!['recommendations'].map<Widget>((rec) => Text('• $rec')),
                        ],
                        if (chatbotResponse!['warnings']?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          const Text('Warnings:', style: TextStyle(fontWeight: FontWeight.w600)),
                          ...chatbotResponse!['warnings'].map<Widget>((warn) => Text('• $warn')),
                        ],
                        if (chatbotResponse!['followUp']?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          const Text('Follow-Up:', style: TextStyle(fontWeight: FontWeight.w600)),
                          ...chatbotResponse!['followUp'].map<Widget>((follow) => Text('• $follow')),
                        ],
                      ],
                    ),
                  ),
                ] else if (!chatbotLoading && chatbotError == null) ...[
                  const SizedBox(height: 16),
                  const Text('No response yet. Ask a question to get started.', style: TextStyle(color: Colors.grey)),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}