import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

/// Authentication Provider - Manages user authentication state
/// Connects to the same backend API as the web app
class AuthProvider extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
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

      // Mock successful login
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = {
        'id': 1,
        'email': email,
        'first_name': 'Demo',
        'last_name': 'User',
        'user_type': _getUserTypeFromEmail(email),
        'created_at': DateTime.now().toIso8601String(),
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

      // Mock successful registration - DO NOT auto-login
      // In a real app, this would create the account on the server
      // but not return authentication tokens

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
