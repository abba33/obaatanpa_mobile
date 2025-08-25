import 'package:flutter/material.dart';

/// User Provider - Manages user profile data and preferences
/// Simplified version for initial setup
class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic>? _profile;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get profile => _profile;
  String? get error => _error;

  // Placeholder methods for now
  Future<void> fetchUserProfile(String userId, String token) async {
    _setLoading(true);
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearUserData() {
    _profile = null;
    _error = null;
    notifyListeners();
  }
}
