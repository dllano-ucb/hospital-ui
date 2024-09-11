import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/role.dart';

class RoleService {
  static const String apiUrl =
      'http://localhost:5000/api/Roles'; // Replace with your actual API URL

  // Fetch all roles
  static Future<List<Role>> getRoles() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((role) => Role.fromJson(role)).toList();
    } else {
      throw Exception('Failed to load roles');
    }
  }

  // Fetch a single role by id
  static Future<Role> getRole(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Role.fromJson(json.decode(response.body));
    } else {
      throw Exception('Role not found');
    }
  }

  // Create a new role
  static Future<Role> createRole(Role role) async {
    role.createdAt = DateTime.now().toUtc(); // Ensure UTC format
    role.updatedAt = DateTime.now().toUtc(); // Ensure UTC format
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(role.toJson()),
    );
    if (response.statusCode == 201) {
      return Role.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create role');
    }
  }

  // Update an existing role
  static Future<void> updateRole(int id, Role role) async {
    role.updatedAt = DateTime.now().toUtc(); // Ensure UTC format
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(role.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update role');
    }
  }

  // Delete a role
  static Future<void> deleteRole(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete role');
    }
  }
}
