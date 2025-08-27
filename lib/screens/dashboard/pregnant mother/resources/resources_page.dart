import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String selectedCategory = 'All';
  bool isMenuOpen = false;
  
  final List<String> categories = [
    'All',
    'Pregnancy',
    'Nutrition',
    'Exercise',
    'Mental Health',
    'Baby Care',
    'Breastfeeding',
  ];

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();
    
    if (routeName != '/resources') {
      context.go(routeName);
    }
  }

  // Function to launch YouTube videos
  Future<void> _launchYouTubeVideo(String videoId) async {
    final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final youtubeAppUrl = Uri.parse('youtube://www.youtube.com/watch?v=$videoId');
    
    try {
      // Try to open in YouTube app first
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl);
      } else {
        // Fallback to web browser
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error - could show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Custom App Bar
              CustomAppBar(
                isMenuOpen: isMenuOpen,
                onMenuTap: _toggleMenu,
                title: 'Resources',
              ),
              
              // Resources Content
              Expanded(
                child: Column(
                  children: [
                    // Category Filter
                    _buildCategoryFilter(),
                    
                    // Resources Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Featured Resources Section
                            _buildSectionHeader('Featured Resources'),
                            const SizedBox(height: 12),
                            _buildFeaturedResources(),
                            
                            const SizedBox(height: 32),
                            
                            // Educational Articles Section
                            _buildSectionHeader('Educational Articles'),
                            const SizedBox(height: 12),
                            _buildArticlesList(),
                            
                            const SizedBox(height: 32),
                            
                            // YouTube Video Resources Section
                            _buildSectionHeader('Video Resources'),
                            const SizedBox(height: 12),
                            _buildYouTubeVideoResources(),
                            
                            const SizedBox(height: 32),
                            
                            // Tools & Calculators Section
                            _buildSectionHeader('Tools & Calculators'),
                            const SizedBox(height: 12),
                            _buildToolsGrid(),
                            
                            const SizedBox(height: 32),
                            
                            // Emergency Contacts Section
                            _buildSectionHeader('Emergency Contacts'),
                            const SizedBox(height: 12),
                            _buildEmergencyContacts(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Navigation Menu Overlay
          if (isMenuOpen) _buildNavigationMenu(),
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

            // Menu Items
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

  Widget _buildCategoryFilter() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected 
                  ? const LinearGradient(
                      colors: [Color(0xFFF59297), Color(0xFFF8BBD9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
                color: isSelected ? null : Colors.grey[50],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected 
                    ? Colors.transparent 
                    : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: isSelected 
                  ? [
                      BoxShadow(
                        color: const Color(0xFFF59297).withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildFeaturedResources() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          final resources = [
            {
              'title': 'Your Complete Pregnancy Guide',
              'subtitle': 'Everything you need to know',
              'imagePath': 'assets/images/resources/pregnancy_guide.png', // Replace with your actual image path
              'overlayColor': const Color(0xFFF59297),
            },
            {
              'title': 'Healthy Pregnancy Diet',
              'subtitle': 'Nutrition for you and baby',
              'imagePath': 'assets/images/resources/healthy_diet.png', // Replace with your actual image path
              'overlayColor': const Color(0xFF81C784),
            },
            {
              'title': 'Prenatal Exercise Plan',
              'subtitle': 'Safe workouts during pregnancy',
              'imagePath': 'assets/images/resources/prenatal_exercise.png', // Replace with your actual image path
              'overlayColor': const Color(0xFF64B5F6),
            },
          ];
          
          final resource = resources[index];
          
          return Container(
            width: 300,
            margin: EdgeInsets.only(right: index < 2 ? 16 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.asset(
                      resource['imagePath'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback gradient background if image doesn't load
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (resource['overlayColor'] as Color).withOpacity(0.8),
                                (resource['overlayColor'] as Color),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Gradient Overlay for Text Visibility
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Color Overlay for Theme Consistency
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (resource['overlayColor'] as Color).withOpacity(0.2),
                            (resource['overlayColor'] as Color).withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Small icon indicator
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(22.5),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            index == 0 ? Icons.menu_book_rounded :
                            index == 1 ? Icons.restaurant_menu :
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Title and Subtitle
                        Text(
                          resource['title'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource['subtitle'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        
                        // Read More Button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Read More',
                                style: TextStyle(
                                  color: resource['overlayColor'] as Color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: resource['overlayColor'] as Color,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticlesList() {
    final articles = [
      {
        'title': 'First Trimester Changes: What to Expect',
        'category': 'Pregnancy',
        'readTime': '8 min read',
        'description': 'Understanding your body\'s changes, morning sickness, and essential prenatal care during weeks 1-12.',
        'author': 'Dr. Sarah Mitchell',
        'publishDate': '2 days ago',
        'likes': '324',
        'isBookmarked': false,
        'categoryColor': const Color(0xFFF59297),
      },
      {
        'title': 'Folic Acid and Iron: Essential Nutrients',
        'category': 'Nutrition',
        'readTime': '5 min read',
        'description': 'Why these vitamins are crucial for your baby\'s development and the best food sources.',
        'author': 'Nutritionist Jane Adams',
        'publishDate': '1 week ago',
        'likes': '156',
        'isBookmarked': true,
        'categoryColor': const Color(0xFF81C784),
      },
      {
        'title': 'Coping with Pregnancy Anxiety and Stress',
        'category': 'Mental Health',
        'readTime': '10 min read',
        'description': 'Practical strategies for managing worries and maintaining emotional wellness during pregnancy.',
        'author': 'Dr. Michael Chen',
        'publishDate': '3 days ago',
        'likes': '89',
        'isBookmarked': false,
        'categoryColor': const Color(0xFF64B5F6),
      },
      {
        'title': 'Birth Plan Essentials: What You Need to Know',
        'category': 'Pregnancy',
        'readTime': '12 min read',
        'description': 'Creating a flexible birth plan that covers pain management, delivery preferences, and postpartum care.',
        'author': 'Midwife Emma Thompson',
        'publishDate': '5 days ago',
        'likes': '278',
        'isBookmarked': true,
        'categoryColor': const Color(0xFFF59297),
      },
      {
        'title': 'Safe Exercise During Each Trimester',
        'category': 'Exercise',
        'readTime': '7 min read',
        'description': 'Modified workouts and activities that are safe and beneficial throughout your pregnancy journey.',
        'author': 'Fitness Coach Lisa Park',
        'publishDate': '1 week ago',
        'likes': '201',
        'isBookmarked': false,
        'categoryColor': const Color(0xFFFFB74D),
      },
      {
        'title': 'Preparing Your Home for Baby\'s Arrival',
        'category': 'Baby Care',
        'readTime': '6 min read',
        'description': 'Essential baby-proofing tips and must-have items for your newborn\'s safety and comfort.',
        'author': 'Pediatric Nurse Amy Wilson',
        'publishDate': '4 days ago',
        'likes': '145',
        'isBookmarked': false,
        'categoryColor': const Color(0xFFBA68C8),
      },
    ];

    // Filter articles based on selected category
    final filteredArticles = selectedCategory == 'All' 
        ? articles 
        : articles.where((article) => article['category'] == selectedCategory).toList();

    return Column(
      children: filteredArticles.map((article) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Handle article tap
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening: ${article['title']}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with category and bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (article['categoryColor'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (article['categoryColor'] as Color).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            article['category'].toString(),
                            style: TextStyle(
                              fontSize: 11,
                              color: article['categoryColor'] as Color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle bookmark toggle
                            setState(() {
                              article['isBookmarked'] = !(article['isBookmarked'] as bool);
                            });
                          },
                          child: Icon(
                            (article['isBookmarked'] as bool) 
                              ? Icons.bookmark 
                              : Icons.bookmark_border,
                            color: (article['isBookmarked'] as bool) 
                              ? const Color(0xFFF59297) 
                              : Colors.grey[400],
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Article title
                    Text(
                      article['title'].toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Article description
                    Text(
                      article['description'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Author and article info
                    Row(
                      children: [
                        // Author avatar
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: (article['categoryColor'] as Color).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.person,
                            color: article['categoryColor'] as Color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        
                        // Author and publish info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['author'].toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                article['publishDate'].toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Read time and likes
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  article['readTime'].toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  article['likes'].toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildYouTubeVideoResources() {
    // Real YouTube videos related to pregnancy and maternal health
    final videos = [
       {
  'title': "A Dietitian's Guide To Eating During Each Trimester of Pregnancy",
  'duration': '<Not specified>',
  'videoId': 'dq7ovxsAfX8',
  'channel': '<Not specified>',
  'thumbnail': 'https://img.youtube.com/vi/dq7ovxsAfX8/maxresdefault.jpg',
  'category': 'Nutrition / Pregnancy Health',
},
      {
  'title': '10 minute PRENATAL YOGA for Beginners (Safe for ALL Trimesters)',
  'duration': '10:00',
  'videoId': '4NwQKXpWN_A',
  'channel': 'Unknown not specified in available sources',
  'thumbnail': 'https://img.youtube.com/vi/4NwQKXpWN_A/maxresdefault.jpg',
  'category': 'Exercise',
},

      {
  'title': 'How to Breathe and Push During Labor | Lamaze',
  'duration': 'Not specified approx. short instructional video (~5 min?)',
  'videoId': '0pNldTVh5B4',
  'channel': 'Bridget Teyler',
  'thumbnail': 'https://img.youtube.com/vi/0pNldTVh5B4/maxresdefault.jpg',
  'category': 'Exercise / Childbirth Education',
},

      {
  'title': '<Video Title Here>',
  'duration': '<HH:MM or MM:SS>',
  'videoId': 'kDvkYvK3M2Q', // Extracted from the iframe src
  'channel': '<Channel Name Here>',
  'thumbnail': 'https://img.youtube.com/vi/kDvkYvK3M2Q/maxresdefault.jpg',
  'category': 'Baby care', // or whichever category best fits the content
},

     

    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          
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
                    // YouTube Thumbnail
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
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Play button overlay
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
                    
                    // Duration badge
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
                    
                    // Video info overlay
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

  Widget _buildToolsGrid() {
    final tools = [
      {
        'title': 'Due Date Calculator',
        'icon': Icons.calculate,
        'color': const Color(0xFF81C784),
      },
      {
        'title': 'Weight Tracker',
        'icon': Icons.monitor_weight,
        'color': const Color(0xFF64B5F6),
      },
      {
        'title': 'Kick Counter',
        'icon': Icons.favorite,
        'color': const Color(0xFFF8BBD9),
      },
      {
        'title': 'Contraction Timer',
        'icon': Icons.timer,
        'color': const Color(0xFFFFB74D),
      },
    ];

    return GridView.builder(
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
        
        return Container(
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
          child: Column(
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
            ],
          ),
        );
      },
    );
  }

Widget _buildEmergencyContacts() {
  final contacts = [
    {
      'title': 'Emergency Hotline',
      'number': '911',
      'description': '24/7 Emergency Services',
      'icon': Icons.emergency,
      'color': Colors.red,
      'gradientColors': [const Color(0xFFFF6B6B), const Color(0xFFFF5252)],
    },
    {
      'title': 'Maternal Health Helpline',
      'number': '+233 30 123 4567',
      'description': 'Pregnancy support and advice',
      'icon': Icons.phone,
      'color': const Color(0xFFF8BBD9),
      'gradientColors': [const Color(0xFFF8BBD9), const Color(0xFFF59297)],
    },
    {
      'title': 'Mental Health Support',
      'number': '+233 30 765 4321',
      'description': 'Counseling and mental health support',
      'icon': Icons.psychology,
      'color': const Color(0xFF81C784),
      'gradientColors': [const Color(0xFF81C784), const Color(0xFF66BB6A)],
    },
  ];

  return Column(
    children: contacts.asMap().entries.map((entry) {
      final index = entry.key;
      final contact = entry.value;
      
      return AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 100)),
        curve: Curves.easeOutBack,
        margin: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              // Main shadow for depth
              BoxShadow(
                color: (contact['color'] as Color).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              // Secondary shadow for more depth
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              // Inner highlight for 3D effect
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Handle contact tap - could open dialer
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${contact['number']}...'),
                    backgroundColor: contact['color'] as Color,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // 3D Icon Container
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: contact['gradientColors'] as List<Color>,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: (contact['color'] as Color).withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: (contact['color'] as Color).withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          // Inner highlight
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: -1,
                            blurRadius: 1,
                            offset: Offset(-1, -1),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Subtle inner shadow for depth
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.1),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Icon
                          Center(
                            child: Icon(
                              contact['icon'] as IconData,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Contact Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['title'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (contact['color'] as Color).withOpacity(0.1),
                                  (contact['color'] as Color).withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (contact['color'] as Color).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              contact['number'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: contact['color'] as Color,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contact['description'].toString(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.3,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Call Action Button with 3D Effect
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          // Inner highlight
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: -1,
                            blurRadius: 1,
                            offset: Offset(-1, -1),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            // Handle call button tap
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Calling ${contact['number']}...'),
                                backgroundColor: contact['color'] as Color,
                              ),
                            );
                          },
                          child: Center(
                            child: Icon(
                              Icons.call,
                              color: contact['color'] as Color,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}
}