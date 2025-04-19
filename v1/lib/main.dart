import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/loginpage.dart';
import 'screens/signuppage.dart';
import 'screens/homepage.dart';
import 'screens/profile.dart';
import 'screens/orders_in_progress.dart';
import 'constants.dart';
import 'models/sample_model.dart';
import 'services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final orderService = OrderService();
  await orderService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderProvider(orderService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/orders_in_progress': (context) => const OrdersInProgressPage(),
      },
    );
  }
}

class OrderProvider with ChangeNotifier {
  final OrderService _orderService;

  OrderProvider(this._orderService);

  Future<List<Order>> getInProgressOrders({OrderStatus? status}) async {
    return await _orderService.getInProgressOrders(status: status);
  }

  Future<void> addOrder(Order order) async {
    await _orderService.addOrder(order);
    notifyListeners();
  }

  Future<void> clearOrders() async {
    await _orderService.clearOrders();
    notifyListeners();
  }
}