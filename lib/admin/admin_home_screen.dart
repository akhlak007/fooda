import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DashboardTile(
              icon: Icons.people_outline,
              label: 'User List',
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, AppRoutes.adminUsers),
            ),
            const SizedBox(height: 24),
            _DashboardTile(
              icon: Icons.fastfood,
              label: 'Products',
              color: Colors.green,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.adminProducts),
            ),
            const SizedBox(height: 24),
            _DashboardTile(
              icon: Icons.receipt_long,
              label: 'Orders',
              color: Colors.deepOrange,
              onTap: () => Navigator.pushNamed(context, AppRoutes.adminOrders),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            const SizedBox(width: 24),
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 32),
            Text(
              label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
