import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/sample_model.dart';
import '../main.dart';

class OrdersInProgressPage extends StatefulWidget {
  const OrdersInProgressPage({super.key});

  @override
  State<OrdersInProgressPage> createState() => _OrdersInProgressPageState();
}

class _OrdersInProgressPageState extends State<OrdersInProgressPage> {
  OrderStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${AppConstants.appName} - Orders in Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Orders in Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<OrderStatus?>(
                  value: _filterStatus,
                  hint: const Text('Filter by Status'),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All Orders'),
                    ),
                    DropdownMenuItem(
                      value: OrderStatus.picked,
                      child: Text('Picked'),
                    ),
                    DropdownMenuItem(
                      value: OrderStatus.unpicked,
                      child: Text('Unpicked'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterStatus = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: orderProvider.getInProgressOrders(status: _filterStatus),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading orders'));
                  }
                  final inProgressOrders = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Showing ${inProgressOrders.length} order${inProgressOrders.length == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: inProgressOrders.isEmpty
                            ? const Center(child: Text('No orders match the filter'))
                            : ListView.builder(
                                itemCount: inProgressOrders.length,
                                itemBuilder: (context, index) {
                                  final order = inProgressOrders[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.local_shipping,
                                        color: order.status == OrderStatus.unpicked
                                            ? Colors.green
                                            : null,
                                      ),
                                      title: Text(order.title),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Amount: \$${order.amount.toStringAsFixed(2)}'),
                                          Text('Location: Lat: ${order.latitude}, Lng: ${order.longitude}'),
                                          Text('Status: ${order.status.name}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}