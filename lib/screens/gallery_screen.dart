import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tattoo_provider.dart';
import '../models/tattoo.dart';
import '../data/tattoos.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});

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
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  tattoo.imagePath,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tattoo.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        tattooProvider.isLiked(tattoo.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => tattooProvider.toggleLike(tattoo.id),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
