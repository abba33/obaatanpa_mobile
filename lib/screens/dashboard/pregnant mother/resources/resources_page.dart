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
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == categories.length - 1 ? 16 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF8BBD9) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
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
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          final resources = [
            {
              'title': 'Your Complete Pregnancy Guide',
              'subtitle': 'Everything you need to know',
              'image': Icons.book,
              'color': const Color(0xFFF8BBD9),
            },
            {
              'title': 'Healthy Pregnancy Diet',
              'subtitle': 'Nutrition for you and baby',
              'image': Icons.restaurant,
              'color': const Color(0xFF81C784),
            },
            {
              'title': 'Prenatal Exercise Plan',
              'subtitle': 'Safe workouts during pregnancy',
              'image': Icons.fitness_center,
              'color': const Color(0xFF64B5F6),
            },
          ];
          
          final resource = resources[index];
          
          return Container(
            width: 280,
            margin: EdgeInsets.only(right: index < 2 ? 16 : 0),
            decoration: BoxDecoration(
              color: resource['color'] as Color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    resource['image'] as IconData,
                    color: Colors.white,
                    size: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource['title'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resource['subtitle'].toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Read More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
        'title': 'Understanding Your First Trimester',
        'category': 'Pregnancy',
        'readTime': '5 min read',
        'description': 'Learn about the changes happening in your body during the first trimester.',
      },
      {
        'title': 'Essential Vitamins for Pregnancy',
        'category': 'Nutrition',
        'readTime': '7 min read',
        'description': 'Discover the key vitamins and minerals you need during pregnancy.',
      },
      {
        'title': 'Managing Pregnancy Anxiety',
        'category': 'Mental Health',
        'readTime': '6 min read',
        'description': 'Tips and techniques for managing stress and anxiety during pregnancy.',
      },
      {
        'title': 'Preparing for Labor and Delivery',
        'category': 'Pregnancy',
        'readTime': '10 min read',
        'description': 'Everything you need to know about preparing for your baby\'s arrival.',
      },
    ];

    return Column(
      children: articles.map((article) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8BBD9).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.article,
                  color: Color(0xFFF8BBD9),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article['description'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8BBD9).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article['category'].toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFF8BBD9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article['readTime'].toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYouTubeVideoResources() {
    // Real YouTube videos related to pregnancy and maternal health
    final videos = [
      {
        'title': 'Prenatal Yoga for All Trimesters',
        'duration': '15:30',
        'videoId': 'oHYGCYUVyUE', // Prenatal yoga video
        'channel': 'Yoga with Adriene',
        'thumbnail': 'https://img.youtube.com/vi/oHYGCYUVyUE/maxresdefault.jpg',
        'category': 'Exercise',
      },
      {
        'title': 'Labor & Delivery Breathing Techniques',
        'duration': '12:45',
        'videoId': 'T3R9fzXpAFc', // Breathing techniques
        'channel': 'Lamaze International',
        'thumbnail': 'https://img.youtube.com/vi/T3R9fzXpAFc/maxresdefault.jpg',
        'category': 'Pregnancy',
      },
      {
        'title': 'Baby Care Essentials for New Parents',
        'duration': '18:20',
        'videoId': 'Z-3IKBHZhWE', // Baby care basics
        'channel': 'BabyCenter',
        'thumbnail': 'https://img.youtube.com/vi/Z-3IKBHZhWE/maxresdefault.jpg',
        'category': 'Baby Care',
      },
      {
        'title': 'Healthy Pregnancy Nutrition Guide',
        'duration': '14:15',
        'videoId': 'Q7T8vd1V6Dc', // Pregnancy nutrition
        'channel': 'Mayo Clinic',
        'thumbnail': 'https://img.youtube.com/vi/Q7T8vd1V6Dc/maxresdefault.jpg',
        'category': 'Nutrition',
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
      },
      {
        'title': 'Maternal Health Helpline',
        'number': '+233 30 123 4567',
        'description': 'Pregnancy support and advice',
        'icon': Icons.phone,
        'color': const Color(0xFFF8BBD9),
      },
      {
        'title': 'Mental Health Support',
        'number': '+233 30 765 4321',
        'description': 'Counseling and mental health support',
        'icon': Icons.psychology,
        'color': const Color(0xFF81C784),
      },
    ];

    return Column(
      children: contacts.map((contact) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (contact['color'] as Color).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (contact['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  contact['icon'] as IconData,
                  color: contact['color'] as Color,
                  size: 24,
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
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      contact['number'].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: contact['color'] as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      contact['description'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.call,
                color: contact['color'] as Color,
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}