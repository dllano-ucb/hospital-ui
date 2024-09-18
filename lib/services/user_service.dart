import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String apiUrl =
      'http://localhost:5000/api/users'; // Replace with your actual API URL

  // Fetch all Users
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load Users');
    }
  }

  // Fetch a single User by id
  static Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User not found');
    }
  }

  // Create a new User
  static Future<User> createUser(User user) async {
    user.createdAt = DateTime.now().toUtc(); // Ensure UTC format
    user.updatedAt = DateTime.now().toUtc(); // Ensure UTC format
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create User');
    }
  }

  // Update an existing User
  static Future<void> updateUser(int id, User user) async {
    user.updatedAt = DateTime.now().toUtc(); // Ensure UTC format
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update User');
    }
  }

  // Delete a User
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete User');
    }
  }
}
