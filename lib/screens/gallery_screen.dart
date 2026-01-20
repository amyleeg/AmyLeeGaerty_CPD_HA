import 'package:flutter/material.dart';
import 'package:ink_log/screens/planner_screen.dart';
import 'package:provider/provider.dart';
import '../providers/tattoo_provider.dart';
import '../models/tattoo.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});

  final List<Tattoo> tattoos = [
    Tattoo(id: 1, title: 'Minimal Rose', imagePath: ''),
    Tattoo(id: 2, title: 'Geometric Wolf', imagePath: ''),
    Tattoo(id: 3, title: 'Traditional Skull', imagePath: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final tattooProvider = Provider.of<TattooProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tattoo Gallery')),

      body: ListView.builder(
        itemCount: tattoos.length,
        itemBuilder: (context, index) {
          final tattoo = tattoos[index];
          final isLiked = tattooProvider.isLiked(tattoo.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.brush),
              title: Text(tattoo.title),
              subtitle: const Text('Tap heart to save inspiration'),
              trailing: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  tattooProvider.toggleLike(tattoo.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
