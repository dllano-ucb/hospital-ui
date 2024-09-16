class User {
  int id;
  String name;
  String email;
  String password;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Crear una instancia de User a partir de un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      email: json['email'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']).toUtc(), // Convertir a UTC
      updatedAt: DateTime.parse(json['updatedAt']).toUtc(), // Convertir a UTC
    );
  }

  // Convertir una instancia de User a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'status': status,
      'createdAt': createdAt.toUtc().toIso8601String(), // Asegurar formato UTC
      'updatedAt': updatedAt.toUtc().toIso8601String(), // Asegurar formato UTC
    };
  }
}
