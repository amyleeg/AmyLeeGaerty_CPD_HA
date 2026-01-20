import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tattoo_provider.dart';
import 'screens/gallery_screen.dart';

void main() {
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
