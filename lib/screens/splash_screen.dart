import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../admin/admin_auth_provider.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = FirebaseAuth.instance.currentUser;
    
    if (!mounted) return;

    if (user != null) {
      // Check if user is admin
      final adminAuth = Provider.of<AdminAuthProvider>(context, listen: false);
      if (adminAuth.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminProducts);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
