import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('${AppConstants.appName} - Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text(
              user != null ? 'Logged In as ${user.email}' : 'Not Logged In',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Back to Home'),
            ),
            if (user != null)
              ElevatedButton(
                onPressed: () async {
                  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                  await orderProvider.clearOrders();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            if (user == null)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Login'),
              ),
          ],
        ),
      ),
    );
  }
}