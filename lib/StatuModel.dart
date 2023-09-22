class Statu {
  final int id;
  final String statu;


  Statu({
    required this.id,
    required this.statu,

  });

  factory Statu.fromJson(Map<String, dynamic> json) {
    return Statu(
        id: json['id'],
        statu: json['statu'],
    );
  }
}
