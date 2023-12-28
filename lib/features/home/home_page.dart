import 'package:flutter/material.dart';
import 'package:popular_user_github/features/favorite/favorite_page.dart';
import 'package:popular_user_github/features/profile/profile_page.dart';
import 'package:popular_user_github/features/user_list/user_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Popular User Github'),
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.deepPurple,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Popular'),
              Tab(text: 'Favorite'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserListPage(),
            FavoritePage(),
          ],
        ),
      ),
    );
  }
}
