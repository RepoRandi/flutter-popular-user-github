import 'dart:async';

import 'package:popular_user_github/models/user.dart';
import 'package:popular_user_github/repositories/user_repository.dart';

class UserListBloc {
  final UserRepository _userRepository = UserRepository();
  final _usersController = StreamController<List<User>>();

  Stream<List<User>> get users => _usersController.stream;

  Future<void> fetchUsers() async {
    try {
      final userList = await _userRepository.fetchUsers();
      _usersController.add(userList);
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  void dispose() {
    _usersController.close();
  }
}
