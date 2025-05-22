import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../admin/admin_auth_provider.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAdminMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_isAdminMode) {
        final adminAuth =
            Provider.of<AdminAuthProvider>(context, listen: false);
        final success = await adminAuth.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (success && mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.adminProducts);
        } else if (adminAuth.error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(adminAuth.error!)),
          );
        }
      } else {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (success && mounted) {
          if (authProvider.isAdmin) {
            Navigator.pushReplacementNamed(context, AppRoutes.adminProducts);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        } else if (authProvider.error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error!)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final adminAuth = Provider.of<AdminAuthProvider>(context);
    final isLoading =
        _isAdminMode ? adminAuth.isLoading : authProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  label: Text('User Login'),
                  icon: Icon(Icons.person),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Admin Login'),
                  icon: Icon(Icons.admin_panel_settings),
                ),
              ],
              selected: {_isAdminMode},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _isAdminMode = newSelection.first;
                });
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isAdminMode ? Icons.admin_panel_settings : Icons.person,
                  size: 64,
                  color: _isAdminMode
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter your email'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter your password'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAdminMode ? Colors.red : null,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text(_isAdminMode ? 'Admin Login' : 'Login'),
                  ),
                ),
                if (!_isAdminMode) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                    child: const Text('Don\'t have an account? Sign up'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
