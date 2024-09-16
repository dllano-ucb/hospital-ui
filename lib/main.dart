import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/roles_view.dart';
import 'providers/role_provider.dart'; // Import RoleProvider

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => RoleProvider()), // Add RoleProvider
      ],
      child: MaterialApp(
        title: 'User & Role Management',
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User & Role Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Roles'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RolesView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome! Use the menu to navigate.'),
      ),
    );
  }
}
