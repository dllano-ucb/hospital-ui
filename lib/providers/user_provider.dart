import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  // Obtener la lista de usuarios
  Future<void> fetchUsers() async {
    _users = await UserService.getUsers();
    notifyListeners();
  }

  // Añadir un nuevo usuario
  Future<void> addUser(User user) async {
    final newUser = await UserService.createUser(user);
    _users.add(newUser);
    notifyListeners();
  }

  // Actualizar un usuario existente
  Future<void> updateUser(int id, User user) async {
    await UserService.updateUser(id, user);
    final index = _users.indexWhere((u) => u.id == id);
    if (index >= 0) {
      _users[index] = user;
      notifyListeners();
    }
  }

  // Eliminar un usuario
  Future<void> deleteUser(int id) async {
    await UserService.deleteUser(id);
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }
}
