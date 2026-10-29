import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(name: '', email: '');
  bool _isLoading = true;
  bool _isDarkMode = false;
  int _visitCount = 0;
  List<String> _favorites = [];

  User get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  int get visitCount => _visitCount;
  List<String> get favorites => _favorites;

  UserProvider() {
    _loadInitialData();
  }
  static UserProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<UserProvider>(context, listen: listen);
  }
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    final email = prefs.getString('user_email') ?? '';
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    final visitCount = (prefs.getInt('visit_count') ?? 0) + 1;
    final favorites = prefs.getStringList('favorites') ?? [];

    await prefs.setInt('visit_count', visitCount);

    _user = User(name: name, email: email, isLoggedIn: isLoggedIn);
    _isDarkMode = isDark;
    _visitCount = visitCount;
    _favorites = favorites;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User newUser) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newUser.name);
    await prefs.setString('user_email', newUser.email);
    await prefs.setBool('is_logged_in', newUser.isLoggedIn);

    _user = newUser;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);

    _user = _user.copyWith(name: '', isLoggedIn: false);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }

  Future<void> addFavorite(String item) async {
    final newList = [..._favorites, item];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', newList);
    _favorites = newList;
    notifyListeners();
  }

  Future<void> removeFavorite(String item) async {
    final newList = _favorites.where((f) => f != item).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', newList);
    _favorites = newList;
    notifyListeners();
  }
}

class UserProviderWrapper extends StatelessWidget {
  final Widget child;
  const UserProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: child,
    );
  }
}
