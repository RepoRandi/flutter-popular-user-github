import 'dart:async';

import 'package:popular_user_github/data/database_helper/database_helper.dart';
import 'package:popular_user_github/models/user.dart';
import 'package:popular_user_github/repositories/user_repository.dart';

class UserDetailBloc {
  final UserRepository _userDetailRepository = UserRepository();
  final _userDetailsController = StreamController<User?>();

  Stream<User?> get userDetails => _userDetailsController.stream;

  Future<void> fetchUserDetails(String login) async {
    try {
      final user = await _userDetailRepository.fetchUserDetail(login);
      _userDetailsController.add(user);
    } catch (error) {
      throw Exception('Failed to load user details: $error');
    }
  }

  Future<bool> checkFavoriteStatus(User user) async {
    List<User> favorites = await DatabaseHelper.instance.getFavorites();
    return favorites.any((favUser) => favUser.login == user.login);
  }

  Future<void> addToFavorites(User user) async {
    try {
      await DatabaseHelper.instance.insertFavorite(user);
      print('Favorite');
    } catch (e) {
      print('Error saat menambahkan favorit: $e');
    }
  }

  Future<void> removeFromFavorites(User user) async {
    try {
      await DatabaseHelper.instance.removeFavorite(user.login ?? '');
      print('Remove favorite');
    } catch (e) {
      print('Error saat menghapus favorit: $e');
    }
  }

  void dispose() {
    _userDetailsController.close();
  }
}
