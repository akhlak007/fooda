import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  AppUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAdmin = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _isAdmin;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _checkAdminStatus() async {
    if (_user == null) {
      _isAdmin = false;
      return;
    }

    try {
      // Get user's custom claims
      final idTokenResult =
          await FirebaseAuth.instance.currentUser?.getIdTokenResult();
      _isAdmin = idTokenResult?.claims?['admin'] == true;

      // If no admin claim, check email domain as fallback
      if (!_isAdmin) {
        _isAdmin =
            FirebaseAuth.instance.currentUser?.email?.endsWith('@admin.com') ??
                false;
      }
    } catch (e) {
      print('Error checking admin status: $e');
      _isAdmin = false;
    }
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _isAdmin = false;
    } else {
      final userDoc = await _firestoreService.getUser(firebaseUser.uid);
      if (userDoc != null) {
        _user = userDoc;
      } else {
        _user = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          phone: firebaseUser.phoneNumber ?? '',
          address: '',
        );
        await _firestoreService.updateUser(_user!);
      }
      await _checkAdminStatus();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.signIn(email, password);
      await _checkAdminStatus();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
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

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _authService.register(email, password);
      if (user != null) {
        await _authService.updateProfile(displayName: name);
        final appUser = AppUser(
          id: user.uid,
          email: email,
          displayName: name,
          phone: user.phoneNumber ?? '',
          address: '',
        );
        await _firestoreService.updateUser(appUser);
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginAsGuest() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.signInAnonymously();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }
}
