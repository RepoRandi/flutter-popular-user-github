import 'package:flutter/material.dart';
import 'package:popular_user_github/features/user_detail/user_detail_page.dart';
import 'package:popular_user_github/features/user_list/user_list_bloc.dart';
import 'package:popular_user_github/models/user.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final UserListBloc _userListBloc = UserListBloc();

  @override
  void initState() {
    super.initState();
    _userListBloc.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: _userListBloc.users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data![index].avatarUrl ?? ''),
                    ),
                    title: Text(snapshot.data![index].login ?? ''),
                    subtitle: Text(snapshot.data![index].type ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserDetailPage(user: snapshot.data![index]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _userListBloc.dispose();
    super.dispose();
  }
}
