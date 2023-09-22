
class GelenTalepDetayAttachmentKart {

  final int id;
  final int ticketID;
  final String? attachment;
  final String type;



  GelenTalepDetayAttachmentKart({

    required this.id,
    required this.ticketID,

    this.attachment,
    required this.type,


  });

  factory GelenTalepDetayAttachmentKart.fromJson(Map<String, dynamic> json) {
    return GelenTalepDetayAttachmentKart(

      id: json['id'],
      ticketID: json['ticketID'],
      attachment: json['attachment'],
      type: json['type'],

    );
  }

}

