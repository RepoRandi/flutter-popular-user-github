import 'package:flutter/material.dart';
import 'package:popular_user_github/features/user_detail/user_detail_bloc.dart';
import 'package:popular_user_github/models/user.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final UserDetailBloc _userDetailBloc = UserDetailBloc();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _userDetailBloc.fetchUserDetails(widget.user.login ?? '');
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    bool favoriteStatus =
        await _userDetailBloc.checkFavoriteStatus(widget.user);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  Future<void> _addToFavorites(User user) async {
    if (isFavorite) {
      await _userDetailBloc.removeFromFavorites(user);
    } else {
      await _userDetailBloc.addToFavorites(user);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail User'),
        actions: [
          IconButton(
            onPressed: () async {
              await _addToFavorites(widget.user);
            },
            icon: isFavorite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: _userDetailBloc.userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final User userDetail = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(userDetail.avatarUrl ?? ''),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userDetail.login ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(userDetail.name ?? '-'),
                      const Divider(),
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(userDetail.email ?? '-'),
                      const Divider(),
                      const Text(
                        'Location',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(userDetail.location ?? '-'),
                      const Divider(),
                      const Text(
                        'Company',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(userDetail.company ?? '-'),
                      const Divider()
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _userDetailBloc.dispose();
    super.dispose();
  }
}
