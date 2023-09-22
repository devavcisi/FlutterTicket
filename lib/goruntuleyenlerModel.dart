class GoruntuleyenKart {
  final int id;
  final int ticketID;
  final String ticketSubject;
  final int userID;
  final String userName;
  final String userLastname;
  final DateTime tarih;

  GoruntuleyenKart({
    required this.id,
    required this.ticketID,
    required this.ticketSubject,
    required this.userID,
    required this.userName,
    required this.userLastname,
    required this.tarih,
  });

  factory GoruntuleyenKart.fromJson(Map<String, dynamic> json) {
    return GoruntuleyenKart(
        id: json['id'],
        ticketID: json['ticketID'],
        ticketSubject: json['ticketSubject'],
        userID: json['userID'],
        userName: json['userName'],
        userLastname: json['userLastname'],
        tarih: DateTime.parse(json['tarih']));
  }
}