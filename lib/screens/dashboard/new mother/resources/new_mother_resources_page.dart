import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obaatanpa_mobile/screens/dashboard/pregnant%20mother/components/custom_app_bar.dart';
import 'package:obaatanpa_mobile/widgets/navigation/navigation_menu.dart';

class NewMotherResourcesScreen extends StatefulWidget {
  const NewMotherResourcesScreen({super.key});

  @override
  State<NewMotherResourcesScreen> createState() =>
      _NewMotherResourcesScreenState();
}

class _NewMotherResourcesScreenState extends State<NewMotherResourcesScreen> {
  String selectedCategory = 'All';
  bool isMenuOpen = false;
  bool showAllArticles = false;

  final List<String> categories = [
    'All',
    'Postpartum Recovery',
    'Breastfeeding',
    'Baby Care',
    'Mental Health',
    'Sleep & Rest',
    'Nutrition',
  ];

  // Define colors - using 7DA8E6 blue and green for postpartum theme
  static const Color primaryBlue = Color(0xFF7DA8E6);
  static const Color primaryGreen = Color(0xFF81C784);
  static const Color accentMint = Color(0xFF4CAF50);
  static const Color softBlue = Color(0xFFB3D4F1);

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _navigateToPage(String routeName) {
    _toggleMenu();

    if (routeName != '/new-mother-resources') {
      context.go(routeName);
    }
  }

  void _navigateToResource(String resourceTitle) {
    // Navigate to appropriate page based on resource type
    switch (resourceTitle.toLowerCase()) {
      case 'postpartum recovery guide':
        context.go('/new-mother-resources');
        break;
      case 'breastfeeding essentials':
        context.go('/breastfeeding');
        break;
      case 'newborn care basics':
        context.go('/baby-care');
        break;
      default:
        context.go('/new-mother-resources');
    }
  }

  void _navigateToArticle(String category) {
    // Navigate to appropriate page based on article category
    switch (category.toLowerCase()) {
      case 'postpartum recovery':
        context.go('/postpartum-recovery');
        break;
      case 'breastfeeding':
        context.go('/breastfeeding');
        break;
      case 'baby care':
        context.go('/baby-care');
        break;
      case 'mental health':
        context.go('/mental-health');
        break;
      case 'sleep & rest':
        context.go('/sleep-rest');
        break;
      case 'nutrition':
        context.go('/nutrition');
        break;
      default:
        context.go('/new-mother-resources');
    }
  }

  void _navigateToTool(String toolTitle) {
    // Navigate to appropriate page based on tool type
    switch (toolTitle.toLowerCase()) {
      case 'feeding tracker':
        context.go('/feeding-tracker');
        break;
      case 'diaper log':
        context.go('/diaper-log');
        break;
      case 'sleep tracker':
        context.go('/sleep-tracker');
        break;
      case 'growth chart':
        context.go('/growth-chart');
        break;
      default:
        context.go('/baby-care');
    }
  }

