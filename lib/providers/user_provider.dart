import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    _users = await UserService.getUsers();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    final newUser = await UserService.createUser(user);
    _users.add(newUser);
    notifyListeners();
  }

  Future<void> updateUser(int id, User user) async {
    await UserService.updateUser(id, user);
    final index = _users.indexWhere((r) => r.id == id);
    if (index >= 0) {
      _users[index] = user;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    await UserService.deleteUser(id);
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }
}
