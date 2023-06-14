class User {
  String? image;
  String email;
  String password;
  String? name;
  double age = 0;
  double weight = 0;
  double height = 0;
  String gender = 'male';

  Map<String, List<dynamic>> map = {};
  Map<String, double> calorieMap = {};

  User.login({required this.email, required this.password});

  User.register(
      {required this.email, required this.name, required this.password});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User.register(
      email: parsedJson['email'] ?? "",
      name: parsedJson['name'] ?? "",
      password: parsedJson['password'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
      "password": password,
    };
  }
}
