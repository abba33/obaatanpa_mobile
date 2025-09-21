import 'package:flutter/material.dart';
import 'package:obaatanpa_mobile/providers/theme_provider.dart';
import 'package:obaatanpa_mobile/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+233 XX XXX XXXX');
  final _emergencyContactController =
      TextEditingController(text: '+233 XX XXX XXXX');

  String _selectedBloodType = 'O+';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 90));
  int _currentWeek = 24;
  String? _profilePicturePath;
  final ImagePicker _picker = ImagePicker();
  bool _isUpdatingPhoto = false;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      final user = authProvider.user!;
      _nameController.text = (authProvider.userName?.isNotEmpty == true)
          ? authProvider.userName!
          : 'User';
      _emailController.text = user['email'] ?? 'user@example.com';
      _profilePicturePath = authProvider.profilePicture;
    }
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isUpdatingPhoto = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profilePicturePath = image.path;
        });

        // Update the profile picture in AuthProvider
        final authProvider = context.read<AuthProvider>();
        await authProvider.updateProfilePicture(image.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPhoto = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      setState(() {
        _isUpdatingPhoto = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profilePicturePath = image.path;
        });

        // Update the profile picture in AuthProvider
        final authProvider = context.read<AuthProvider>();
        await authProvider.updateProfilePicture(image.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPhoto = false;
        });
      }
    }
  }

  void _removeProfilePicture() {
    setState(() {
      _profilePicturePath = null;
    });
    final authProvider = context.read<AuthProvider>();
    authProvider.updateProfilePicture(null);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture removed'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final themeProvider = context.watch<ThemeProvider>();
        final isDark = themeProvider.isDarkMode;
        final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;
        
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Change Profile Picture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: Text('Choose from Gallery', style: TextStyle(color: textColor)),
                  subtitle: Text('Select from your photo library', 
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage();
                  },
                ),
                
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.green),
                  ),
                  title: Text('Take Photo', style: TextStyle(color: textColor)),
                  subtitle: Text('Use your camera to take a new photo',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  onTap: () {
                    Navigator.of(context).pop();
                    _takePhoto();
                  },
                ),
                
                if (_profilePicturePath != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    title: const Text('Remove Photo',
                        style: TextStyle(color: Colors.red)),
                    subtitle: Text('Remove current profile picture',
                      style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
                    onTap: () {
                      Navigator.of(context).pop();
                      _removeProfilePicture();
                    },
                  ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Settings',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save profile changes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: const Color(0xFFF8BBD9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Enhanced Profile Picture Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                        child: _isUpdatingPhoto
                            ? const CircularProgressIndicator(
                                color: Color(0xFFF8BBD9),
                                strokeWidth: 3,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: _profilePicturePath != null
                                    ? Image.file(
                                        File(_profilePicturePath!),
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            color: isDark ? Colors.white : Colors.grey[600],
                                            size: 60,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/navbar/profile-1.png',
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            color: isDark ? Colors.white : Colors.grey[600],
                                            size: 60,
                                          );
                                        },
                                      ),
                              ),
                      ),
                      if (!_isUpdatingPhoto)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8BBD9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cardColor,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _isUpdatingPhoto ? null : _showImageSourceDialog,
                    child: Text(
                      _isUpdatingPhoto ? 'Updating...' : 'Change Profile Picture',
                      style: TextStyle(
                        color: _isUpdatingPhoto 
                            ? (isDark ? Colors.grey[400] : Colors.grey[600])
                            : const Color(0xFFF8BBD9),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to update your profile photo (max 2MB)',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Personal Information Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Medical Information Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Blood Type
                  DropdownButtonFormField<String>(
                    value: _selectedBloodType,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Blood Type',
                      labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      prefixIcon: Icon(
                        Icons.bloodtype,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                      ),
                    ),
                    dropdownColor: cardColor,
                    items: _bloodTypes.map((String bloodType) {
                      return DropdownMenuItem<String>(
                        value: bloodType,
                        child: Text(
                          bloodType,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBloodType = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Current Week
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Current Week: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$_currentWeek weeks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF8BBD9),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Due Date
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Due Date: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF8BBD9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Emergency Contact Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emergencyContactController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Emergency Contact Number',
                      labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      prefixIcon: const Icon(
                        Icons.emergency,
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFF8BBD9)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an emergency contact number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}