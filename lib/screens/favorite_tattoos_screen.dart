import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tattoo_provider.dart';
import '../models/tattoo.dart';

class FavoriteTattoosScreen extends StatelessWidget {
  final List<Tattoo> allTattoos;

  const FavoriteTattoosScreen({super.key, required this.allTattoos});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TattooProvider>(context);
    final likedTattoos =
        allTattoos.where((t) => provider.isLiked(t.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Tattoos')),
      body: likedTattoos.isEmpty
          ? const Center(child: Text('No favorite tattoos yet.'))
          : ListView.builder(
              itemCount: likedTattoos.length,
              itemBuilder: (context, index) {
                final tattoo = likedTattoos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                              provider.isLiked(tattoo.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () => provider.toggleLike(tattoo.id),
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