  // Function to launch YouTube videos
  Future<void> _launchYouTubeVideo(String videoId) async {
    final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final youtubeAppUrl =
        Uri.parse('youtube://www.youtube.com/watch?v=$videoId');

    try {
      // Try to open in YouTube app first
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl);
      } else {
        // Fallback to web browser
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open video')),
      );
    }
  }

  // Function to make phone calls
  Future<void> _makePhoneCall(String phoneNumber) async {
    final phoneUrl = Uri.parse('tel:$phoneNumber');

    try {
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not make phone call')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make phone call')),
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
                title: 'New Mother Resources',
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

                            // Tools & Trackers Section
                            _buildSectionHeader('Tools & Trackers'),
                            const SizedBox(height: 12),
                            _buildToolsGrid(),

                            const SizedBox(height: 32),

                            // Support Contacts Section
                            _buildSectionHeader('Support Contacts'),
                            const SizedBox(height: 12),
                            _buildSupportContacts(),
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
                      color: primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.child_care,
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
                        'New Mother Support',
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
                      onTap: () => _navigateToPage('/dashboard/new-mother'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Resources',
                      isActive: true,
                      textColor: primaryBlue,
                      onTap: () => _navigateToPage('/new-mother-resources'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Baby Care',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/baby-care'),
                    ),
                    const SizedBox(height: 32),
                    NavigationMenuItem(
                      title: 'Breastfeeding',
                      textColor: Colors.black87,
                      onTap: () => _navigateToPage('/breastfeeding'),
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
                showAllArticles = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? primaryBlue : Colors.grey[50],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? primaryBlue : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.3),
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
              'title': 'Postpartum Recovery Guide',
              'subtitle': 'Your complete healing journey',
              'imagePath': 'assets/images/resources/postpartum_recovery.png',
              'overlayColor': primaryBlue,
            },
            {
              'title': 'Breastfeeding Essentials',
              'subtitle': 'Everything about nursing',
              'imagePath': 'assets/images/resources/breastfeeding_guide.png',
              'overlayColor': primaryGreen,
            },
            {
              'title': 'Newborn Care Basics',
              'subtitle': 'First weeks with your baby',
              'imagePath': 'assets/images/resources/newborn_care.png',
              'overlayColor': accentMint,
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
                  // Background color (fallback)
                  Positioned.fill(
                    child: Container(
                      color:
                          (resource['overlayColor'] as Color).withOpacity(0.8),
                    ),
                  ),

                  // Background Image (if available)
                  Positioned.fill(
                    child: Image.asset(
                      resource['imagePath'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Keep the solid color background as fallback
                        return Container(
                          color: resource['overlayColor'] as Color,
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

                  // Content
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon indicator
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
                            index == 0
                                ? Icons.healing
                                : index == 1
                                    ? Icons.child_care
                                    : Icons.baby_changing_station,
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
                        GestureDetector(
                          onTap: () {
                            _navigateToResource(resource['title'].toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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

  Widget _buildYouTubeVideoResources() {
    // Real YouTube videos related to postpartum and new mother care
    final videos = [
      {
        'title': 'Postpartum Recovery: What to Expect After Birth',
        'duration': '18:45',
        'videoId': 'Sb0TiU3Q5Vk',
        'channel': 'Postpartum Stress Center',
        'thumbnail': 'https://img.youtube.com/vi/Sb0TiU3Q5Vk/maxresdefault.jpg',
        'category': 'Recovery',
      },
      {
        'title': 'Breastfeeding Basics: Getting Started',
        'duration': '12:30',
        'videoId': 'CO2w_PjNw_E',
        'channel': 'Global Health Media',
        'thumbnail': 'https://img.youtube.com/vi/CO2w_PjNw_E/maxresdefault.jpg',
        'category': 'Breastfeeding',
      },
      {
        'title': 'Newborn Care: First Week Home from Hospital',
        'duration': '15:20',
        'videoId': 'NWgaGjJqo8E',
        'channel': 'Cloud Nine Maternity',
        'thumbnail': 'https://img.youtube.com/vi/NWgaGjJqo8E/maxresdefault.jpg',
        'category': 'Baby Care',
      },
      {
        'title': 'Postpartum Depression: Signs and Support',
        'duration': '22:15',
        'videoId': 'bSbmBlmHLMY',
        'channel': 'Postpartum Progress',
        'thumbnail': 'https://img.youtube.com/vi/bSbmBlmHLMY/maxresdefault.jpg',
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

          return GestureDetector(
            onTap: () => _launchYouTubeVideo(video['videoId'].toString()),
            child: Container(
              width: 280,
              margin:
                  EdgeInsets.only(right: index < videos.length - 1 ? 16 : 0),
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
                        color: Colors.grey[300],
                      ),
                      child: Image.network(
                        video['thumbnail'].toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: primaryBlue.withOpacity(0.2),
                            child: const Center(
                              child: Icon(
                                Icons.video_library,
                                size: 50,
                                color: primaryBlue,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primaryBlue.withOpacity(0.8),
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
        'title': 'Feeding Tracker',
        'icon': Icons.schedule,
        'color': primaryBlue,
      },
      {
        'title': 'Diaper Log',
        'icon': Icons.baby_changing_station,
        'color': primaryGreen,
      },
      {
        'title': 'Sleep Tracker',
        'icon': Icons.bedtime,
        'color': accentMint,
      },
      {
        'title': 'Growth Chart',
        'icon': Icons.show_chart,
        'color': const Color(0xFFFF9800),
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

        return GestureDetector(
          onTap: () {
            _navigateToTool(tool['title'].toString());
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
          ),
        );
      },
    );
  }

  Widget _buildSupportContacts() {
    final contacts = [
      {
        'title': 'Emergency',
        'number': '911',
        'icon': Icons.emergency,
        'color': Colors.red,
      },
      {
        'title': 'Postpartum Support',
        'number': '+233 30 123 4567',
        'icon': Icons.support_agent,
        'color': primaryBlue,
      },
      {
        'title': 'Lactation Support',
        'number': '+233 30 765 4321',
        'icon': Icons.child_care,
        'color': primaryGreen,
      },
      {
        'title': 'Mental Health Crisis',
        'number': '+233 30 555 0123',
        'icon': Icons.psychology,
        'color': const Color(0xFF9C27B0),
      },
    ];

    return Column(
      children: contacts.map((contact) {
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
                _makePhoneCall(contact['number'].toString());
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon container
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

                    // Contact info
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

                    // Call button
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

  Widget _buildArticlesList() {
    final articles = [
      {
        'title': 'Understanding Your Postpartum Body',
        'category': 'Postpartum Recovery',
        'readTime': '10 min read',
        'description':
            'Learn about physical changes after delivery and what to expect during your recovery period.',
        'author': 'Dr. Emily Watson',
        'publishDate': '1 day ago',
        'likes': '298',
        'isBookmarked': true,
        'categoryColor': primaryBlue,
      },
      {
        'title': 'Getting Breastfeeding Started Right',
        'category': 'Breastfeeding',
        'readTime': '8 min read',
        'description':
            'Essential tips for successful breastfeeding initiation and establishing a good latch.',
        'author': 'Lactation Consultant Maria Lopez',
        'publishDate': '2 days ago',
        'likes': '187',
        'isBookmarked': false,
        'categoryColor': primaryGreen,
      },
      {
        'title': 'Managing Postpartum Depression and Anxiety',
        'category': 'Mental Health',
        'readTime': '12 min read',
        'description':
            'Recognizing symptoms and finding support for mental health challenges after childbirth.',
        'author': 'Dr. Sarah Johnson',
        'publishDate': '3 days ago',
        'likes': '156',
        'isBookmarked': true,
        'categoryColor': const Color(0xFF9C27B0),
      },
      {
        'title': 'Sleep When Baby Sleeps: Making It Work',
        'category': 'Sleep & Rest',
        'readTime': '6 min read',
        'description':
            'Practical strategies for getting adequate rest during those challenging first months.',
        'author': 'Sleep Specialist Dr. Mark Thompson',
        'publishDate': '4 days ago',
        'likes': '234',
        'isBookmarked': false,
        'categoryColor': const Color(0xFF3F51B5),
      },
      {
        'title': 'Nutrition for Breastfeeding Mothers',
        'category': 'Nutrition',
        'readTime': '9 min read',
        'description':
            'Essential nutrients and foods that support both your recovery and milk production.',
        'author': 'Registered Dietitian Lisa Chen',
        'publishDate': '5 days ago',
        'likes': '165',
        'isBookmarked': false,
        'categoryColor': accentMint,
      },
      {
        'title': 'First Month Baby Care Essentials',
        'category': 'Baby Care',
        'readTime': '7 min read',
        'description':
            'Everything you need to know about caring for your newborn in the first four weeks.',
        'author': 'Pediatric Nurse Amy Wilson',
        'publishDate': '1 week ago',
        'likes': '201',
        'isBookmarked': true,
        'categoryColor': const Color(0xFFFF9800),
      },
    ];

    // Filter articles based on selected category
    final filteredArticles = selectedCategory == 'All'
        ? articles
        : articles
            .where((article) => article['category'] == selectedCategory)
            .toList();

    // Determine how many articles to show
    final articlesToShow =
        showAllArticles ? filteredArticles : filteredArticles.take(3).toList();
    final hasMoreArticles = filteredArticles.length > 3;

    return Column(
      children: [
        // Articles list
        ...articlesToShow.map((article) {
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
                  _navigateToArticle(article['category'].toString());
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (article['categoryColor'] as Color)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (article['categoryColor'] as Color)
                                    .withOpacity(0.3),
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
                              setState(() {
                                article['isBookmarked'] =
                                    !(article['isBookmarked'] as bool);
                              });
                            },
                            child: Icon(
                              (article['isBookmarked'] as bool)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: (article['isBookmarked'] as bool)
                                  ? primaryBlue
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
                              color: (article['categoryColor'] as Color)
                                  .withOpacity(0.2),
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

        // See More/See Less button
        if (hasMoreArticles)
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showAllArticles = !showAllArticles;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showAllArticles ? 'See Less' : 'See More Articles',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: showAllArticles ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
