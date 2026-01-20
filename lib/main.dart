import 'package:flutter/material.dart';
import 'package:ink_log/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'providers/tattoo_provider.dart';
import 'screens/gallery_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/saved_sessions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const InkLogApp());
}

class InkLogApp extends StatelessWidget {
  const InkLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TattooProvider(),
      child: const MaterialApp(
        title: 'InkLog',
        debugShowCheckedModeBanner: false,
        home: HomeNavigation(),
      ),
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

  static final List<Widget> _screens = <Widget>[
    GalleryScreen(),
    PlannerScreen(),
    SavedSessionsScreen(),
  ];

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
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Planner',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Saved'),
        ],
      ),
    );
  }
}
