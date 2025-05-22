import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart' as app_auth_provider;
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth_provider.AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Fooda',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ),
      ),
    );
  }
}
