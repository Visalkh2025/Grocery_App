class User {
  final String? id;
  final String? username;
  final String? email;
  final String? picture;
  final String? googleId;
  final List<dynamic>? address;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.picture,
    required this.googleId,
    this.address,
  });

  factory User.empty() {
    return User(id: '', username: '', email: '', picture: '', googleId: '', address: []);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      username: json["username"],
      email: json["email"],
      picture: json["picture"],
      googleId: json["googleId"],
      address: json["address"] == null ? [] : List<dynamic>.from(json["address"]!.map((x) => x)),
    );
  }
  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'username': username,
    'picture': picture,
  };
  bool get isEmpty => id!.isEmpty;
  bool get isHavePic => picture != null && picture!.isNotEmpty;
}
