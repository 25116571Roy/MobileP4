import 'package:flutter/material.dart';

import 'providers/user_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp kini ada di dalam UserProviderWrapper agar themeMode
    // bisa dikendalikan langsung oleh state _isDarkMode
    return const UserProviderWrapper(
      child: HomeScreen(),
    );
  }
}
