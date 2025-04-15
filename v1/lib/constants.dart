import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF041501);
  static const Color accentColor = Color(0xFF1F9005);
  static const Color darkAccentColor = Color(0xFF3DAFAB);

  // Background colors
  static const Color backgroundColor = Color(0xFFF0F4F8);
  static const Color cardBackgroundColor =
      Color(0x99FFFFFF); // Semi-transparent white for glassmorphic effect

  // Text colors
  static const Color primaryTextColor = Color(0xFF2B2D42);
  static const Color secondaryTextColor = Color(0xFF8D99AE);
  static const Color lightTextColor = Color(0xFFFFFFFF);

  // Status colors
  static const Color successColor = Color(0xFF2EC4B6);
  static const Color warningColor = Color(0xFFFFD166);
  static const Color errorColor = Color(0xFFEF476F);

  // Glassmorphic colors
  static const Color glassBorderColor = Color(0x40FFFFFF);
  static const Color glassShadowColor = Color(0x26000000);
}

class AppDimensions {
  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusXL = 32.0;

  // Padding and margin
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXL = 32.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXL = 48.0;

  // Button heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  // Card dimensions
  static const double cardElevation = 8.0;
  static const double cardBlur = 12.0;
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryTextColor,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryTextColor,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryTextColor,
    height: 1.5,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextColor,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryTextColor,
    height: 1.4,
  );
}

class AppAssets {
  // Icons
  static const String mapIcon = 'assets/icons/map_icon.png';
  static const String addOrderIcon = 'assets/icons/add_order_icon.png';
  static const String offersIcon = 'assets/icons/offers_icon.png';
  static const String profileIcon = 'assets/icons/profile_icon.png';
  static const String notificationIcon = 'assets/icons/notification_icon.png';

  // Images
  static const String appLogo = 'assets/images/logo.jpg';
  static const String backgroundPattern = 'assets/images/pattern.png';
}

class AppStrings {
  static const String appName = 'Order map';
  static const String homeTitle = 'Dashboard';
  static const String addOrderButton = 'Add Order to Map';
  static const String viewOffersButton = 'See Available Offers';
  static const String recentOrdersTitle = 'Recent Orders';
  static const String noOrdersMessage = 'No recent orders found';
  static const String welcomeMessage = 'Welcome back, ';
  static const String pendingOrdersLabel = 'Pending Orders';
  static const String completedOrdersLabel = 'Completed';
  static const String viewAllButton = 'View All';
}
