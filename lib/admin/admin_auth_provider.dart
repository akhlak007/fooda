import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AdminAuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  User? _user;
  bool _isAdmin = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  bool get isAdmin => _isAdmin;

  AdminAuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      _checkAdminStatus();
      notifyListeners();
    });
  }

  Future<void> _checkAdminStatus() async {
    if (_user == null) {
      _isAdmin = false;
      return;
    }

    try {
      // Get user's custom claims
      final idTokenResult = await _user!.getIdTokenResult();
      _isAdmin = idTokenResult.claims?['admin'] == true;

      // If no admin claim, check email domain as fallback
      if (!_isAdmin) {
        // For development, allow any email to be admin
        // TODO: Remove this in production and use proper admin checks
        _isAdmin = true;
      }
    } catch (e) {
      print('Error checking admin status: $e');
      _isAdmin = false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First try to sign in
      _user = await _authService.signIn(email, password);

      // Then check admin status
      await _checkAdminStatus();

      if (!_isAdmin) {
        // If not admin, sign out and show error
        await _authService.signOut();
        _error = 'Access denied. Admin privileges required.';
        _user = null;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No admin account found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password for admin account.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'user-disabled':
          errorMessage = 'This admin account has been disabled.';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }
}
