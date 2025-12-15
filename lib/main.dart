import 'package:flutter/material.dart';
import 'package:studi_kasus_flutter_habit_tracker/pages/home_page.dart';
import 'package:studi_kasus_flutter_habit_tracker/pages/onboarding_page.dart';
import 'package:studi_kasus_flutter_habit_tracker/services/notification_service.dart';
import 'package:studi_kasus_flutter_habit_tracker/utils/shared_pref.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().init();
  bool isOnboarded = await SharedPref.isOnboarded();
  bool isDarkMode = await SharedPref.getThemeMode();
  runApp(MyApp(isOnboarded: isOnboarded, isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isOnboarded;
  final bool isDarkMode;

  const MyApp({super.key, required this.isOnboarded, required this.isDarkMode});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void changeTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
      SharedPref.setThemeMode(isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: widget.isOnboarded ? const HomePage() : const OnboardingPage(),
    );
  }
}
