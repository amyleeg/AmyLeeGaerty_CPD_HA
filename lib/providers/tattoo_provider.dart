import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TattooProvider extends ChangeNotifier {
  final Set<int> _likedTattooIds = {};

  TattooProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadLikes();
  }

  bool isLiked(int tattooId) {
    return _likedTattooIds.contains(tattooId);
  }

  void toggleLike(int tattooId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'favorite_tattoo',
      parameters: {
        'tattoo_id': tattooId,
      },
    );
    if (_likedTattooIds.contains(tattooId)) {
      _likedTattooIds.remove(tattooId);
    } else {
      _likedTattooIds.add(tattooId);
    }
    _saveLikes();
    notifyListeners();
  }

  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList('liked_tattoos') ?? [];
    _likedTattooIds
      ..clear()
      ..addAll(storedIds.map(int.parse));
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
