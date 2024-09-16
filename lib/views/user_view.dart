import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class UsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Management'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).fetchUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<UserProvider>(
              builder: (ctx, userProvider, _) => ListView.builder(
                itemCount: userProvider.users.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(userProvider.users[i].name),
                  subtitle: Text(userProvider.users[i].email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditUserDialog(context, userProvider.users[i]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              context, userProvider, userProvider.users[i].id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateUserDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Create user dialog
  void _showCreateUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'User Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'User Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true, // To hide the password
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newUser = User(
                  id: 0, // Placeholder, will be set by the backend
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(), status: '',
                );
                Provider.of<UserProvider>(context, listen: false)
                    .addUser(newUser);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Edit user dialog
  void _showEditUserDialog(BuildContext context, User user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final passwordController =
        TextEditingController(); // Leave empty for security reasons

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'User Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'User Email'),
              ),
              TextField(
                controller: passwordController,
                decoration:
                    InputDecoration(labelText: 'New Password (optional)'),
                obscureText: true, // To hide the password
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedUser = User(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text.isEmpty
                      ? user.password
                      : passwordController
                          .text, // Only update if new password provided
                  createdAt: user.createdAt,
                  updatedAt: DateTime.now(), status: '',
                );
                Provider.of<UserProvider>(context, listen: false)
                    .updateUser(user.id, updatedUser);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Confirm delete dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, UserProvider provider, int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteUser(userId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
