import 'package:flutter/material.dart';
import 'package:ink_log/providers/session_provider.dart';
import 'package:ink_log/screens/favorite_tattoos_screen.dart';
import 'package:ink_log/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'providers/tattoo_provider.dart';
import 'screens/gallery_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/saved_sessions_screen.dart';
import '../data/tattoos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TattooProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: const InkLogApp(),
    ),
  );
}

class InkLogApp extends StatelessWidget {
  const InkLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InkLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromARGB(255, 81, 81, 81),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeNavigation(),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      GalleryScreen(),
      PlannerScreen(),
      SavedSessionsScreen(),
      FavoriteTattoosScreen(allTattoos: tattoos),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Planner',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Sessions'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
