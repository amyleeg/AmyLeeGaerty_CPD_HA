import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TattooProvider extends ChangeNotifier {
  final Set<int> _likedTattooIds = {};

  TattooProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('liked_tattoos') ?? [];
    _likedTattooIds.addAll(saved.map(int.parse));
    notifyListeners(); // updates UI after loading
  }

  bool isLiked(int id) => _likedTattooIds.contains(id);

  void toggleLike(int id) {
    if (_likedTattooIds.contains(id)) {
      _likedTattooIds.remove(id);
    } else {
      _likedTattooIds.add(id);
    }
    _saveLikes();
    notifyListeners();
  }

  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'liked_tattoos',
      _likedTattooIds.map((e) => e.toString()).toList(),
    );
  }
}
