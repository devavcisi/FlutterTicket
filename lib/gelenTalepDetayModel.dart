class GelenTalepDetayKart {
  final int id;
  final int ticketID;
  final int? supporterID;
  final String? supporterName;
  final String? supporterLastName;
  final String? answer;
  final int? attachmentID;
  final dynamic? attachment; // JSON içeriğine göre tipi güncellenebilir
  final int statuID;
  final String statu;
  final DateTime actionDate;

  GelenTalepDetayKart({
    required this.id,
    required this.ticketID,
    this.supporterID,
    this.supporterName,
    this.supporterLastName,
    this.answer,
    required this.attachmentID,
    this.attachment,
    required this.statuID,
    required this.statu,
    required this.actionDate,
  });

  factory GelenTalepDetayKart.fromJson(Map<String, dynamic> json) {
    return GelenTalepDetayKart(
        id: json['id'],
        ticketID: json['ticketID'],
        supporterID: json['supporterID'],
        supporterName: json['supporterName'],
        supporterLastName: json['supporterLastName'],
        answer: json['answer'],
        attachmentID: json['attachmentID'],
        attachment: json['attachment'],
        statuID: json['statuID'],
        statu: json['statu'],
        actionDate: DateTime.parse(json['actionDate']),
        );
    }

}