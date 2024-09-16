import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String apiUrl =
      'http://localhost:5000/api/Users'; 

  // Obtener todos los usuarios
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Obtener un solo usuario por ID
  static Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User not found');
    }
  }

  // Crear un nuevo usuario
  static Future<User> createUser(User user) async {
    user.createdAt = DateTime.now().toUtc(); // Asegurar formato UTC
    user.updatedAt = DateTime.now().toUtc(); // Asegurar formato UTC
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Actualizar un usuario existente
  static Future<void> updateUser(int id, User user) async {
    user.updatedAt = DateTime.now().toUtc(); // Asegurar formato UTC
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update user');
    }
  }

  // Eliminar un usuario
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
