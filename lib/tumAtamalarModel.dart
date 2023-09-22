class TumAtamalarKart {
  final int id;
  final String sube;
  final int? ownerID;
  final int? assignedID;
  final DateTime? assignedDate;
  final int? categoryID;
  final String? categoryName;
  final int? priorityID;
  final String? priorityName;
  final String subject;
  final String message;
  final int? attachmentsID;
  final DateTime? creationDate;

  TumAtamalarKart({
    required this.id,
    required this.sube,
    required this.ownerID,
    required this.assignedID,
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

  factory TumAtamalarKart.fromJson(Map<String, dynamic> json) {
    return TumAtamalarKart(
      id: json['id'],
      sube: json['sube'],
      ownerID: json['ownerID'] != null ? json['ownerID'] : null,
      assignedID: json['assignedID'] != null ? json['assignedID'] : null,
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