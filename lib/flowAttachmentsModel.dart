
class GelenTalepDetayFlowAttachmentKart {

  final int id;
  final int flowID;
  final String attachment;
  final String fileName;
  final String type;



  GelenTalepDetayFlowAttachmentKart({

    required this.id,
    required this.flowID,
    required this.attachment,
    required this.fileName,
    required this.type,


  });

  factory GelenTalepDetayFlowAttachmentKart.fromJson(Map<String, dynamic> json) {
    return GelenTalepDetayFlowAttachmentKart(

      id: json['id'],
      flowID: json['flowID'],
      attachment: json['attachment'],
      fileName: json['fileName'],
      type: json['type'],

    );
  }

}

