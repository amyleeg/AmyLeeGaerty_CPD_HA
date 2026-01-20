import 'package:flutter/material.dart';

class TattooProvider extends ChangeNotifier {
  List<int> likedTattooIds = [];

  void toggleLike(int id) {
    if (likedTattooIds.contains(id)) {
      likedTattooIds.remove(id);
    } else {
      likedTattooIds.add(id);
    }
    notifyListeners();
  }

  bool isLiked(int id) {
    return likedTattooIds.contains(id);
  }
}
