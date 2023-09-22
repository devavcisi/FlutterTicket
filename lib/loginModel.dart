class GirisKart {
  final int id;
  final String username;
  final String pass;
  final String name;
  final String lastname;
  final bool yonetici;

  GirisKart({
    required this.id,
    required this.username,
    required this.pass,
    required this.name,
    required this.lastname,
    required this.yonetici,
  });

  factory GirisKart.fromJson(Map<String, dynamic> json) {
    return GirisKart(
        id: json['id'],
        username: json['username'],
        pass: json['pass'],
        name: json['name'],
        lastname: json['lastname'],
        yonetici: json['yonetici']);
  }
}
