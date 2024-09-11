import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/role_provider.dart';
import '../models/role.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RoleProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roles CRUD',
      home: RoleScreen(),
    );
  }
}

class RoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roles'),
      ),
      body: FutureBuilder(
        future: Provider.of<RoleProvider>(context, listen: false).fetchRoles(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<RoleProvider>(
              builder: (ctx, roleProvider, _) => ListView.builder(
                itemCount: roleProvider.roles.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(roleProvider.roles[i].name),
                  subtitle: Text(roleProvider.roles[i].status),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditRoleDialog(context, roleProvider.roles[i]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              context, roleProvider, roleProvider.roles[i].id);
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
          _showCreateRoleDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Create role dialog
  void _showCreateRoleDialog(BuildContext context) {
    final nameController = TextEditingController();
    String statusValue = "Active"; // Default selection

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Role Name'),
              ),
              DropdownButtonFormField<String>(
                value: statusValue,
                decoration: InputDecoration(labelText: 'Role Status'),
                items: [
                  DropdownMenuItem(child: Text("Active"), value: "Active"),
                  DropdownMenuItem(child: Text("Inactive"), value: "Inactive"),
                ],
                onChanged: (value) {
                  statusValue = value!;
                },
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
                final newRole = Role(
                  id: 0, // Placeholder, will be set by the backend
                  name: nameController.text,
                  status: statusValue,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                Provider.of<RoleProvider>(context, listen: false)
                    .addRole(newRole);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Edit role dialog
  void _showEditRoleDialog(BuildContext context, Role role) {
    final nameController = TextEditingController(text: role.name);
    String statusValue = role.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Role Name'),
              ),
              DropdownButtonFormField<String>(
                value: statusValue,
                decoration: InputDecoration(labelText: 'Role Status'),
                items: [
                  DropdownMenuItem(child: Text("Active"), value: "Active"),
                  DropdownMenuItem(child: Text("Inactive"), value: "Inactive"),
                ],
                onChanged: (value) {
                  statusValue = value!;
                },
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
                final updatedRole = Role(
                  id: role.id,
                  name: nameController.text,
                  status: statusValue,
                  createdAt: role.createdAt,
                  updatedAt: DateTime.now(),
                );
                Provider.of<RoleProvider>(context, listen: false)
                    .updateRole(role.id, updatedRole);
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
      BuildContext context, RoleProvider provider, int roleId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Role'),
          content: Text('Are you sure you want to delete this role?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteRole(roleId);
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
