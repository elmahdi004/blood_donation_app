class User {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String dateDeNaissance;
  final String password;
  final String groupSanguin;
  final String address;

  User({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.dateDeNaissance,
    required this.password,
    required this.groupSanguin,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'date_de_naissance': dateDeNaissance,
      'password': password,
      'group_sanguin': groupSanguin,
      'address': address,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      dateDeNaissance: json['date_de_naissance'],
      password: json['password'],
      groupSanguin: json['group_sanguin'],
      address: json['address'],
    );
  }
}
