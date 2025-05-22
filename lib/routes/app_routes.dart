import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/cart/checkout_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/orders/order_confirmation_screen.dart';
import '../screens/orders/order_status_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../admin/admin_login_screen.dart';
import '../admin/product_list_screen.dart';
import '../admin/product_form_screen.dart';
import '../admin/user_list_screen.dart';
import '../admin/admin_orders_screen.dart';
import '../admin/admin_home_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const product = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const profile = '/profile';
  static const editProfile = '/edit_profile';
  static const orderConfirmation = '/order_confirmation';
  static const orderStatus = '/order_status';
  static const orders = '/orders';
  static const settings = '/settings';
  static const menu = '/menu';
  static const adminLogin = '/admin/login';
  static const adminProducts = '/admin/products';
  static const adminProductForm = '/admin/product-form';
  static const adminUsers = '/admin/users';
  static const adminOrders = '/admin/orders';
  static const adminHome = '/admin/home';

  static final routes = <String, WidgetBuilder>{
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    product: (context) => const ProductDetailScreen(),
    cart: (context) => const CartScreen(),
    checkout: (context) => const CheckoutScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    orderConfirmation: (context) => const OrderConfirmationScreen(),
    orderStatus: (context) => const OrderStatusScreen(),
    orders: (context) => const OrdersScreen(),
    settings: (context) => const SettingsScreen(),
    menu: (context) => const MenuScreen(),
    adminLogin: (context) => const AdminLoginScreen(),
    adminProducts: (context) => const ProductListScreen(),
    adminProductForm: (context) => const ProductFormScreen(),
    adminUsers: (context) => const UserListScreen(),
    adminOrders: (context) => const AdminOrdersScreen(),
    adminHome: (context) => const AdminHomeScreen(),
  };
}
