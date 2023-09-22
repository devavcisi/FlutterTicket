class GelenTalepKart {
  final int id;
  final String sube;
  final int? ownerID;
  final String? ownerName;
  final String? ownerEmail;
  final int? assignedID;
  final String? assignedName;
  final String? assignedLastName;
  final DateTime? assignedDate;
  final int? categoryID;
  final String? categoryName;
  final int? priorityID;
  final String? priorityName;
  final String subject;
  final String message;
  final int? attachmentsID;
  final DateTime? creationDate;


  const GelenTalepKart({
    required this.id,
    required this.sube,
    required this.ownerID,
    required this.ownerName,
    required this.ownerEmail,
    required this.assignedID,
    required this.assignedName,
    required this.assignedLastName,
    required this.assignedDate,
    required this.categoryID,
    required this.categoryName,
    required this.priorityID,
    required this.priorityName,
    required this.subject,
    required this.message,
    required this.attachmentsID,
    required this.creationDate,

  });

  factory GelenTalepKart.fromJson(Map<String, dynamic> json) {
    return GelenTalepKart(
      id: json['id'],
      sube: json['sube'],
      ownerID: json['ownerID'] != null ? json['ownerID'] : null,
      ownerName: json['ownerName'] != null ? json['ownerName'] : null,
      ownerEmail: json['ownerEmail'] != null ? json['ownerEmail'] : null,
      assignedID: json['assignedID'] != null ? json['assignedID'] : null,
      assignedName: json['assignedName'] != null ? json['assignedName'] : null,
      assignedLastName: json['assignedLastName'] != null ? json['assignedLastName'] : null,
      assignedDate: json['assignedDate'] != null ? DateTime.parse(json['assignedDate']) : null,
      categoryID: json['categoryID'] != null ? json['categoryID'] : null,
      categoryName: json['categoryName'],
      priorityID: json['priorityID'] != null ? json['priorityID'] : null,
      priorityName: json['priorityName'],
      subject: json['subject'],
      message: json['message'],
      attachmentsID: json['attachmentsID'] != null ? json['attachmentsID'] : null,
      creationDate: json['creationDate'] != null ? DateTime.parse(json['creationDate']) : null,

    );
  }


}
class GelenTalepKartGoruldulu {
  final int id;
  final String sube;
  final int? ownerID;
  final String? ownerName;
  final String? ownerEmail;
  final int? assignedID;
  final String? assignedName;
  final String? assignedLastName;
  final DateTime? assignedDate;
  final int? categoryID;
  final String? categoryName;
  final int? priorityID;
  final String? priorityName;
  final String subject;
  final String message;
  final int? attachmentsID;
  final DateTime? creationDate;
  final bool gorulduMu;


  const GelenTalepKartGoruldulu({
    required this.id,
    required this.sube,
    required this.ownerID,
    required this.ownerName,
    required this.ownerEmail,
    required this.assignedID,
    required this.assignedName,
    required this.assignedLastName,
    required this.assignedDate,
    required this.categoryID,
    required this.categoryName,
    required this.priorityID,
    required this.priorityName,
    required this.subject,
    required this.message,
    required this.attachmentsID,
    required this.creationDate,
    required this.gorulduMu,

  });

  factory GelenTalepKartGoruldulu.fromJsonGoruldulu(Map<String, dynamic> json, bool gorduMu) {
    return GelenTalepKartGoruldulu(
      id: json['id'],
      sube: json['sube'],
      ownerID: json['ownerID'] != null ? json['ownerID'] : null,
      ownerName: json['ownerName'] != null ? json['ownerName'] : null,
      ownerEmail: json['ownerEmail'] != null ? json['ownerEmail'] : null,
      assignedID: json['assignedID'] != null ? json['assignedID'] : null,
      assignedName: json['assignedName'] != null ? json['assignedName'] : null,
      assignedLastName: json['assignedLastName'] != null ? json['assignedLastName'] : null,
      assignedDate: json['assignedDate'] != null ? DateTime.parse(json['assignedDate']) : null,
      categoryID: json['categoryID'] != null ? json['categoryID'] : null,
      categoryName: json['categoryName'],
      priorityID: json['priorityID'] != null ? json['priorityID'] : null,
      priorityName: json['priorityName'],
      subject: json['subject'],
      message: json['message'],
      attachmentsID: json['attachmentsID'] != null ? json['attachmentsID'] : null,
      creationDate: json['creationDate'] != null ? DateTime.parse(json['creationDate']) : null,
      gorulduMu: gorduMu,

    );
  }

}

