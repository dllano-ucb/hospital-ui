import 'package:flutter/foundation.dart';
import '../models/role.dart';
import '../services/role_service.dart';

class RoleProvider with ChangeNotifier {
  List<Role> _roles = [];

  List<Role> get roles => _roles;

  Future<void> fetchRoles() async {
    _roles = await RoleService.getRoles();
    notifyListeners();
  }

  Future<void> addRole(Role role) async {
    final newRole = await RoleService.createRole(role);
    _roles.add(newRole);
    notifyListeners();
  }

  Future<void> updateRole(int id, Role role) async {
    await RoleService.updateRole(id, role);
    final index = _roles.indexWhere((r) => r.id == id);
    if (index >= 0) {
      _roles[index] = role;
      notifyListeners();
    }
  }

  Future<void> deleteRole(int id) async {
    await RoleService.deleteRole(id);
    _roles.removeWhere((role) => role.id == id);
    notifyListeners();
  }
}
