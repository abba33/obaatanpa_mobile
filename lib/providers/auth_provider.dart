import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

/// Authentication Provider - Manages user authentication state
/// Connects to the same backend API as the web app
class AuthProvider extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _signupDataKey = 'signup_data';
  // Standalone mode - no backend required

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  Map<String, dynamic>? _user;
  String? _error;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  String? get error => _error;
  String? get userType => _user?['user_type'];
  String? get userId => _user?['id']?.toString();
  String? get userEmail => _user?['email'];
  String? get userName =>
      '${_user?['first_name'] ?? ''} ${_user?['last_name'] ?? ''}'.trim();
  String? get profilePicture => _user?['profile_picture'];

  AuthProvider() {
    _initializeAuth();
  }

  /// Auto-login for testing purposes
  Future<void> autoLoginForTesting() async {
    _token = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
    _user = {
      'id': 1,
      'email': 'abba@test.com',
      'first_name': 'Abba',
      'last_name': 'Test',
      'user_type': 'pregnant',
      'created_at': DateTime.now().toIso8601String(),
    };
    _isAuthenticated = true;

    // Store auth data securely
    await _storage.write(key: _tokenKey, value: _token);
    await _storage.write(key: _userKey, value: json.encode(_user));

    notifyListeners();
  }

  /// Initialize authentication state from stored data
  Future<void> _initializeAuth() async {
    try {
      _setLoading(true);

      final token = await _storage.read(key: _tokenKey);
      final userData = await _storage.read(key: _userKey);

      if (token != null && userData != null) {
        _token = token;
        _user = json.decode(userData);
        _isAuthenticated = true;

        // Verify token is still valid
        await _verifyToken();
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  /// Verify if stored token is still valid (mock implementation)
  Future<void> _verifyToken() async {
    try {
      // Mock verification - always valid for demo
      await Future.delayed(const Duration(milliseconds: 500));
      // Token is always valid in standalone mode
    } catch (e) {
      debugPrint('Error verifying token: $e');
      await _clearAuthData();
    }
  }

  /// Login user with email and password (mock implementation)
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      // Mock API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        _setError('Please enter both email and password');
        return false;
      }

      if (password.length < 6) {
        _setError('Password must be at least 6 characters');
        return false;
      }

      // Retrieve signup data
      final signupDataString = await _storage.read(key: _signupDataKey);
      Map<String, dynamic>? signupData;

      if (signupDataString != null) {
        try {
          signupData = json.decode(signupDataString);
        } catch (e) {
          debugPrint('Error parsing signup data: $e');
        }
      }

      // Mock successful login
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Use actual signup data if available, otherwise fallback to email extraction
      String firstName, lastName, userType;

      if (signupData != null && signupData['email'] == email) {
        firstName = signupData['firstName'] ?? 'User';
        lastName = signupData['lastName'] ?? '';
        userType = signupData['userType'] ?? 'pregnant';
      } else {
        // Fallback: extract from email if no signup data found
        final username = email.split('@').first;
        firstName = _capitalizeUsername(username);
        lastName = '';
        userType = _getUserTypeFromEmail(email);
      }

      _user = {
        'id': 1,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'user_type': userType,
        'created_at':
            signupData?['createdAt'] ?? DateTime.now().toIso8601String(),
        'profile_picture': signupData?['profilePicture'] ?? null,
      };
      _isAuthenticated = true;

      // Store auth data securely
      await _storage.write(key: _tokenKey, value: _token);
      await _storage.write(key: _userKey, value: json.encode(_user));

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Login error occurred');
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Capitalize username properly
  String _capitalizeUsername(String username) {
    if (username.isEmpty) return 'User';

    // Handle common separators and capitalize each part
    final parts = username.split(RegExp(r'[._-]'));
    final capitalizedParts = parts.map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    }).toList();

    return capitalizedParts.join(' ');
  }

  /// Determine user type from email for demo purposes
  String _getUserTypeFromEmail(String email) {
    if (email.contains('pregnant') || email.contains('mother')) {
      return 'pregnant';
    } else if (email.contains('new') || email.contains('baby')) {
      return 'new_mother';
    } else if (email.contains('doctor') || email.contains('practitioner')) {
      return 'practitioner';
    }
    return 'pregnant'; // Default
  }

  /// Register new user (mock implementation)
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Mock API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation
      if (email.isEmpty ||
          password.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty) {
        _setError('Please fill in all required fields');
        return false;
      }

      if (password.length < 6) {
        _setError('Password must be at least 6 characters');
        return false;
      }

      if (!email.contains('@')) {
        _setError('Please enter a valid email address');
        return false;
      }

      // Mock successful registration - auto-login
      return await login(email, password);
    } catch (e) {
      _setError('Registration error occurred');
      debugPrint('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user without auto-login (mock implementation)
  Future<bool> registerWithoutLogin({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Mock API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation
      if (email.isEmpty ||
          password.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty) {
        _setError('Please fill in all required fields');
        return false;
      }

      if (password.length < 6) {
        _setError('Password must be at least 6 characters');
        return false;
      }

      if (!email.contains('@')) {
        _setError('Please enter a valid email address');
        return false;
      }

      // Store signup data for later login
      final signupData = {
        'email': email,
        'password': password, // In real app, this would be hashed
        'firstName': firstName,
        'lastName': lastName,
        'userType': userType,
        'additionalData': additionalData,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _storage.write(key: _signupDataKey, value: json.encode(signupData));

      debugPrint('Mock account created for: $email');
      debugPrint('User type: $userType');
      debugPrint('Name: $firstName $lastName');
      debugPrint('Additional data: $additionalData');

      return true; // Account created successfully
    } catch (e) {
      _setError('Registration error occurred');
      debugPrint('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user (mock implementation)
  Future<void> logout() async {
    try {
      _setLoading(true);

      // Mock API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear all data
      await _clearAuthData();
    } catch (e) {
      debugPrint('Logout error: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile picture
  Future<void> updateProfilePicture(String? imagePath) async {
    if (_user != null) {
      _user!['profile_picture'] = imagePath;

      // Update stored user data
      await _storage.write(key: _userKey, value: json.encode(_user));

      // Also update signup data if it exists
      final signupDataString = await _storage.read(key: _signupDataKey);
      if (signupDataString != null) {
        try {
          final signupData = json.decode(signupDataString);
          signupData['profilePicture'] = imagePath;
          await _storage.write(
              key: _signupDataKey, value: json.encode(signupData));
        } catch (e) {
          debugPrint('Error updating signup data: $e');
        }
      }

      notifyListeners();
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    _token = null;
    _user = null;
    _isAuthenticated = false;

    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);

    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Get authorization headers for API calls
  Map<String, String> get authHeaders => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };

  /// Check if user has specific role
  bool hasRole(String role) {
    return userType == role;
  }

  /// Check if user is pregnant mother
  bool get isPregnantMother => hasRole('pregnant');

  /// Check if user is new mother
  bool get isNewMother => hasRole('new_mother');

  /// Check if user is health practitioner
  bool get isHealthPractitioner => hasRole('practitioner');
}
