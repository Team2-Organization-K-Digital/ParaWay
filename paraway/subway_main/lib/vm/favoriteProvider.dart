import 'package:flutter/material.dart';
import 'package:subway_main/model/user_favorite.dart';
import 'package:subway_main/vm/database_handler.dart';

class FavoriteProvider with ChangeNotifier {
  List<UserFavorite> _favorites = [];

  List<UserFavorite> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await DatabaseHandler().favoriteQuery();
    notifyListeners();
  }

  Future<void> addFavorite(UserFavorite favorite) async {
    await DatabaseHandler().favoriteInsert(favorite);
    await loadFavorites();
  }

  Future<void> deleteFavorite(int seq) async {
    await DatabaseHandler().favoriteDelete(seq);
    await loadFavorites();
  }
}
