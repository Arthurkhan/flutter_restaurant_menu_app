import 'package:flutter/material.dart';

/// Admin dashboard screen for managing menus
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('This screen is under development'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to menu editor
                Navigator.pushNamed(context, '/admin/menu');
              },
              child: const Text('Create New Menu'),
            ),
          ],
        ),
      ),
    );
  }
}