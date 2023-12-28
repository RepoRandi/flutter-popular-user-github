import 'package:flutter/material.dart';
import 'package:popular_user_github/features/favorite/favorite_bloc.dart';
import 'package:popular_user_github/models/user.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late bool _isDisposed;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    favoriteBloc.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: favoriteBloc.favorites,
        builder: (context, snapshot) {
          if (_isDisposed) {
            return const Center(child: Text('Bloc is disposed.'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<User> favorites = snapshot.data ?? [];
            if (favorites.isEmpty) {
              return const Center(child: Text('Tidak ada item favorit.'));
            } else {
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(favorites[index].avatarUrl ?? ''),
                      ),
                      title: Text(favorites[index].login ?? ''),
                      subtitle: const Text('Favorite'),
                      trailing: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onTap: () {
                        favoriteBloc
                            .removeFavorite(favorites[index].login ?? '');
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
