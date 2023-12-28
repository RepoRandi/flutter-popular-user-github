import 'package:dio/dio.dart';

import 'package:popular_user_github/models/user.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get(
        'https://api.github.com/search/users?q=followers%3A%3E%3D1000&ref=searchresults&s=followers&type=Users',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'];
        final List<User> userList = data.map((e) => User.fromJson(e)).toList();
        return userList;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  Future<User> fetchUserDetail(String login) async {
    try {
      final response = await _dio.get('https://api.github.com/users/$login');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final User userDetail = User.fromJson(data);
        return userDetail;
      } else {
        throw Exception('Failed to load user detail');
      }
    } catch (error) {
      throw Exception('Failed to load user detail: $error');
    }
  }
}
