import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication Provider - Manages user authentication state
/// Connects to the Obaatanpa backend API
class AuthProvider extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _firstNameKey = 'firstName'; // Key for SharedPreferences

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
  String? get userType => _user?['userType'];
  String? get userId => _user?['id']?.toString();
  String? get userEmail => _user?['email'];
  String? get userName =>
      '${_user?['firstName'] ?? ''} ${_user?['lastName'] ?? ''}'.trim();
  
  // ADD THIS: Missing profilePicture getter
  String? get profilePicture => _user?['profilePicture'];

  AuthProvider() {
    _initializeAuth();
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

  /// Verify if stored token is still valid
  Future<void> _verifyToken() async {
    try {
      // Implement token verification if the backend provides an endpoint
      // For now, assume token is valid as per web implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('Error verifying token: $e');
      await _clearAuthData();
    }
  }

  /// Login user with email and password
  Future<bool> login(String email, String password, String userType) async {
    try {
      _setLoading(true);
      _clearError();

      // Determine login endpoint based on user type
      final loginEndpoint = userType == 'hospital'
          ? 'https://obaatanpa-backend.onrender.com/health_facility/login'
          : userType == 'practitioner'
              ? 'https://obaatanpa-backend.onrender.com/health_worker/login'
              : 'https://obaatanpa-backend.onrender.com/login';

      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        _token = result['token'];
        _user = {
          'email': email,
          'userType': userType,
          'isAuthenticated': true,
          'loginDate': DateTime.now().toIso8601String(),
          'firstName': result['first_name'] ?? result['firstName'] ?? '', // Retrieve first name
        };

        if (userType == 'hospital') {
          if (result['hospital_id'] != null) {
            _user!['hospital_id'] = result['hospital_id'];
          }
          if (result['hospital_name'] != null) {
            _user!['hospital_name'] = result['hospital_name'];
          }
        } else if (userType == 'practitioner') {
          if (result['id'] != null) {
            _user!['id'] = result['id'];
          }
          _user!['fullName'] = result['fullName'] ?? result['firstName'] ?? 'Health Practitioner';
          _user!['practitionerType'] = result['practitionerType'] ?? 'Doctor';
          _user!['specialization'] = result['specialization'] ?? 'General Practice';
          _user!['licenseNumber'] = result['licenseNumber'] ?? '';
          _user!['hospital'] = result['hospital'] ?? 'Unknown Hospital';
          _user!['hospitalId'] = result['hospitalId'] ?? '';
          _user!['verificationStatus'] = result['verificationStatus'] ?? 'pending';
          _user!['profilePicture'] = result['profilePicture'] ?? '';
          _user!['phoneNumber'] = result['phoneNumber'] ?? '';
          _user!['yearsOfExperience'] = result['yearsOfExperience'] ?? 0;
          _user!['qualifications'] = result['qualifications'] ?? [];
        } else {
          _user!['care_type'] = result['care_type'];
          _user!['language'] = result['language'];
        }

        _isAuthenticated = true;

        // Store auth data securely
        await _storage.write(key: _tokenKey, value: _token);
        await _storage.write(key: _userKey, value: json.encode(_user));

        // Store first name in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_firstNameKey, _user!['firstName'] ?? '');

        notifyListeners();
        debugPrint('AuthProvider: Login successful for userType=$userType, firstName=${_user!['firstName']}');
        return true;
      } else {
        _setError(result['message'] ?? 'Login failed. Please try again.');
        return false;
      }
    } catch (e) {
      _setError('Error connecting to backend: ${e.toString()}');
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
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

      // Prepare payload based on user type
      Map<String, dynamic> payload;
      String registerEndpoint;

      if (userType == 'hospital') {
        payload = {
          'name': additionalData?['name'] ?? '',
          'email': email,
          'password': password,
        };
        registerEndpoint =
            'https://obaatanpa-backend.onrender.com/health_facility/signup';
      } else if (userType == 'practitioner') {
        payload = {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'hospital_name': additionalData?['workplace'] ?? '',
        };
        registerEndpoint =
            'https://obaatanpa-backend.onrender.com/health_worker/signup';
      } else {
        payload = {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'care_type': userType == 'pregnant' ? 'prenatal' : 'postnatal',
          'dob': additionalData?['dob'] ?? '',
          'password': password,
          'language': additionalData?['language'] ?? '',
        };
        registerEndpoint = 'https://obaatanpa-backend.onrender.com/signup';
      }

      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Store first name in SharedPreferences immediately after registration
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_firstNameKey, firstName);

        // Registration successful, but requires verification
        // Do not auto-login; instead, wait for verification
        debugPrint('Registration successful: ${result['message']}, firstName=$firstName');
        return true;
      } else {
        _setError(result['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Error connecting to backend: ${e.toString()}');
      debugPrint('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ADD THIS: Missing registerWithoutLogin method
  Future<bool> registerWithoutLogin({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
    Map<String, dynamic>? additionalData,
  }) async {
    // This method registers without automatically logging in
    // Similar to register but doesn't set authentication state
    try {
      _setLoading(true);
      _clearError();

      // Use the same registration logic but don't authenticate
      final success = await register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        userType: userType,
        additionalData: additionalData,
      );

      return success;
    } catch (e) {
      _setError('Registration error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ADD THIS: Missing autoLoginForTesting method
  Future<void> autoLoginForTesting() async {
    try {
      _setLoading(true);
      _clearError();

      // For testing purposes - create a mock authenticated state
      _token = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
      _user = {
        'id': 'test_user_id',
        'email': 'test@example.com',
        'firstName': 'Test',
        'lastName': 'User',
        'userType': 'practitioner',
        'fullName': 'Test User',
        'practitionerType': 'Doctor',
        'specialization': 'General Practice',
        'hospital': 'Test Hospital',
        'verificationStatus': 'verified',
        'profilePicture': null,
        'isAuthenticated': true,
        'loginDate': DateTime.now().toIso8601String(),
      };

      _isAuthenticated = true;

      // Store test data
      await _storage.write(key: _tokenKey, value: _token);
      await _storage.write(key: _userKey, value: json.encode(_user));

      // Store first name in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_firstNameKey, _user!['firstName'] ?? '');

      notifyListeners();
      debugPrint('Auto login for testing completed');
    } catch (e) {
      debugPrint('Auto login for testing error: $e');
      _setError('Auto login for testing failed');
    } finally {
      _setLoading(false);
    }
  }

  // ADD THIS: Missing updateProfilePicture method
  Future<bool> updateProfilePicture(String? imagePath) async {
    try {
      _setLoading(true);
      _clearError();

      if (_user != null) {
        // Update the user data
        _user!['profilePicture'] = imagePath;

        // Store updated user data
        await _storage.write(key: _userKey, value: json.encode(_user));

        notifyListeners();
        debugPrint('Profile picture updated: $imagePath');
        return true;
      } else {
        _setError('No user data available');
        return false;
      }
    } catch (e) {
      _setError('Error updating profile picture: ${e.toString()}');
      debugPrint('Update profile picture error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify user account with verification code
  Future<bool> verifyAccount({
    required String email,
    required String verificationCode,
    required String userType,
    Map<String, dynamic>? practitionerData,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final verifyEndpoint = userType == 'hospital'
          ? 'https://obaatanpa-backend.onrender.com/health_facility/verify'
          : userType == 'practitioner'
              ? 'https://obaatanpa-backend.onrender.com/health_worker/verify'
              : 'https://obaatanpa-backend.onrender.com/verify';

      final payload = {
        'email': email,
        'verification_code': verificationCode,
      };

      final response = await http.post(
        Uri.parse(verifyEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (userType == 'practitioner') {
          // Construct practitioner user data
          _user = {
            'id': result['id'] ?? 'temp-id-${DateTime.now().millisecondsSinceEpoch}',
            'fullName': practitionerData?['fullName'] ?? 'Unknown',
            'email': email,
            'userType': userType,
            'practitionerType': practitionerData?['practitionerType'] ?? 'General Practitioner',
            'specialization': practitionerData?['specialization'] ?? 'General',
            'licenseNumber': practitionerData?['licenseNumber'] ?? '',
            'hospital': practitionerData?['hospital'] ?? 'Unknown',
            'hospitalId': practitionerData?['hospitalId'] ?? 'unknown-hospital-id',
            'verificationStatus': 'verified',
            'profilePicture': practitionerData?['profilePicture'],
            'phoneNumber': practitionerData?['phoneNumber'],
            'yearsOfExperience': practitionerData?['yearsOfExperience'],
            'qualifications': practitionerData?['qualifications'],
            'isAuthenticated': true,
            'loginDate': DateTime.now().toIso8601String(),
            'firstName': practitionerData?['firstName'] ?? 'Unknown', // Ensure firstName is set
          };

          _isAuthenticated = true;

          // Store user data securely
          await _storage.write(key: _userKey, value: json.encode(_user));

          // Store first name in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_firstNameKey, _user!['firstName'] ?? '');
        }
        // For other user types, verification may lead to login prompt (handled in UI)
        debugPrint('Verification successful: ${result['message']}');
        return true;
      } else {
        _setError(result['message'] ?? 'Verification failed');
        return false;
      }
    } catch (e) {
      _setError('Error verifying account: ${e.toString()}');
      debugPrint('Verification error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _setLoading(true);

      // Clear all data, including SharedPreferences first name
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

    // Clear first name from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstNameKey);

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

  /// Check if user is hospital
  bool get isHospital => hasRole('hospital');
}