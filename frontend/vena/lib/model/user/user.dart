class User {
  final String uid;
  final String name;
  final String email;
  final String? password;

  User(this.uid, {required this.name, required this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json, [String? password]) {
    return User(
      json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: password,
    );
  }
}
