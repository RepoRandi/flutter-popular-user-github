class Profile {
  final String? name;
  final String? email;
  final String? position;
  final String? imagePath;

  Profile({this.name, this.email, this.position, this.imagePath});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      position: map['position'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'position': position,
      'imagePath': imagePath,
    };
  }
}
