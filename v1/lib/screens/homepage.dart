import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../data/sample_data.dart';
import '../main.dart';
import '../models/sample_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final orderProvider = Provider.of<OrderProvider>(context);
    final List<Order> orders = getSampleOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('${AppConstants.appName} - Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_shipping),
            onPressed: () {
              Navigator.pushNamed(context, '/orders_in_progress');
            },
            tooltip: 'Orders in Progress',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            tooltip: 'Profile',
          ),
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await orderProvider.clearOrders();
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              tooltip: 'Logout',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user != null ? user.email ?? "User" : "Guest"}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user != null ? 'Your Orders' : 'Browse Orders',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text('No orders available'))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.shopping_cart),
                            title: Text(order.title),
                            subtitle: Text('Amount: \$${order.amount.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Details for ${order.title}')),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlaceOrderMapPage(),
            ),
          );
        },
        tooltip: 'Place Order',
        child: const Icon(Icons.add_location),
      ),
    );
  }
}

class PlaceOrderMapPage extends StatefulWidget {
  const PlaceOrderMapPage({super.key});

  @override
  State<PlaceOrderMapPage> createState() => _PlaceOrderMapPageState();
}

class _PlaceOrderMapPageState extends State<PlaceOrderMapPage> {
  bool _isLocationSelected = false;
  double _latitude = 37.7749;
  double _longitude = -122.4194;

  Future<void> _simulateGetCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _latitude = 37.7749;
      _longitude = -122.4194;
    });
  }

  void _simulateSelectLocation() {
    setState(() {
      _isLocationSelected = true;
      _latitude = 37.78 + (DateTime.now().millisecond / 10000);
      _longitude = -122.41 + (DateTime.now().millisecond / 10000);
    });
  }

  @override
  void initState() {
    super.initState();
    _simulateGetCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order (Simulated Map)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Simulated Map Interface',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This is a placeholder for the Google Maps interface.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Current Location: Lat: $_latitude, Lng: $_longitude',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _simulateSelectLocation();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location selected')),
                );
              },
              child: const Text('Select Location on Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLocationSelected
                  ? () async {
                      final newOrder = Order(
                        id: DateTime.now().toString(),
                        userId: user?.uid ?? 'anonymous',
                        title: 'Order ${await orderProvider.getInProgressOrders().then((orders) => orders.length + 1)}',
                        amount: 49.99,
                        latitude: _latitude,
                        longitude: _longitude,
                        status: OrderStatus.unpicked,
                      );
                      if (user != null) {
                        await orderProvider.addOrder(newOrder);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed successfully!')),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/login',
                          arguments: newOrder,
                        );
                      }
                    }
                  : null,
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}