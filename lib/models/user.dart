class User {
  int id;
  String username;
  String email;
  String passwordHash;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      passwordHash: json['passwordHash'],
      email: json['email'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']).toUtc(), // Convert to UTC
      updatedAt: DateTime.parse(json['updatedAt']).toUtc(), // Convert to UTC
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'status': status,
      'createdAt': createdAt.toUtc().toIso8601String(), // Ensure UTC format
      'updatedAt': updatedAt.toUtc().toIso8601String(), // Ensure UTC format
    };
  }
}
