import 'dart:async';

import 'package:popular_user_github/data/database_helper/database_helper.dart';
import 'package:popular_user_github/models/user.dart';

class FavoriteBloc {
  final _favoritesController = StreamController<List<User>>.broadcast();

  Stream<List<User>> get favorites => _favoritesController.stream;

  Future<void> getFavorites() async {
    List<User> favorites = await DatabaseHelper.instance.getFavorites();
    _favoritesController.sink.add(favorites);
  }

  Future<void> removeFavorite(String login) async {
    try {
      await DatabaseHelper.instance.removeFavorite(login);
      print('remove favorite');

      getFavorites();
    } catch (e) {
      print('Error saat menghapus favorit: $e');
    }
  }

  void dispose() {
    _favoritesController.close();
  }
}

final favoriteBloc = FavoriteBloc();
