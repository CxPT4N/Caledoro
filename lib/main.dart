import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/hive_service.dart';
import 'screens/home_widget_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/pomodoro_settings_screen.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const ProviderScope(child: CaledoroApp()));
}

class CaledoroApp extends ConsumerStatefulWidget {
  const CaledoroApp({super.key});

  @override
  ConsumerState<CaledoroApp> createState() => _CaledoroAppState();
}

class _CaledoroAppState extends ConsumerState<CaledoroApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeWidgetScreen(),
    CalendarScreen(),
    PomodoroSettingsScreen(),
  ];

  void _onNavSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Caledoro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        scaffoldBackgroundColor: Colors.black,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavSelected,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Calendar'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
