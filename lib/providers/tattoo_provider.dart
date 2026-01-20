import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TattooProvider with ChangeNotifier {
  final List<int> _likedTattooIds = [];

  List<int> get likedTattooIds => _likedTattooIds;

  TattooProvider() {
    _loadLikes();
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
    prefs.setStringList(
      'liked_tattoos',
      _likedTattooIds.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('liked_tattoos') ?? [];
    _likedTattooIds.clear();
    _likedTattooIds.addAll(saved.map((e) => int.parse(e)));
    notifyListeners();
  }
}
