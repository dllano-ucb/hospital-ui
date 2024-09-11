class Role {
  int id;
  String name;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']).toUtc(), // Convert to UTC
      updatedAt: DateTime.parse(json['updatedAt']).toUtc(), // Convert to UTC
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'createdAt': createdAt.toUtc().toIso8601String(), // Ensure UTC format
      'updatedAt': updatedAt.toUtc().toIso8601String(), // Ensure UTC format
    };
  }
}
