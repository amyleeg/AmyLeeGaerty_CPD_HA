import 'package:flutter/material.dart';
import 'package:ink_log/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'providers/tattoo_provider.dart';
import 'screens/gallery_screen.dart';

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
      child: MaterialApp(
        title: 'InkLog',
        theme: ThemeData(primaryColor: Colors.black),
        home: GalleryScreen(),
      ),
    );
  }
}
