import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'constants.dart';

// Order model class for state management
class Order {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isPending;

  Order({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isPending,
  });
}

// Order provider for state management
class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  int _pendingOrdersCount = 0;
  int _completedOrdersCount = 0;
  
  List<Order> get orders => _orders;
  int get pendingOrdersCount => _pendingOrdersCount;
  int get completedOrdersCount => _completedOrdersCount;
  
  void addOrder(Order order) {
    _orders.add(order);
    if (order.isPending) {
      _pendingOrdersCount++;
    } else {
      _completedOrdersCount++;
    }
    notifyListeners();
  }
  
  void updateOrderStatus(String id, bool isPending) {
    final orderIndex = _orders.indexWhere((order) => order.id == id);
    if (orderIndex != -1) {
      final oldOrder = _orders[orderIndex];
      if (oldOrder.isPending != isPending) {
        if (isPending) {
          _pendingOrdersCount++;
          _completedOrdersCount--;
        } else {
          _pendingOrdersCount--;
          _completedOrdersCount++;
        }
        
        _orders[orderIndex] = Order(
          id: oldOrder.id,
          title: oldOrder.title,
          description: oldOrder.description,
          createdAt: oldOrder.createdAt,
          isPending: isPending,
        );
        
        notifyListeners();
      }
    }
  }
  
  // Sample data for preview
  void loadSampleData() {
    _orders = [
      Order(
        id: '1',
        title: 'Grocery Order #1',
        description: 'Fresh vegetables and fruits needed',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isPending: true,
      ),
      Order(
        id: '2',
        title: 'Electronics Order #42',
        description: 'Phone accessories stock needed',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isPending: true,
      ),
      Order(
        id: '3',
        title: 'Bakery Order #15',
        description: 'Flour and sugar supplies',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isPending: false,
      ),
    ];
    
    _pendingOrdersCount = _orders.where((order) => order.isPending).length;
    _completedOrdersCount = _orders.where((order) => !order.isPending).length;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final String shopkeeperName = "Alex"; // In a real app, this would come from auth
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    
    // Load sample data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).loadSampleData();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAddOrder() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network request
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to add order screen (would be implemented in a real app)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigating to Add Order screen"))
      );
    });
  }
  
  void _handleViewOffers() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network request
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to offers screen (would be implemented in a real app)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Navigating to Offers screen"))
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.9),
                      AppColors.accentColor.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              
              // Background pattern
              Opacity(
                opacity: 0.05,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.backgroundPattern),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
              
              // Main content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App bar
                      _buildAppBar(),
                      
                      const SizedBox(height: AppDimensions.paddingLarge),
                      
                      // Welcome message
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOut,
                        )),
                        child: FadeTransition(
                          opacity: _animationController,
                          child: Text(
                            '${AppStrings.welcomeMessage}$shopkeeperName!',
                            style: AppTextStyles.heading1,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppDimensions.paddingMedium),
                      
                      // Stats cards
                      _buildStatsCards(orderProvider),
                      
                      const SizedBox(height: AppDimensions.paddingLarge),
                      
                      // Action buttons
                      _buildActionButtons(),
                      
                      const SizedBox(height: AppDimensions.paddingLarge),
                      
                      // Recent orders
                      _buildRecentOrders(orderProvider),
                    ],
                  ),
                ),
              ),
              
              // Loading indicator
              if (_isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              AppAssets.appLogo,
              height: AppDimensions.iconSizeLarge,
            ),
            const SizedBox(width: AppDimensions.paddingSmall),
            Text(
              AppStrings.appName,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildGlassIconButton(
              icon: const Icon(Icons.notifications_outlined, 
                color: AppColors.primaryTextColor),
              onPressed: () {},
            ),
            const SizedBox(width: AppDimensions.paddingSmall),
            _buildGlassIconButton(
              icon: const Icon(Icons.person_outline, 
                color: AppColors.primaryTextColor),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildGlassIconButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.cardBlur,
          sigmaY: AppDimensions.cardBlur,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundColor,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              border: Border.all(
                color: AppColors.glassBorderColor,
                width: 1.5,
              ),
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatsCards(OrderProvider orderProvider) {
    return FadeTransition(
      opacity: _animationController,
      child: Row(
        children: [
          _buildStatsCard(
            title: AppStrings.pendingOrdersLabel,
            count: orderProvider.pendingOrdersCount,
            color: AppColors.warningColor,
            icon: Icons.pending_actions,
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          _buildStatsCard(
            title: AppStrings.completedOrdersLabel,
            count: orderProvider.completedOrdersCount,
            color: AppColors.successColor,
            icon: Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppDimensions.cardBlur,
            sigmaY: AppDimensions.cardBlur,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundColor,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              border: Border.all(
                color: AppColors.glassBorderColor,
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.glassShadowColor,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall / 2),
                    Text(
                      count.toString(),
                      style: AppTextStyles.heading2,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: AppDimensions.iconSizeSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 1.0),
        ),
        child: Column(
          children: [
            _buildGlassButton(
              label: AppStrings.addOrderButton,
              icon: Icons.add_location_alt,
              onPressed: _handleAddOrder,
              isPrimary: true,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            _buildGlassButton(
              label: AppStrings.viewOffersButton,
              icon: Icons.store,
              onPressed: _handleViewOffers,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGlassButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.cardBlur,
          sigmaY: AppDimensions.cardBlur,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: isPrimary 
                    ? AppColors.primaryColor.withOpacity(0.8)
                    : AppColors.cardBackgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                border: Border.all(
                  color: isPrimary
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : AppColors.glassBorderColor,
                  width: 1.5,
                ),
                boxShadow: [
                  const BoxShadow(
                    color: AppColors.glassShadowColor,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isPrimary 
                        ? AppColors.lightTextColor
                        : AppColors.primaryColor,
                    size: AppDimensions.iconSizeMedium,
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Text(
                    label,
                    style: AppTextStyles.buttonText.copyWith(
                      color: isPrimary 
                          ? AppColors.lightTextColor
                          : AppColors.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentOrders(OrderProvider orderProvider) {
    return Expanded(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        )),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.5, 1.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppDimensions.cardBlur,
                sigmaY: AppDimensions.cardBlur,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  border: Border.all(
                    color: AppColors.glassBorderColor,
                    width: 1.5,
                  ),
                  boxShadow: [
                    const BoxShadow(
                      color: AppColors.glassShadowColor,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.recentOrdersTitle,
                          style: AppTextStyles.heading3,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.viewAllButton,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Expanded(
                      child: orderProvider.orders.isEmpty
                          ? Center(
                              child: Text(
                                AppStrings.noOrdersMessage,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: orderProvider.orders.length,
                              separatorBuilder: (context, index) => const Divider(
                                height: AppDimensions.paddingMedium * 2,
                                color: AppColors.glassBorderColor,
                              ),
                              itemBuilder: (context, index) {
                                final order = orderProvider.orders[index];
                                return _buildOrderItem(order);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildOrderItem(Order order) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
          decoration: BoxDecoration(
            color: order.isPending
                ? AppColors.warningColor.withOpacity(0.2)
                : AppColors.successColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          ),
          child: Icon(
            order.isPending ? Icons.pending : Icons.check_circle,
            color: order.isPending ? AppColors.warningColor : AppColors.successColor,
            size: AppDimensions.iconSizeMedium,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall / 2),
              Text(
                order.description,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.paddingSmall / 2),
              Text(
                _formatOrderTime(order.createdAt),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  String _formatOrderTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

// Main implementation
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        home: const HomePage(),
      ),
    ),
  );
}